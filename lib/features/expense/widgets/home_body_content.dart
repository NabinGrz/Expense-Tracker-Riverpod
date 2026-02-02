import 'package:expense_tracker_flutter/features/expense/entity/home_entity.dart';
import 'package:expense_tracker_flutter/features/expense/provider/home_provider.dart';
import 'package:expense_tracker_flutter/features/expense/widgets/home_empty_state.dart';
import 'package:expense_tracker_flutter/features/expense/widgets/home_expenses_list_content.dart';
import 'package:expense_tracker_flutter/models/expense_model.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomeBodyContent extends ConsumerWidget {
  final HomeNotifier controller;
  final HomeEntity homeEntity;
  final TextEditingController searchController;
  final List<Expense> originalExpenseList;

  const HomeBodyContent({
    super.key,
    required this.controller,
    required this.homeEntity,
    required this.searchController,
    required this.originalExpenseList,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder(
      stream: controller.sortedExpenseSubject,
      builder: (context, snapshot) {
        final dateFilter = ref.watch(
          homeEntityProvider.select((value) => value.dateFilter),
        );
        List<Expense>? expenses = [];
        expenses = controller.dateWiseExpenses(expenses, snapshot, dateFilter);
        return (expenses?.isEmpty != true)
            ? HomeExpensesListContent(
                homeEntity: homeEntity,
                controller: controller,
                searchController: searchController,
                originalExpenseList: originalExpenseList,
              )
            : const HomeEmptyState();
      },
    );
  }
}
