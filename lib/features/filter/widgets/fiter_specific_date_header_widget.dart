import 'package:expense_tracker_flutter/extension/date_extension.dart';
import 'package:expense_tracker_flutter/extension/sizebox_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../constants/app_color.dart';
import '../provider/filter_provider.dart';

class FilterSpecificHeaderWidget extends StatelessWidget {
  const FilterSpecificHeaderWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: MediaQuery.sizeOf(context).height * 0.16,
      padding: const EdgeInsets.only(left: 22, bottom: 20),
      // width: double.infinity,
      // decoration: BoxDecoration(
      //     color: AppColor.primary,
      //     borderRadius: const BorderRadius.only(
      //       bottomRight: Radius.circular(20),
      //     ),
      //     boxShadow: [
      //       BoxShadow(
      //         color: const Color(0XFF02443F).withOpacity(0.3),
      //         offset: const Offset(0, 4),
      //         blurRadius: 16,
      //       )
      //     ]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // const Text(
          //   "Filter",
          //   style: TextStyle(
          //     fontSize: 28,
          //     fontWeight: FontWeight.bold,
          //     color: Colors.white,
          //   ),
          // ),
          // 8.hGap,
          const Text(
            "Select Date",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          4.hGap,
          Consumer(builder: (context, ref, _) {
            final selectedDate = ref.watch(selectedDateProvider);
            return InkWell(
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  firstDate: DateTime.now().subtract(const Duration(days: 200)),
                  lastDate: DateTime.now(),
                  initialDate: selectedDate,
                );

                ref
                    .read(selectedDateProvider.notifier)
                    .update((state) => date ?? DateTime.now());
              },
              child: Container(
                width: MediaQuery.sizeOf(context).width * 0.5,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.white,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedDate.toFormattedDateString(),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                    SvgPicture.asset("assets/images/calendar_white.svg")
                  ],
                ),
              ),
            );
          })
        ],
      ),
    );
  }
}
