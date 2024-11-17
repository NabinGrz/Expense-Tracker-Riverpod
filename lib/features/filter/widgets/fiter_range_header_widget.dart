import 'package:expense_tracker_flutter/extension/date_extension.dart';
import 'package:expense_tracker_flutter/extension/sizebox_extension.dart';
import 'package:expense_tracker_flutter/features/filter/widgets/date_card.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../constants/app_color.dart';
import '../provider/filter_provider.dart';

class FilterRangeHeaderWidget extends ConsumerStatefulWidget {
  const FilterRangeHeaderWidget({
    super.key,
  });

  @override
  ConsumerState<FilterRangeHeaderWidget> createState() =>
      _FilterRangeHeaderWidgetState();
}

class _FilterRangeHeaderWidgetState
    extends ConsumerState<FilterRangeHeaderWidget> {
  final fromDateController = TextEditingController();
  final toDateController = TextEditingController();
  @override
  void dispose() {
    fromDateController.dispose();
    toDateController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        fromDateController.text = watchDateRange.from.toFormattedDateString();
        toDateController.text = watchDateRange.to.toFormattedDateString();
      },
    );

    super.initState();
  }

  DateRangeModel get watchDateRange => ref.watch(dateRangeProvider);
  DateRangeNotifier get controller => ref.read(dateRangeProvider.notifier);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 22, bottom: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Select Range",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          16.hGap,
          Consumer(builder: (context, ref, _) {
            final fromDate = watchDateRange.from;
            final toDate = watchDateRange.to;
            return Row(
              children: [
                Expanded(
                    child: FilterDateCard(
                        onTap: () async {
                          final selectedDate = await showDatePicker(
                            barrierDismissible: false,
                            context: context,
                            firstDate: DateTime.now()
                                .subtract(const Duration(days: 200)),
                            lastDate: DateTime.now(),
                            initialDate: fromDate,
                          );
                          controller.updateFromDate(selectedDate ?? fromDate);

                          if (selectedDate != null) {
                            if (selectedDate.isAfter(toDate) ||
                                selectedDate.isSameDateAs(selectedDate)) {
                              final newToDate =
                                  selectedDate.add(const Duration(days: 30));
                              controller.updateToDate(newToDate);
                              fromDateController.text =
                                  selectedDate.toFormattedDateString();
                              toDateController.text =
                                  newToDate.toFormattedDateString();
                            }
                          }
                        },
                        controller: fromDateController,
                        title: "From")),
                16.wGap,
                Expanded(
                    child: FilterDateCard(
                  onTap: () async {
                    final selectedDate = await showDatePicker(
                      barrierDismissible: false,
                      context: context,
                      firstDate: fromDate.add(const Duration(days: 1)),
                      lastDate: DateTime.now().add(const Duration(days: 200)),
                      initialDate: toDate,
                    );

                    controller.updateToDate(selectedDate ?? toDate);
                    toDateController.text =
                        (selectedDate ?? toDate).toFormattedDateString();
                  },
                  controller: toDateController,
                  title: "To",
                )),
                30.wGap
              ],
            );
          })
        ],
      ),
    );
  }
}
