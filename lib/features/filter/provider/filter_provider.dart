import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rxdart/rxdart.dart';

import '../../../models/expense_model.dart';

final selectedDateProvider = StateProvider(
  (ref) => DateTime.now(),
);

final filteredExpensesSubject = BehaviorSubject<List<Expense>?>();
