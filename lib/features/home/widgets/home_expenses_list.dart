import 'package:expense_tracker_flutter/extension/iterable_extension.dart';
import 'package:expense_tracker_flutter/extension/sizebox_extension.dart';
import 'package:expense_tracker_flutter/extension/date_extension.dart';
import 'package:expense_tracker_flutter/features/home/widgets/analytics_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rxdart/rxdart.dart';

import '../../../models/expense_model.dart';
import '../../../shared/provider/tab_bar_provider.dart';
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
          case DateFilter.yesterday:
            final yesterdayDate =
                DateTime.now().subtract(const Duration(days: 1));
            expenses = snapshot.data?.where(
              (element) {
                final expenseDate = DateTime.parse(element.createAt);
                return expenseDate.isSameDateAs(yesterdayDate);
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
            ? const Center(
                child: Text(
                "No expenses yet",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 24,
                ),
              ))
            : ref.watch(hometabProvider) == SelectedTab.expense
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
                : AnalyticsWidget(
                    sortedCategories: sortedCategories,
                  );
      },
    );
  }

  Widget analyticsWidget(String name) {
    return Text(name);
  }
}
