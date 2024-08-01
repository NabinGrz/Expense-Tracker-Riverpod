import 'dart:convert';

import 'package:expense_tracker_flutter/constants/app_color.dart';
import 'package:expense_tracker_flutter/extension/date_extension.dart';
import 'package:expense_tracker_flutter/extension/iterable_extension.dart';
import 'package:expense_tracker_flutter/extension/sizebox_extension.dart';
import 'package:expense_tracker_flutter/features/filter/widgets/fiter_range_header_widget.dart';
import 'package:expense_tracker_flutter/features/home/widgets/analytics_widget.dart';
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

class _FilterScreenState extends ConsumerState<FilterScreen> {
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
            appBar: AppBar(
              backgroundColor: AppColor.primary,
              elevation: 0,
              centerTitle: false,
              title: const Text(
                "Filter",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            body: Stack(
              children: [
                widget.isSpecificDate
                    ? const FilterSpecificHeaderWidget()
                    : const FilterRangeHeaderWidget(),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.72,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          20.hGap,
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Expenses List",
                                  style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold,
                                    // color: Color(0xff666666),
                                  ),
                                ),
                                2.hGap,
                                Text(
                                  "Total Amount: Rs $expenseAmount",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xff666666),
                                  ),
                                ),
                                20.hGap,
                                const ExpenseAnalyticTabBar(
                                  isFilter: true,
                                ),
                              ],
                            ),
                          ),
                          30.hGap,
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
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: sortedDates?.length ?? 0,
                                      itemBuilder: (context, index) {
                                        final data = sortedDates?[index];
                                        final expenses = data?.value;
                                        final date = DateTime.parse(data!.key);
                                        final day = date.formatCustomDate('d');
                                        final weekDay =
                                            date.formatCustomDate('EEEE');
                                        final month =
                                            date.formatCustomDate('MMM y');
                                        expenses?.sort(
                                          (a, b) =>
                                              a.amount.compareTo(b.amount),
                                        );
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            DateWidget(
                                                day: day,
                                                weekDay: weekDay,
                                                month: month,
                                                expenses: expenses),
                                            ListView.separated(
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 18),
                                              shrinkWrap: true,
                                              itemCount: expenses?.length ?? 0,
                                              separatorBuilder:
                                                  (context, index) => 18.hGap,
                                              itemBuilder: (context, index) {
                                                final expense =
                                                    expenses?[index];

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
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: AnalyticsWidget(
                                        sortedCategories: sortedCategories,
                                      ),
                                    )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }
}
