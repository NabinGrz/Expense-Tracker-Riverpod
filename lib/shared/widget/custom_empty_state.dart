import 'package:expense_tracker_flutter/extension/sizebox_extension.dart';
import 'package:flutter/material.dart';

class CustomEmptyState extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? imagePath;
  final IconData? icon;
  final double iconSize;

  const CustomEmptyState({
    super.key,
    required this.title,
    this.subtitle,
    this.imagePath,
    this.icon,
    this.iconSize = 80,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (imagePath != null)
              Image.asset(imagePath!, height: 150, fit: BoxFit.contain)
            else if (icon != null)
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.grey[800]!.withValues(alpha: 0.3)
                      : Colors.grey[100],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: iconSize,
                  color: isDark ? Colors.grey[600] : Colors.grey[400],
                ),
              ),
            if (imagePath != null || icon != null) 24.hGap,
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.grey[300] : Colors.grey[800],
              ),
            ),
            if (subtitle != null) ...[
              8.hGap,
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: isDark ? Colors.grey[500] : Colors.grey[600],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
