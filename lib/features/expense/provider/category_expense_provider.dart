import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../models/expense_model.dart';

final categoryExpenseProvider =
    ChangeNotifierProvider.autoDispose((ref) => CategoryExpenseNotifier());

class CategoryExpenseNotifier extends ChangeNotifier {
  List<Expense> sortedExpenseData = [];
  List<Expense> originalExpenseData = [];
  bool isSortByDate = false;

  updateOriginalExpense(List<Expense> val) {
    originalExpenseData = val;
    notifyListeners();
  }

  updateSortedExpense(List<Expense> val) {
    sortedExpenseData = val;
    notifyListeners();
  }

  updateSortByDate(bool val) {
    isSortByDate = val;
    notifyListeners();
  }
}
