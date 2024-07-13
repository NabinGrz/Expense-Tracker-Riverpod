import 'package:expense_tracker_flutter/extension/enum_extension.dart';
import 'package:expense_tracker_flutter/extension/sizebox_extension.dart';
import 'package:expense_tracker_flutter/shared/provider/sort_by_provider.dart';
import 'package:expense_tracker_flutter/shared/provider/tab_bar_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SortByWidget extends ConsumerWidget {
  const SortByWidget({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final selectedSort = ref.watch(sortByProvider).value;
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xffDDDDDD),
            )),
        child: Row(
          children: [
            SvgPicture.asset("assets/images/sort.svg"),
            12.wGap,
            Expanded(
              child: DropdownButtonHideUnderline(
                child: DropdownButtonFormField(
                  hint: selectedSort == "None" ? const Text("Sort By") : null,
                  value: selectedSort == "None" ? null : selectedSort,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                  icon: SvgPicture.asset("assets/images/down_arrow.svg"),
                  items: SortBy.values.map(
                    (e) {
                      return DropdownMenuItem(
                        value: e.value,
                        child: Text(e.value),
                      );
                    },
                  ).toList(),
                  onChanged: (val) {
                    if (ref.watch(tabProvider) == SelectedTab.expense) {
                      final sort = val!.enumVal;
                      ref.read(sortByProvider.notifier).selectSortBy(sort);
                    } else {}
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
