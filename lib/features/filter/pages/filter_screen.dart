import 'dart:convert';

import 'package:expense_tracker_flutter/constants/app_color.dart';
import 'package:expense_tracker_flutter/extension/date_extension.dart';
import 'package:expense_tracker_flutter/extension/iterable_extension.dart';
import 'package:expense_tracker_flutter/extension/sizebox_extension.dart';
import 'package:expense_tracker_flutter/shared/widget/expense_analytics_tab_bar.dart';
import 'package:expense_tracker_flutter/shared/widget/expense_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../helper/expense_query_helper.dart';
import '../../../models/expense_model.dart';
import '../provider/filter_provider.dart';
import '../widgets/date_widget.dart';

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
  listenToDateChange(List<Expense>? expenses) {
    ref.listen(
      selectedDateProvider,
      (previous, next) {
        final filteredExpenses = expenses?.where(
          (element) {
            final expenseDate = DateTime.parse(element.createAt);
            return expenseDate.isSameDateAs(next);
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
        final filteredExpenses = value.docs.map(
          (element) {
            return Expense.fromJson(jsonEncode(element.data()));
          },
        ).toList();

        filteredExpensesSubject.add(null);
        filteredExpensesSubject.add(filteredExpenses);
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    listenToDateChange(filteredExpensesSubject.valueOrNull);
    return StreamBuilder<List<Expense>?>(
        stream: filteredExpensesSubject,
        builder: (context, snapshot) {
          final expenseAmount = snapshot.data
              ?.map(
                (e) => e.amount,
              )
              .sum();
          final groupedExpense = snapshot.data?.expensesByDate();
          final sortedDates = groupedExpense?.entries.toList()
            ?..sort(
              (a, b) {
                final x = a.key;
                final y = b.key;
                return x.compareTo(y);
              },
            );
          return Scaffold(
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
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: MediaQuery.sizeOf(context).height * 0.2,
                    padding: const EdgeInsets.only(left: 22, bottom: 20),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: AppColor.primary,
                        borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(60),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0XFF02443F).withOpacity(0.3),
                            offset: const Offset(0, 4),
                            blurRadius: 16,
                          )
                        ]),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Select Date",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        6.hGap,
                        Consumer(builder: (context, ref, _) {
                          final selectedDate = ref.watch(selectedDateProvider);
                          return InkWell(
                            onTap: () async {
                              final date = await showDatePicker(
                                  context: context,
                                  firstDate: DateTime.now()
                                      .subtract(const Duration(days: 200)),
                                  lastDate: DateTime.now());

                              ref
                                  .read(selectedDateProvider.notifier)
                                  .update((state) => date ?? DateTime.now());
                            },
                            child: Container(
                              width: MediaQuery.sizeOf(context).width * 0.5,
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.white,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    selectedDate.toFormattedDateString(),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SvgPicture.asset(
                                      "assets/images/calendar_white.svg")
                                ],
                              ),
                            ),
                          );
                        })
                      ],
                    ),
                  ),
                  30.hGap,
                  Column(
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
                      30.hGap,
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: sortedDates?.length ?? 0,
                        itemBuilder: (context, index) {
                          final data = sortedDates?[index];
                          final expenses = data?.value;
                          final date = DateTime.parse(data!.key);
                          final day = date.formatCustomDate('d');
                          final weekDay = date.formatCustomDate('EEEE');
                          final month = date.formatCustomDate('MMM y');
                          // 'd, EEEE, MMM y'
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              DateWidget(
                                  day: day,
                                  weekDay: weekDay,
                                  month: month,
                                  expenses: expenses),
                              ListView.separated(
                                physics: const NeverScrollableScrollPhysics(),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 18),
                                shrinkWrap: true,
                                itemCount: expenses?.length ?? 0,
                                separatorBuilder: (context, index) => 18.hGap,
                                itemBuilder: (context, index) {
                                  final expense = expenses?[index];
                                  return ExpenseTile(expenseData: expense);
                                },
                              )
                            ],
                          );
                        },
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}
