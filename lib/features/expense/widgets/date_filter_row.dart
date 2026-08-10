import 'package:expense_tracker_flutter/features/expense/provider/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../constants/app_color.dart';
import '../../../shared/provider/sort_by_provider.dart';

class DateFilterRow extends ConsumerStatefulWidget {
  const DateFilterRow({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DateFilterRowState();
}

class _DateFilterRowState extends ConsumerState<DateFilterRow>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<Offset> animation;
  late Animation<double> opacityAnimation;

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    final curvedAnimation = CurvedAnimation(
      parent: animationController,
      curve: Curves.fastOutSlowIn,
    );
    animation = Tween<Offset>(
      begin: const Offset(0, -0.5),
      end: const Offset(0, 0),
    ).animate(curvedAnimation);
    opacityAnimation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);
    super.initState();
    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SlideTransition(
      position: animation,
      child: FadeTransition(
        opacity: opacityAnimation,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xff2A2D32) : const Color(0xffF0F3F3),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Expanded(
                  child: filterBox(
                    "Today",
                    selectedDateFilter: DateFilter.today,
                    isDark: isDark,
                  ),
                ),
                Expanded(
                  child: filterBox(
                    "Yesterday",
                    selectedDateFilter: DateFilter.yesterday,
                    isDark: isDark,
                  ),
                ),
                Expanded(
                  child: filterBox(
                    "2 Weeks",
                    selectedDateFilter: DateFilter.twoweeks,
                    isDark: isDark,
                  ),
                ),
                Expanded(
                  child: filterBox(
                    "Monthly",
                    selectedDateFilter: DateFilter.monthly,
                    isDark: isDark,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget filterBox(
    String name, {
    required DateFilter selectedDateFilter,
    required bool isDark,
  }) {
    return Consumer(
      builder: (context, ref, _) {
        final dateFilter = ref.watch(
          homeEntityProvider.select((value) => value.dateFilter),
        );
        final isSelected = dateFilter == selectedDateFilter;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                HapticFeedback.selectionClick();
                ref
                    .read(homeEntityProvider.notifier)
                    .selectDate(selectedDateFilter);
                ref.read(homeSortByProvider.notifier).selectSortBy(SortBy.none);
              },
              borderRadius: BorderRadius.circular(12),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColor.primary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColor.primary.withValues(alpha: 0.25),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  name,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                    color: isSelected
                        ? Colors.white
                        : (isDark ? Colors.grey[400] : const Color(0xff616161)),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
