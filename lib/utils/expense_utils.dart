import 'package:nepali_utils/nepali_utils.dart';

import '../models/expense_model.dart';
import '../shared/provider/sort_by_provider.dart';

class ExpenseUtils {
  ExpenseUtils._();

  static void sortBy(List<Expense> expenses, SortBy sortBy) {
    expenses.sort((a, b) {
      if (sortBy == SortBy.lowtohigh) {
        return a.amount.compareTo(b.amount);
      } else if (sortBy == SortBy.hightolow) {
        return b.amount.compareTo(a.amount);
      } else if (sortBy == SortBy.highTolowDate) {
        return b.createAt.compareTo(a.createAt);
      } else if (sortBy == SortBy.lowTohighDate) {
        return a.createAt.compareTo(b.createAt);
      } else if (sortBy == SortBy.ascending) {
        return a.name.compareTo(b.name);
      } else if (sortBy == SortBy.descending) {
        return b.name.compareTo(a.name);
      }
      return 0;
    });
  }

  static DateRange getNepaliBillingCycle() {
    final now = NepaliDateTime.now();
    // Cycle starts on the 7th of the relevant month
    if (now.day >= 7) {
      return DateRange(
        start: NepaliDateTime(now.year, now.month, 7),
        end: NepaliDateTime(now.year, now.month + 1, 7),
      );
    } else {
      return DateRange(
        start: NepaliDateTime(now.year, now.month - 1, 7),
        end: NepaliDateTime(now.year, now.month, 7),
      );
    }
  }
}

class DateRange {
  final NepaliDateTime start;
  final NepaliDateTime end;
  DateRange({required this.start, required this.end});
}
