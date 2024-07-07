import '../models/expense_model.dart';
import '../shared/provider/sort_by_provider.dart';

class ExpenseUtils {
  ExpenseUtils._();

  static void sortBy(List<Expense> expenses, SortBy sortBy) {
    expenses.sort(
      (a, b) {
        if (sortBy == SortBy.lowtohigh) {
          return a.amount.compareTo(b.amount);
        } else if (sortBy == SortBy.hightolow) {
          return b.amount.compareTo(a.amount);
        } else if (sortBy == SortBy.highTolowDate) {
          return b.createAt.compareTo(a.createAt);
        } else if (sortBy == SortBy.lowTohighDate) {
          return a.createAt.compareTo(b.createAt);
        }
        return 0;
      },
    );
  }
}
