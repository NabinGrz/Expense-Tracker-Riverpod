import 'dart:convert';

import 'package:expense_tracker_flutter/constants/app_color.dart';
import 'package:expense_tracker_flutter/extension/date_extension.dart';
import 'package:expense_tracker_flutter/extension/iterable_extension.dart';
import 'package:expense_tracker_flutter/extension/num_extension.dart';
import 'package:expense_tracker_flutter/extension/sizebox_extension.dart';
import 'package:expense_tracker_flutter/features/filter/widgets/fiter_range_header_widget.dart';
import 'package:expense_tracker_flutter/features/home/widgets/analytics_widget.dart';
import 'package:expense_tracker_flutter/features/home/widgets/category_expense.dart';
import 'package:expense_tracker_flutter/shared/widget/expense_analytics_tab_bar.dart';
import 'package:expense_tracker_flutter/shared/widget/expense_tile.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../helper/expense_query_helper.dart';
import '../../../models/expense_model.dart';
import '../../../shared/provider/tab_bar_provider.dart';
import '../provider/filter_provider.dart';
import '../widgets/date_widget.dart';
import '../widgets/fiter_specific_date_header_widget.dart';

class FilterScreen extends ConsumerStatefulWidget {
  final bool isSpecificDate;
  const FilterScreen({
    super.key,
    required this.isSpecificDate,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FilterScreenState();
}

class _FilterScreenState extends ConsumerState<FilterScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final ScrollController _scrollController = ScrollController();

  List<Expense> expenses = [];
  void listenToDateChange() {
    ref.listen(selectedDateProvider, (previous, next) => getExpenses(next));
  }

  void listenToDateRangeChange() {
    ref.listen(
      dateRangeProvider,
      (previous, next) {
        final filteredExpenses = expenses.where(
          (element) {
            final expenseDate = DateTime.parse(element.createAt);
            return expenseDate.isDateInRange(next.from, next.to);
          },
        ).toList();
        filteredExpensesSubject.add(null);
        filteredExpensesSubject.add(filteredExpenses);
      },
    );
  }

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    ExpenseQueryHelper.getExpenseAsFuture()?.then(
      (value) {
        expenses = value.docs
            .map((element) => Expense.fromJson(jsonEncode(element.data())))
            .toList();
        if (widget.isSpecificDate) {
          getExpenses(DateTime.now());
        } else {
          final filteredExpenses = expenses.where(
            (element) {
              final expenseDate = DateTime.parse(element.createAt);
              return expenseDate.isDateInRange(
                  DateTime.now().subtract(const Duration(days: 6)),
                  DateTime.now());
            },
          ).toList();
          filteredExpensesSubject.add(null);
          filteredExpensesSubject.add(filteredExpenses);
        }
      },
    );
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  void getExpenses(DateTime date) {
    final filteredExpenses = expenses.where(
      (element) {
        final expenseDate = DateTime.parse(element.createAt);
        return expenseDate.isSameDateAs(date);
      },
    ).toList();
    filteredExpensesSubject.add(null);
    filteredExpensesSubject.add(filteredExpenses);
  }

  void _scrollListener() {
    if (_scrollController.hasClients) {
      bool isCollapsed = _scrollController.offset > (200 - kToolbarHeight);
      if (ref.watch(isAppBarCollapsed) != isCollapsed) {
        ref.read(isAppBarCollapsed.notifier).update((state) => isCollapsed);
        _toggleFadeCollapsing(isCollapsed);
      }
    }
  }

  void _toggleFadeCollapsing(bool isCollapsed) {
    if (!isCollapsed) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isSpecificDate) {
      listenToDateChange();
    } else {
      listenToDateRangeChange();
    }
    return StreamBuilder<List<Expense>?>(
        stream: filteredExpensesSubject,
        builder: (context, snapshot) {
          final expenseAmount = snapshot.data?.map((e) => e.amount).sum();
          final groupedExpense = snapshot.data?.expensesByDate();
          final sortedDates = groupedExpense?.entries.toList()
            ?..sort(
              (a, b) {
                final x = a.key;
                final y = b.key;
                return x.compareTo(y);
              },
            );

          final expenseGroup = snapshot.data?.totalAmountByCategory();
          final sortedCategories = expenseGroup?.entries.toList()
            ?..sort(
              (a, b) {
                final x = a.value['totalAmount'] as int;
                final y = b.value['totalAmount'] as int;
                return x.compareTo(y);
              },
            );
          return Scaffold(
            backgroundColor: Colors.white,
            body: CustomScrollView(
              shrinkWrap: true,
              controller: _scrollController,
              slivers: [
                SliverAppBar(
                  floating: false,
                  pinned: false,
                  centerTitle: false,
                  foregroundColor: Colors.white,
                  expandedHeight: 200,
                  shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.only(bottomRight: Radius.circular(20))),
                  title: ref.watch(isAppBarCollapsed)
                      ? FadeTransition(
                          opacity: _animation,
                          child: Text(
                            widget.isSpecificDate
                                ? "Select Date"
                                : "Select Range",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : null,
                  flexibleSpace: FlexibleSpaceBar(
                    background: widget.isSpecificDate
                        ? const FilterSpecificHeaderWidget()
                        : const FilterRangeHeaderWidget(),
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate([
                    16.hGap,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Expenses List",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          2.hGap,
                          Text(
                            "Total Amount: Rs ${expenseAmount?.toCurrency}",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              // color: Color(0xff666666),
                              color: Colors.grey,
                            ),
                          ),
                          16.hGap,
                          const ExpenseAnalyticTabBar(
                            isFilter: true,
                          ),
                        ],
                      ),
                    ),
                    20.hGap,
                    !sortedDates.isNotNullAndNotEmpty ||
                            !sortedCategories.isNotNullAndNotEmpty
                        ? const Center(
                            child: Text(
                            "No expenses yet",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 24,
                            ),
                          ))
                        : ref.watch(filterScreentabProvider) ==
                                SelectedTab.expense
                            ? ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: sortedDates?.length ?? 0,
                                padding: EdgeInsets.zero,
                                itemBuilder: (context, index) {
                                  final data = sortedDates?[index];
                                  final expenses = data?.value;
                                  final date = DateTime.parse(data!.key);
                                  final day = date.formatCustomDate('d');
                                  final weekDay = date.formatCustomDate('EEEE');
                                  final month = date.formatCustomDate('MMM y');
                                  expenses?.sort(
                                    (a, b) => a.amount.compareTo(b.amount),
                                  );
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      DateWidget(
                                          day: day,
                                          weekDay: weekDay,
                                          month: month,
                                          expenses: expenses),
                                      ListView.separated(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 18),
                                        shrinkWrap: true,
                                        itemCount: expenses?.length ?? 0,
                                        separatorBuilder: (context, index) =>
                                            18.hGap,
                                        itemBuilder: (context, index) {
                                          final expense = expenses?[index];

                                          return ExpenseTile(
                                              isFilter: true,
                                              expenseData: expense);
                                        },
                                      )
                                    ],
                                  );
                                },
                              )
                            : Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: AnalyticsWidget(
                                  sortedCategories: sortedCategories,
                                ),
                              )
                  ]),
                )
              ],
            ),
          );
        });
  }
}
