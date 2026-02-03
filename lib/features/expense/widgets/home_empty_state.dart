import 'package:flutter/material.dart';

class HomeEmptyState extends StatelessWidget {
  const HomeEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset("assets/images/empty_expenses.webp", height: 150),
          Text(
            "Oops...There are no expenses",
            style: TextStyle(
              color: isDark ? Colors.grey[400] : Colors.grey,
              fontWeight: FontWeight.w100,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
