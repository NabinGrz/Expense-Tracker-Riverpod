import 'package:expense_tracker_flutter/extension/date_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FilterDateCard extends ConsumerWidget {
  final DateTime date;
  final void Function() onTap;
  const FilterDateCard({
    super.key,
    required this.date,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: onTap,
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
              date.toFormattedDateString(),
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
  }
}
