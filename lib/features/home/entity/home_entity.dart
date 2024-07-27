import '../../../models/expense_model.dart';
import '../provider/home_provider.dart';

class HomeEntity {
  final DateFilter dateFilter;
  final int totalAmount;
  final List<Expense>? expenses;
  HomeEntity(
      {required this.expenses,
      required this.dateFilter,
      required this.totalAmount});

  HomeEntity copyWith({
    DateFilter? dateFilter,
    int? totalAmount,
    List<Expense>? expenses,
  }) {
    return HomeEntity(
      dateFilter: dateFilter ?? this.dateFilter,
      totalAmount: totalAmount ?? this.totalAmount,
      expenses: expenses ?? this.expenses,
    );
  }

  static HomeEntity initial() {
    return HomeEntity(
      dateFilter: DateFilter.today,
      totalAmount: 0,
      expenses: [],
    );
  }
}
