import 'package:expense_tracker_flutter/extension/date_extension.dart';
import 'package:expense_tracker_flutter/extension/iterable_extension.dart';
import 'package:expense_tracker_flutter/extension/sizebox_extension.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../shared/provider/tab_bar_provider.dart';
import '../../../shared/widget/custom_empty_state.dart';
import '../../../shared/widget/expense_tile.dart';
import '../provider/home_provider.dart';
import 'analytics_widget.dart';

class HomeExpenseList extends ConsumerStatefulWidget {
  const HomeExpenseList({super.key});

  @override
  ConsumerState<HomeExpenseList> createState() => _HomeExpenseListState();
}

class _HomeExpenseListState extends ConsumerState<HomeExpenseList> {
  @override
  Widget build(BuildContext context) {
    final controller = ref.read(homeEntityProvider.notifier);
    final homeEntity = ref.watch(homeEntityProvider);
    return StreamBuilder(
      stream: controller.sortedExpenseSubject,
      builder: (context, snapshot) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          controller.populateExpenses(snapshot.data);
        });
        final expenseGroup = homeEntity.expenses?.totalAmountByCategory();
        final sortedCategories = expenseGroup?.entries.toList()
          ?..sort((a, b) {
            final x = a.value['totalAmount'] as int;
            final y = b.value['totalAmount'] as int;
            return x.compareTo(y);
          });

        return (homeEntity.expenses == null || homeEntity.expenses == [])
            ? const Padding(
                padding: EdgeInsets.only(top: 40),
                child: CustomEmptyState(
                  imagePath: "assets/images/empty_expenses.webp",
                  title: "No expenses yet",
                  subtitle: "Tap + to add your first expense",
                ),
              )
            : ref.watch(hometabProvider) == SelectedTab.expense
            ? ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: homeEntity.expenses?.length ?? 0,
                separatorBuilder: (context, index) => 12.hGap,
                itemBuilder: (context, index) {
                  final expenseData = homeEntity.expenses?[index];
                  // if (!DateTime.parse(expenseData!.createAt)
                  //         .isSameDateAs(DateTime.now()) &&
                  //     !DateTime.parse(expenseData!.createAt).isYesterday() &&
                  //     !isFilter) ...{
                  bool isToday = DateTime.parse(
                    expenseData!.createAt,
                  ).isSameDateAs(DateTime.now());
                  bool isYesterday = DateTime.parse(
                    expenseData.createAt,
                  ).isYesterday();
                  // return Text("$isToday - $isYesterday");
                  return ExpenseTile(
                    expenseData: expenseData,
                    showDate: isToday != true && isYesterday != true,
                    isHome: true,
                  );
                },
              )
            : AnalyticsWidget(sortedCategories: sortedCategories);
      },
    );
  }

  Widget analyticsWidget(String name) {
    return Text(name);
  }
}
