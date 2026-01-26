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
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final selectedSort = isFilter != true
        ? ref.watch(homeSortByProvider).value
        : ref.watch(filterScreenSortByProvider).value;
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: const Color(0xffedede6),
          // border: Border.all(
          //   color: const Color(0xffDDDDDD),
          // ),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              "assets/images/sort.svg",
              color: const Color(0xff202122),
            ),
            12.wGap,
            Expanded(
              child: DropdownButtonHideUnderline(
                child: DropdownButtonFormField(
                  // icon: const Icon(Icons.arrow_drop_down_rounded),
                  // dropdownColor: Colors.red,
                  // focusColor: Colors.blue,
                  hint: selectedSort == "None" ? const Text("Sort By") : null,
                  initialValue: selectedSort == "None" ? null : selectedSort,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                  // icon: SvgPicture.asset("assets/images/down_arrow.svg"),
                  // icon: const Icon(
                  //   Icons.arrow_downward,
                  //   color: Colors.black,
                  // ),

                  items: SortBy.values.map(
                    (e) {
                      return DropdownMenuItem(
                        value: e.value,
                        child: Text(e.value),
                      );
                    },
                  ).toList(),
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
