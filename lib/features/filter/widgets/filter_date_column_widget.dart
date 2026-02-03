import 'package:expense_tracker_flutter/extension/date_extension.dart';
import 'package:expense_tracker_flutter/extension/sizebox_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../constants/app_color.dart';

class FilterDateColumnWidget extends StatelessWidget {
  const FilterDateColumnWidget({
    super.key,
    required this.title,
    required this.val,
    required this.onTap,
  });

  final String title;
  final DateTime val;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[800]!.withOpacity(0.5) : Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  CupertinoIcons.calendar,
                  size: 14,
                  color: isDark ? Colors.grey[400] : Colors.blueGrey,
                ),
                6.wGap,
                Text(
                  title.toUpperCase(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.grey[400] : Colors.blueGrey,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            8.hGap,
            Text(
              val.toFormattedDateString(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : AppColor.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
