import 'dart:convert';

import 'package:expense_tracker_flutter/constants/app_color.dart';
import 'package:expense_tracker_flutter/extension/date_extension.dart';
import 'package:expense_tracker_flutter/extension/iterable_extension.dart';
import 'package:expense_tracker_flutter/extension/num_extension.dart';
import 'package:expense_tracker_flutter/extension/sizebox_extension.dart';
import 'package:expense_tracker_flutter/features/expense/widgets/analytics_widget.dart';
import 'package:expense_tracker_flutter/shared/widget/expense_analytics_tab_bar.dart';
import 'package:expense_tracker_flutter/shared/widget/expense_tile.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../helper/expense_query_helper.dart';
import '../../../models/expense_model.dart';
import '../../../shared/provider/tab_bar_provider.dart';
import '../provider/filter_provider.dart';
import '../widgets/date_widget.dart';
import '../widgets/filter_date_column_widget.dart';

class FilterScreen extends ConsumerStatefulWidget {
  final bool isSpecificDate;
  const FilterScreen({super.key, required this.isSpecificDate});

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
    ref.listen(dateRangeProvider, (previous, next) {
      final filteredExpenses = expenses.where((element) {
        final expenseDate = DateTime.parse(element.createAt);
        return expenseDate.isDateInRange(next.from, next.to);
      }).toList();
      filteredExpensesSubject.add(null);
      filteredExpensesSubject.add(filteredExpenses);
    });
  }

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    ExpenseQueryHelper.getExpenseAsFuture()?.then((value) {
      expenses = value.docs
          .map((element) => Expense.fromJson(jsonEncode(element.data())))
          .toList();
      if (widget.isSpecificDate) {
        getExpenses(DateTime.now());
      } else {
        final filteredExpenses = expenses.where((element) {
          final expenseDate = DateTime.parse(element.createAt);
          return expenseDate.isDateInRange(
            DateTime.now().subtract(const Duration(days: 6)),
            DateTime.now(),
          );
        }).toList();
        filteredExpensesSubject.add(null);
        filteredExpensesSubject.add(filteredExpenses);
      }
    });
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  void getExpenses(DateTime date) {
    final filteredExpenses = expenses.where((element) {
      final expenseDate = DateTime.parse(element.createAt);
      return expenseDate.isSameDateAs(date);
    }).toList();
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
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;

        final expenseAmount = snapshot.data?.map((e) => e.amount).sum();
        final groupedExpense = snapshot.data?.expensesByDate();
        final sortedDates = groupedExpense?.entries.toList()
          ?..sort((a, b) {
            final x = a.key;
            final y = b.key;
            return x.compareTo(y);
          });

        final expenseGroup = snapshot.data?.totalAmountByCategory();
        final sortedCategories = expenseGroup?.entries.toList()
          ?..sort((a, b) {
            final x = a.value['totalAmount'] as int;
            final y = b.value['totalAmount'] as int;
            return x.compareTo(y);
          });
        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: theme.scaffoldBackgroundColor,
            toolbarHeight: 0,
            elevation: 0,
            // title: Text(
            //     widget.isSpecificDate ? "Select Date" : "Select Date Range"),
          ),
          body: CustomScrollView(
            shrinkWrap: true,
            controller: _scrollController,
            // physics: const ClampingScrollPhysics(),
            slivers: [
              Consumer(
                builder: (context, ref, _) {
                  DateRangeModel watchDateRange = ref.watch(dateRangeProvider);
                  final fromDate = watchDateRange.from;
                  final toDate = watchDateRange.to;
                  DateRangeNotifier controller = ref.read(
                    dateRangeProvider.notifier,
                  );
                  return SliverToBoxAdapter(
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(
                              isDark ? 0.3 : 0.04,
                            ),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: widget.isSpecificDate
                          ? FilterDateColumnWidget(
                              title: "Date",
                              val: ref.watch(selectedDateProvider),
                              onTap: () async {
                                final selectedDate = await showDatePicker(
                                  context: context,
                                  firstDate: DateTime.now().subtract(
                                    const Duration(days: 200),
                                  ),
                                  lastDate: DateTime.now(),
                                  initialDate: ref.watch(selectedDateProvider),
                                  builder: (context, child) {
                                    return Theme(
                                      data: Theme.of(context).copyWith(
                                        colorScheme: isDark
                                            ? const ColorScheme.dark(
                                                primary: Color(0xff80cbc4),
                                              )
                                            : ColorScheme.light(
                                                primary: AppColor.primary,
                                              ),
                                      ),
                                      child: child!,
                                    );
                                  },
                                );
                                ref
                                    .read(selectedDateProvider.notifier)
                                    .update(
                                      (state) => selectedDate ?? DateTime.now(),
                                    );
                              },
                            )
                          : Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: FilterDateColumnWidget(
                                        title: "From",
                                        val: ref.watch(
                                          dateRangeProvider.select(
                                            (value) => value.from,
                                          ),
                                        ),
                                        onTap: () async {
                                          final selectedDate = await showDatePicker(
                                            barrierDismissible: false,
                                            context: context,
                                            firstDate: DateTime.now().subtract(
                                              const Duration(days: 200),
                                            ),
                                            lastDate: DateTime.now(),
                                            initialDate: fromDate,
                                            builder: (context, child) {
                                              return Theme(
                                                data: Theme.of(context).copyWith(
                                                  colorScheme:
                                                      Theme.of(
                                                            context,
                                                          ).brightness ==
                                                          Brightness.dark
                                                      ? const ColorScheme.dark(
                                                          primary: Color(
                                                            0xff80cbc4,
                                                          ),
                                                        )
                                                      : ColorScheme.light(
                                                          primary:
                                                              AppColor.primary,
                                                        ),
                                                ),
                                                child: child!,
                                              );
                                            },
                                          );
                                          controller.updateFromDate(
                                            selectedDate ?? fromDate,
                                          );

                                          if (selectedDate != null) {
                                            if (selectedDate.isAfter(toDate) ||
                                                selectedDate.isSameDateAs(
                                                  selectedDate,
                                                )) {
                                              final newToDate = selectedDate
                                                  .add(
                                                    const Duration(days: 30),
                                                  );
                                              controller.updateToDate(
                                                newToDate,
                                              );
                                            }
                                          }
                                        },
                                      ),
                                    ),
                                    16.wGap,
                                    Expanded(
                                      child: FilterDateColumnWidget(
                                        title: "To",
                                        val: ref.watch(
                                          dateRangeProvider.select(
                                            (value) => value.to,
                                          ),
                                        ),
                                        onTap: () async {
                                          final selectedDate = await showDatePicker(
                                            barrierDismissible: false,
                                            context: context,
                                            firstDate: fromDate.add(
                                              const Duration(days: 1),
                                            ),
                                            lastDate: DateTime.now().add(
                                              const Duration(days: 200),
                                            ),
                                            initialDate: toDate,
                                            builder: (context, child) {
                                              return Theme(
                                                data: Theme.of(context).copyWith(
                                                  colorScheme:
                                                      Theme.of(
                                                            context,
                                                          ).brightness ==
                                                          Brightness.dark
                                                      ? const ColorScheme.dark(
                                                          primary: Color(
                                                            0xff80cbc4,
                                                          ),
                                                        )
                                                      : ColorScheme.light(
                                                          primary:
                                                              AppColor.primary,
                                                        ),
                                                ),
                                                child: child!,
                                              );
                                            },
                                          );

                                          controller.updateToDate(
                                            selectedDate ?? toDate,
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                    ),
                  );
                },
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  8.hGap,
                  Divider(color: Colors.grey[100], thickness: 1),
                  8.hGap,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Expenses List",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        2.hGap,
                        Text(
                          "Total Amount: Rs ${expenseAmount?.toCurrency}",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.grey[400] : Colors.grey,
                          ),
                        ),
                        16.hGap,
                        const ExpenseAnalyticTabBar(isFilter: true),
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
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            ),
                          ),
                        )
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                DateWidget(
                                  day: day,
                                  weekDay: weekDay,
                                  month: month,
                                  expenses: expenses,
                                ),
                                ListView.separated(
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 18,
                                  ),
                                  shrinkWrap: true,
                                  itemCount: expenses?.length ?? 0,
                                  separatorBuilder: (context, index) => 18.hGap,
                                  itemBuilder: (context, index) {
                                    final expense = expenses?[index];

                                    return ExpenseTile(
                                      isFilter: true,
                                      expenseData: expense,
                                    );
                                  },
                                ),
                              ],
                            );
                          },
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: AnalyticsWidget(
                            sortedCategories: sortedCategories,
                          ),
                        ),
                  120.hGap,
                ]),
              ),
            ],
          ),
        );
      },
    );
  }
}
