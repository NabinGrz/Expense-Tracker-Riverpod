import 'dart:convert';

import 'package:expense_tracker_flutter/constants/app_color.dart';
import 'package:expense_tracker_flutter/extension/iterable_extension.dart';
import 'package:expense_tracker_flutter/extension/sizebox_extension.dart';
import 'package:expense_tracker_flutter/extension/string_extension.dart';
import 'package:expense_tracker_flutter/extension/date_extension.dart';
import 'package:expense_tracker_flutter/features/home/widgets/category_expense.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rxdart/rxdart.dart';

import '../../../models/expense_model.dart';
import '../../../shared/provider/tab_bar_provider.dart';
import '../../../shared/widget/expense_bar_chart.dart';
import '../../../shared/widget/expense_tile.dart';
import '../provider/home_provider.dart';

class HomeExpenseList extends StatelessWidget {
  const HomeExpenseList({
    super.key,
    required this.sortedExpenseSubject,
    required this.ref,
  });

  final BehaviorSubject<List<Expense>> sortedExpenseSubject;
  final WidgetRef ref;

  void updateTotalAmount(List<Expense>? expenses) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        final amountList = expenses?.map((e) => e.amount);
        ref
            .read(dateFilterProvider.notifier)
            .updateTotalAmount(amountList?.sum() ?? 0);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: sortedExpenseSubject,
      builder: (context, snapshot) {
        final dateType = ref.watch(dateFilterProvider);
        List<Expense>? expenses = [];
        switch (dateType.dateFilter) {
          case DateFilter.today:
            expenses = snapshot.data?.where(
              (element) {
                final expenseDate = DateTime.parse(element.createAt);
                return expenseDate.isSameDateAs(DateTime.now());
              },
            ).toList();
            updateTotalAmount(expenses);
            break;
          case DateFilter.weekly:
            final weeklyDate = DateTime.now().subtract(const Duration(days: 6));
            expenses = snapshot.data?.where(
              (element) {
                final expenseDate = DateTime.parse(element.createAt);
                return expenseDate.isSameDateAs(weeklyDate) ||
                    expenseDate.isAfter(weeklyDate);
              },
            ).toList();
            updateTotalAmount(expenses);
            break;
          case DateFilter.twoweeks:
            final twoWeeks = DateTime.now().subtract(const Duration(days: 13));
            expenses = snapshot.data?.where(
              (element) {
                final expenseDate = DateTime.parse(element.createAt);
                return expenseDate.isSameDateAs(twoWeeks) ||
                    expenseDate.isAfter(twoWeeks);
              },
            ).toList();
            updateTotalAmount(expenses);
            break;
          case DateFilter.monthly:
            final monthly = DateTime.now().subtract(const Duration(days: 29));
            expenses = snapshot.data?.where(
              (element) {
                final expenseDate = DateTime.parse(element.createAt);
                return expenseDate.isSameDateAs(monthly) ||
                    expenseDate.isAfter(monthly);
              },
            ).toList();
            updateTotalAmount(expenses);
            break;
          default:
        }

        final expenseGroup = expenses?.totalAmountByCategory();
        final sortedCategories = expenseGroup?.entries.toList()
          ?..sort(
            (a, b) {
              final x = a.value['totalAmount'] as int;
              final y = b.value['totalAmount'] as int;
              return x.compareTo(y);
            },
          );

        return (expenses == null || expenses.isEmpty)
            ? const Center(child: Text("No Expenses Yet"))
            : ref.watch(tabProvider) == SelectedTab.expense
                ? ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount: expenses.length ?? 0,
                    separatorBuilder: (context, index) => 12.hGap,
                    itemBuilder: (context, index) {
                      final expenseData = expenses?[index];
                      return ExpenseTile(expenseData: expenseData);
                    },
                  )
                : SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.4,
                    child: Wrap(
                      children: List.generate(
                        sortedCategories?.length ?? 0,
                        (index) {
                          final category = sortedCategories?[index];
                          final expenses =
                              category?.value['expenses'] as List<Expense>;
                          return GestureDetector(
                            onTap: () {
                              showCupertinoModalPopup(
                                context: context,
                                builder: (context) => CategoryExpenses(
                                  expenseData: expenses,
                                  name: category?.key,
                                  iconPath: category?.key.getIconPathByCategory,
                                  totalAmount:
                                      category?.value['totalAmount'].toString(),
                                ),
                              );
                            },
                            child: Container(
                              // width: 90,
                              padding: const EdgeInsets.all(6),
                              margin:
                                  const EdgeInsets.only(right: 10, bottom: 10),
                              decoration: BoxDecoration(
                                  // color: AppColor.primary.withOpacity(0.1),
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                        blurRadius: 20,
                                        spreadRadius: -9,
                                        color:
                                            AppColor.primary.withOpacity(0.6),
                                        offset: const Offset(1, 9))
                                  ]),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Hero(
                                    tag: "${category?.key}",
                                    child: Image.asset(
                                      "${category?.key.getIconPathByCategory}",
                                      height: 45,
                                      width: 45,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  6.hGap,
                                  Text(
                                    "Rs: ${category?.value['totalAmount']}",
                                    style: const TextStyle(
                                      fontSize: 10,
                                    ),
                                  ),
                                  Text(
                                    "${category?.key}",
                                    style: const TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
      },
    );
  }

  Widget analyticsWidget(String name) {
    return Text(name);
  }
}
