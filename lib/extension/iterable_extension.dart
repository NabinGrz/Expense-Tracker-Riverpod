import 'package:expense_tracker_flutter/models/expense_model.dart';

import '../models/expense_entity.dart';

extension SumExtension on Iterable<int> {
  int sum() {
    return fold(0, (previousValue, element) => previousValue + element);
  }
}

extension ExpenseIterableExtension on Iterable<Expense> {
  Map<String, int> totalAmountByCategory() {
    final Map<String, int> totals = {};
    for (var expense in this) {
      totals[expense.category] =
          (totals[expense.category] ?? 0) + (expense.amount ?? 0);
    }
    return totals;
  }
}
