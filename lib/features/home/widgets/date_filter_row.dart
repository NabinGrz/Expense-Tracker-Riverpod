import 'package:expense_tracker_flutter/features/home/provider/home_provider.dart';
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
    animation =
        Tween<Offset>(begin: const Offset(0, -1), end: const Offset(0, 0))
            .animate(curvedAnimation);
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
    return SlideTransition(
      position: animation,
      child: FadeTransition(
        opacity: opacityAnimation,
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xffF4F6F6),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              filterBox("Today", selectedDateFilter: DateFilter.today),
              filterBox("Yesterday", selectedDateFilter: DateFilter.yesterday),
              filterBox("2 Weeks", selectedDateFilter: DateFilter.twoweeks),
              filterBox("Monthly", selectedDateFilter: DateFilter.monthly),
            ],
          ),
        ),
      ),
    );
  }

  Widget filterBox(String name, {required DateFilter selectedDateFilter}) {
    return Consumer(builder: (context, ref, _) {
      final dateFilter = ref.watch(homeEntityProvider).dateFilter;
      return InkWell(
        onTap: () {
          HapticFeedback.mediumImpact();
          ref.read(homeEntityProvider.notifier).selectDate(selectedDateFilter);
          ref.read(homeSortByProvider.notifier).selectSortBy(SortBy.none);
        },
        child: Container(
          padding: dateFilter != selectedDateFilter
              ? const EdgeInsetsDirectional.symmetric(
                  horizontal: 10,
                  vertical: 14,
                )
              : const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
          decoration: dateFilter != selectedDateFilter
              ? null
              : BoxDecoration(
                  color: AppColor.primary,
                ),
          child: Text(
            name,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: dateFilter != selectedDateFilter ? null : Colors.white,
            ),
          ),
        ),
      );
    });
  }
}
