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
          borderRadius: BorderRadius.circular(12),
          color: isDark ? Colors.grey[800] : const Color(0xffedede6),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              "assets/images/sort.svg",
              color: isDark ? Colors.white : const Color(0xff202122),
            ),
            12.wGap,
            Expanded(
              child: DropdownButtonHideUnderline(
                child: DropdownButtonFormField(
                  dropdownColor: theme.cardColor,
                  hint: selectedSort == "None"
                      ? Text(
                          "Sort By",
                          style: TextStyle(
                            color: isDark ? Colors.grey[400] : Colors.black54,
                          ),
                        )
                      : null,
                  initialValue: selectedSort == "None" ? null : selectedSort,
                  decoration: const InputDecoration(border: InputBorder.none),
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: isDark ? Colors.white : Colors.black54,
                  ),
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.white : Colors.black87,
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
