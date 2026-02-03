import 'package:expense_tracker_flutter/shared/widget/custom_empty_state.dart';
import 'package:flutter/material.dart';

class HomeEmptyState extends StatelessWidget {
  const HomeEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomEmptyState(
      imagePath: "assets/images/empty_expenses.webp",
      title: "Oops...There are no expenses",
      subtitle: "Tap + to add your first expense",
    );
  }
}
