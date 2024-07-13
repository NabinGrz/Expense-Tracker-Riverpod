import 'package:expense_tracker_flutter/models/expense_model.dart';

extension SumExtension on Iterable<int> {
  int sum() {
    return fold(0, (previousValue, element) => previousValue + element);
  }
}

// extension ExpenseIterableExtension on Iterable<Expense> {
//   Map<String, int> totalAmountByCategory() {
//     final Map<String, int> totals = {};
//     for (var expense in this) {
//       totals[expense.category] =
//           (totals[expense.category] ?? 0) + (expense.amount ?? 0);
//     }
//     return totals;
//   }
// }
extension ExpenseIterableExtension on Iterable<Expense> {
  Map<String, Map<String, dynamic>> totalAmountByCategory() {
    final Map<String, Map<String, dynamic>> result = {};
    for (var expense in this) {
      if (!result.containsKey(expense.category)) {
        result[expense.category] = {
          'totalAmount': 0,
          'expenses': <Expense>[],
        };
      }
      result[expense.category]!['totalAmount'] =
          (result[expense.category]!['totalAmount'] as int) + expense.amount;
      result[expense.category]!['expenses']!.add(expense);
    }
    return result;
  }
}
