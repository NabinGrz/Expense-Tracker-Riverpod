// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:expense_tracker_flutter/extension/date_extension.dart';
import 'package:expense_tracker_flutter/extension/iterable_extension.dart';
import 'package:expense_tracker_flutter/features/home/entity/home_entity.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rxdart/rxdart.dart';

import '../../../models/expense_model.dart';

enum DateFilter { today, yesterday, twoweeks, monthly }

final homeEntityProvider =
    StateNotifierProvider<HomeNotifier, HomeEntity>((ref) => HomeNotifier());

class HomeNotifier extends StateNotifier<HomeEntity> {
  HomeNotifier() : super(HomeEntity.initial());

  final sortedExpenseSubject = BehaviorSubject<List<Expense>>();

  void selectDate(DateFilter dateFilter) =>
      state = state.copyWith(dateFilter: dateFilter);

  // void updateTotalAmount(int amount) =>
  //     state = state.copyWith(totalAmount: amount);

  void updateTotalAmount(List<Expense>? expenses) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        final amountList = expenses?.map((e) => e.amount);
        state = state.copyWith(totalAmount: amountList?.sum() ?? 0);
      },
    );
  }

  void populateExpenses(
    List<Expense>? data,
  ) {
    switch (state.dateFilter) {
      case DateFilter.today:
        final expenses = data?.where(
          (element) {
            final expenseDate = DateTime.parse(element.createAt);
            return expenseDate.isSameDateAs(DateTime.now());
          },
        ).toList();
        state = state.copyWith(expenses: expenses);
        updateTotalAmount(expenses);
        break;
      case DateFilter.yesterday:
        final yesterdayDate = DateTime.now().subtract(const Duration(days: 1));
        final expenses = data?.where(
          (element) {
            final expenseDate = DateTime.parse(element.createAt);
            return expenseDate.isSameDateAs(yesterdayDate);
          },
        ).toList();
        state = state.copyWith(expenses: expenses);
        updateTotalAmount(expenses);
        break;
      case DateFilter.twoweeks:
        final twoWeeks = DateTime.now().subtract(const Duration(days: 13));
        final expenses = data?.where(
          (element) {
            final expenseDate = DateTime.parse(element.createAt);
            return expenseDate.isSameDateAs(twoWeeks) ||
                expenseDate.isAfter(twoWeeks);
          },
        ).toList();
        state = state.copyWith(expenses: expenses);
        updateTotalAmount(expenses);
        break;
      case DateFilter.monthly:
        final monthly = DateTime.now().subtract(const Duration(days: 29));
        final expenses = data?.where(
          (element) {
            final expenseDate = DateTime.parse(element.createAt);
            return expenseDate.isSameDateAs(monthly) ||
                expenseDate.isAfter(monthly);
          },
        ).toList();
        state = state.copyWith(expenses: expenses);
        updateTotalAmount(expenses);
        break;
      default:
    }
  }
}
