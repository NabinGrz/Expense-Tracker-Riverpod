import 'package:expense_tracker_flutter/extension/date_extension.dart';
import 'package:expense_tracker_flutter/extension/sizebox_extension.dart';
import 'package:expense_tracker_flutter/features/filter/widgets/date_card.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../provider/filter_provider.dart';

class FilterSpecificHeaderWidget extends StatefulWidget {
  const FilterSpecificHeaderWidget({
    super.key,
  });

  @override
  State<FilterSpecificHeaderWidget> createState() =>
      _FilterSpecificHeaderWidgetState();
}

final selectedDateController = TextEditingController();

class _FilterSpecificHeaderWidgetState
    extends State<FilterSpecificHeaderWidget> {
  @override
  void dispose() {
    selectedDateController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        selectedDateController.text = DateTime.now().toFormattedDateString();
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 22, bottom: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Select Date",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          16.hGap,
          Row(
            children: [
              Consumer(builder: (context, ref, _) {
                final initialDate = ref.watch(selectedDateProvider);
                return Expanded(
                  child: FilterDateCard(
                      onTap: () async {
                        final selectedDate = await showDatePicker(
                          context: context,
                          firstDate: DateTime.now()
                              .subtract(const Duration(days: 200)),
                          lastDate: DateTime.now(),
                          initialDate: initialDate,
                        );
                        ref
                            .read(selectedDateProvider.notifier)
                            .update((state) => selectedDate ?? DateTime.now());
                        selectedDateController.text =
                            (selectedDate ?? DateTime.now())
                                .toFormattedDateString();
                      },
                      controller: selectedDateController,
                      title: "Date"),
                );
              }),
              60.wGap,
            ],
          )
        ],
      ),
    );
  }
}
