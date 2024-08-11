// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rxdart/rxdart.dart';

import '../../../models/expense_model.dart';

final isAppBarCollapsed = StateProvider.autoDispose(
  (ref) => false,
);

final selectedDateProvider = StateProvider.autoDispose(
  (ref) => DateTime.now(),
);

final filteredExpensesSubject = BehaviorSubject<List<Expense>?>();

final dateRangeProvider =
    StateNotifierProvider.autoDispose<DateRangeNotifier, DateRangeModel>(
  (ref) => DateRangeNotifier(),
);

class DateRangeNotifier extends StateNotifier<DateRangeModel> {
  DateRangeNotifier() : super(DateRangeModel.initial());

  void updateFromDate(DateTime date) {
    state = state.copyWith(from: date);
  }

  void updateToDate(DateTime date) {
    state = state.copyWith(to: date);
  }
}

class DateRangeModel {
  final DateTime from;
  final DateTime to;

  DateRangeModel({required this.from, required this.to});

  DateRangeModel copyWith({
    DateTime? from,
    DateTime? to,
  }) {
    return DateRangeModel(
      from: from ?? this.from,
      to: to ?? this.to,
    );
  }

  static DateRangeModel initial({
    DateTime? from,
    DateTime? to,
  }) {
    return DateRangeModel(
      from: DateTime.now().subtract(const Duration(days: 6)),
      to: DateTime.now(),
    );
  }
}
