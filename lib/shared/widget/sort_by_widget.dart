import 'package:expense_tracker_flutter/extension/enum_extension.dart';
import 'package:expense_tracker_flutter/extension/sizebox_extension.dart';
import 'package:expense_tracker_flutter/shared/provider/sort_by_provider.dart';
import 'package:expense_tracker_flutter/shared/provider/tab_bar_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SortByWidget extends ConsumerWidget {
  final bool? isFilter;
  const SortByWidget({super.key, this.isFilter = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedSort = isFilter != true
        ? ref.watch(homeSortByProvider).value
        : ref.watch(filterScreenSortByProvider).value;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: isDark ? const Color(0xff1E293B) : const Color(0xffF8FAFC),
          border: Border.all(
            color: isDark ? const Color(0xff334155) : const Color(0xffE2E8F0),
          ),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              "assets/images/sort.svg",
              colorFilter: ColorFilter.mode(
                isDark ? Colors.grey[300]! : const Color(0xff475569),
                BlendMode.srcIn,
              ),
              width: 18,
              height: 18,
            ),
            10.wGap,
            Expanded(
              child: DropdownButtonHideUnderline(
                child: DropdownButtonFormField(
                  dropdownColor: isDark ? const Color(0xff1E293B) : Colors.white,
                  hint: selectedSort == "None"
                      ? Text(
                          "Sort By",
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark ? Colors.grey[400] : const Color(0xff64748B),
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      : null,
                  initialValue: selectedSort == "None" ? null : selectedSort,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 10),
                  ),
                  icon: Icon(
                    Icons.unfold_more_rounded,
                    size: 18,
                    color: isDark ? Colors.grey[400] : const Color(0xff64748B),
                  ),
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? Colors.white : const Color(0xff1E293B),
                    fontWeight: FontWeight.w600,
                  ),
                  items: SortBy.values.map((e) {
                    return DropdownMenuItem(
                      value: e.value,
                      child: Text(e.value),
                    );
                  }).toList(),
                  onChanged: (val) {
                    final sort = val!.enumVal;
                    if (isFilter != true) {
                      if (ref.watch(hometabProvider) == SelectedTab.expense) {
                        ref
                            .read(homeSortByProvider.notifier)
                            .selectSortBy(sort);
                      }
                    } else {
                      if (ref.watch(hometabProvider) == SelectedTab.expense) {
                        ref
                            .read(filterScreenSortByProvider.notifier)
                            .selectSortBy(sort);
                      }
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
