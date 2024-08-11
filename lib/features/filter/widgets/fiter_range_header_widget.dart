import 'package:expense_tracker_flutter/extension/date_extension.dart';
import 'package:expense_tracker_flutter/extension/sizebox_extension.dart';
import 'package:expense_tracker_flutter/features/filter/widgets/date_card.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../constants/app_color.dart';
import '../provider/filter_provider.dart';

class FilterRangeHeaderWidget extends StatelessWidget {
  const FilterRangeHeaderWidget({
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
          // 8.hGap,
          const Text(
            "Select Range",
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          4.hGap,
          Consumer(builder: (context, ref, _) {
            final dateRange = ref.watch(dateRangeProvider);
            final fromDate = dateRange.from;
            final toDate = dateRange.to;
            return Row(
              children: [
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "From Date",
                      style: TextStyle(
                        fontSize: 16,
                        // fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    6.hGap,
                    FilterDateCard(
                      date: fromDate,
                      onTap: () async {
                        final date = await showDatePicker(
                          barrierDismissible: false,
                          context: context,
                          firstDate: DateTime.now()
                              .subtract(const Duration(days: 200)),
                          lastDate: DateTime.now(),
                          initialDate: fromDate,
                        );
                        ref
                            .read(dateRangeProvider.notifier)
                            .updateFromDate(date ?? fromDate);

                        if (date != null) {
                          if (
                              //!date.isSameDateAs(toDate) ||
                              date.isAfter(toDate) || date.isSameDateAs(date)) {
                            ref.read(dateRangeProvider.notifier).updateToDate(
                                date.add(const Duration(days: 6)));
                          }
                        }
                      },
                    ),
                  ],
                )),
                16.wGap,
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "To Date",
                      style: TextStyle(
                        fontSize: 16,
                        // fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    6.hGap,
                    FilterDateCard(
                      date: toDate,
                      onTap: () async {
                        final date = await showDatePicker(
                          barrierDismissible: false,
                          context: context,
                          firstDate: fromDate.add(const Duration(days: 1)),
                          lastDate:
                              DateTime.now().add(const Duration(days: 200)),
                          initialDate: toDate,
                        );

                        ref
                            .read(dateRangeProvider.notifier)
                            .updateToDate(date ?? toDate);
                      },
                    ),
                  ],
                )),
                // 20.wGap,
              ],
            );
          })
        ],
      ),
    );
  }
}
