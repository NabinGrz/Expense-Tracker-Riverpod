// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:expense_tracker_flutter/features/home/entity/home_entity.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum DateFilter { today, weekly, twoweeks, monthly }

final dateFilterProvider =
    StateNotifierProvider<DateFilterNotifier, HomeEntity>(
        (ref) => DateFilterNotifier());

class DateFilterNotifier extends StateNotifier<HomeEntity> {
  DateFilterNotifier() : super(HomeEntity.initial());

  void selectDate(DateFilter dateFilter) =>
      state = state.copyWith(dateFilter: dateFilter);

  void updateTotalAmount(int amount) =>
      state = state.copyWith(totalAmount: amount);
}
