import 'package:expense_tracker_flutter/models/expense_model.dart';

extension SumExtension on Iterable<int> {
  int sum() {
    return fold(0, (previousValue, element) => previousValue + element);
  }
}

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

  Map<String, List<Expense>> expensesByDate() {
    final Map<String, List<Expense>> result = {};
    for (var expense in this) {
      final date =
          expense.createAt.split(' ')[0]; // Extracting only the date part

      result.putIfAbsent(date, () => []);
      result[date]!.add(expense);
    }
    return result;
  }
}
