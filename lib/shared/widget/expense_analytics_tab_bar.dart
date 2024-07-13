import 'package:expense_tracker_flutter/constants/app_color.dart';
import 'package:expense_tracker_flutter/shared/provider/sort_by_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../provider/tab_bar_provider.dart';

class ExpenseAnalyticTabBar extends ConsumerWidget {
  final bool? isFilter;
  const ExpenseAnalyticTabBar({
    super.key,
    this.isFilter = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.primary.withOpacity(0.1),
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
      final tab = isFilter != true
          ? ref.watch(hometabProvider)
          : ref.watch(filterScreentabProvider);
      return InkWell(
        onTap: () {
          if (isFilter != true) {
            ref.read(hometabProvider.notifier).selectTab(selectedTab);
            ref.read(homeSortByProvider.notifier).selectSortBy(SortBy.none);
          } else {
            ref.read(filterScreentabProvider.notifier).selectTab(selectedTab);
          }
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
