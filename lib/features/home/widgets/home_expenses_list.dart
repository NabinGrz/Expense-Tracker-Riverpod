import 'package:expense_tracker_flutter/extension/iterable_extension.dart';
import 'package:expense_tracker_flutter/extension/sizebox_extension.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rxdart/rxdart.dart';

import '../../../models/expense_model.dart';
import '../../../shared/provider/tab_bar_provider.dart';
import '../../../shared/widget/expense_tile.dart';
import '../provider/home_provider.dart';
import 'analytics_widget.dart';

class HomeExpenseList extends ConsumerStatefulWidget {
  const HomeExpenseList({
    super.key,
  });

  @override
  ConsumerState<HomeExpenseList> createState() => _HomeExpenseListState();
}

class _HomeExpenseListState extends ConsumerState<HomeExpenseList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.read(homeEntityProvider.notifier);
    final homeEntity = ref.watch(homeEntityProvider);
    return StreamBuilder(
      stream: controller.sortedExpenseSubject,
      builder: (context, snapshot) {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) {
            controller.populateExpenses(snapshot.data);
          },
        );
        final expenseGroup = homeEntity.expenses?.totalAmountByCategory();
        final sortedCategories = expenseGroup?.entries.toList()
          ?..sort(
            (a, b) {
              final x = a.value['totalAmount'] as int;
              final y = b.value['totalAmount'] as int;
              return x.compareTo(y);
            },
          );

        return (homeEntity.expenses == null || homeEntity.expenses == [])
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
                    itemCount: homeEntity.expenses?.length ?? 0,
                    separatorBuilder: (context, index) => 12.hGap,
                    itemBuilder: (context, index) {
                      final expenseData = homeEntity.expenses?[index];
                      return ExpenseTile(
                        expenseData: expenseData,
                        isFilter: false,
                      );
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
