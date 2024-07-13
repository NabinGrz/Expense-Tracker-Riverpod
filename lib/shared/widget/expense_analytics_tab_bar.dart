import 'package:expense_tracker_flutter/shared/provider/sort_by_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../provider/tab_bar_provider.dart';

class ExpenseAnalyticTabBar extends ConsumerWidget {
  const ExpenseAnalyticTabBar({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xffF4F6F6),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: tabItem("Expenses", selectedTab: SelectedTab.expense)),
          Expanded(
              child: tabItem("Analytics", selectedTab: SelectedTab.analytic)),
        ],
      ),
    );
  }

  Widget tabItem(String name, {required SelectedTab selectedTab}) {
    return Consumer(builder: (context, ref, _) {
      final tab = ref.watch(tabProvider);
      return InkWell(
        onTap: () {
          ref.read(tabProvider.notifier).selectTab(selectedTab);
          ref.read(sortByProvider.notifier).selectSortBy(SortBy.none);
        },
        child: Container(
          margin: const EdgeInsets.all(4),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(
            // horizontal: 50,
            vertical: 14,
          ),
          decoration: tab != selectedTab
              ? null
              : BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                ),
          child: Text(
            name,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xff666666)),
          ),
        ),
      );
    });
  }
}
