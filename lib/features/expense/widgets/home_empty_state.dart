import 'package:flutter/material.dart';

class HomeEmptyState extends StatelessWidget {
  const HomeEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset("assets/images/empty_expenses.webp", height: 150),
          const Text(
            "Oops...There are no expenses",
            style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w100,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
