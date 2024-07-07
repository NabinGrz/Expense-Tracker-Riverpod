import 'package:expense_tracker_flutter/features/home/provider/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../constants/app_color.dart';
import '../../../shared/provider/sort_by_provider.dart';

class DateFilterRow extends ConsumerWidget {
  const DateFilterRow({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 22),
      decoration: BoxDecoration(
        color: const Color(0xffF4F6F6),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          filterBox("Today", selectedDateFilter: DateFilter.today),
          filterBox("Weekly", selectedDateFilter: DateFilter.weekly),
          filterBox("2 Weeks", selectedDateFilter: DateFilter.twoweeks),
          filterBox("Monthly", selectedDateFilter: DateFilter.monthly),
        ],
      ),
    );
  }

  Widget filterBox(String name, {required DateFilter selectedDateFilter}) {
    return Consumer(builder: (context, ref, _) {
      final dateFilter = ref.watch(dateFilterProvider).dateFilter;
      return InkWell(
        onTap: () {
          ref.read(dateFilterProvider.notifier).selectDate(selectedDateFilter);
          ref.read(sortByProvider.notifier).selectSortBy(SortBy.none);
        },
        child: Container(
          padding: dateFilter != selectedDateFilter
              ? const EdgeInsetsDirectional.symmetric(horizontal: 10)
              : const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
          decoration: dateFilter != selectedDateFilter
              ? null
              : BoxDecoration(
                  color: AppColor.primary,
                  borderRadius: BorderRadius.circular(8),
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
