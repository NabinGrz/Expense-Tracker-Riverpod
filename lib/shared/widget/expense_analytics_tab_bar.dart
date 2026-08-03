import 'package:expense_tracker_flutter/constants/app_color.dart';
import 'package:expense_tracker_flutter/shared/provider/sort_by_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xff2A2D32) : const Color(0xffF0F3F3),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: tabItem(
              SelectedTab.expense.value,
              selectedTab: SelectedTab.expense,
              isDark: isDark,
            ),
          ),
          Expanded(
            child: tabItem(
              SelectedTab.analytic.value,
              selectedTab: SelectedTab.analytic,
              isDark: isDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget tabItem(
    String name, {
    required SelectedTab selectedTab,
    required bool isDark,
  }) {
    return Consumer(
      builder: (context, ref, _) {
        final tab = isFilter != true
            ? ref.watch(hometabProvider)
            : ref.watch(filterScreentabProvider);
        final isSelected = tab == selectedTab;

        return Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () {
              HapticFeedback.selectionClick();
              FocusManager.instance.primaryFocus?.unfocus();
              if (isFilter != true) {
                ref.read(hometabProvider.notifier).selectTab(selectedTab);
                ref.read(homeSortByProvider.notifier).selectSortBy(SortBy.none);
              } else {
                ref.read(filterScreentabProvider.notifier).selectTab(selectedTab);
              }
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: isSelected
                  ? BoxDecoration(
                      color: isDark ? const Color(0xff1E293B) : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    )
                  : null,
              child: Text(
                name,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  color: isSelected
                      ? AppColor.primary
                      : (isDark ? Colors.grey[400] : const Color(0xff64748B)),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
