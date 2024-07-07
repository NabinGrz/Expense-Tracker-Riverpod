import '../provider/home_provider.dart';

class HomeEntity {
  final DateFilter dateFilter;
  final int totalAmount;

  HomeEntity({required this.dateFilter, required this.totalAmount});

  HomeEntity copyWith({
    DateFilter? dateFilter,
    int? totalAmount,
  }) {
    return HomeEntity(
      dateFilter: dateFilter ?? this.dateFilter,
      totalAmount: totalAmount ?? this.totalAmount,
    );
  }

  static HomeEntity initial() {
    return HomeEntity(
      dateFilter: DateFilter.today,
      totalAmount: 0,
    );
  }
}
