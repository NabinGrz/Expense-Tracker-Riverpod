import 'package:expense_tracker_flutter/extension/num_extension.dart';
import 'package:expense_tracker_flutter/extension/sizebox_extension.dart';
import 'package:expense_tracker_flutter/features/expense/entity/home_entity.dart';
import 'package:expense_tracker_flutter/features/expense/provider/home_provider.dart';
import 'package:expense_tracker_flutter/features/expense/widgets/home_expenses_list.dart';
import 'package:expense_tracker_flutter/features/expense/widgets/search_text_field.dart';
import 'package:expense_tracker_flutter/models/expense_model.dart';
import 'package:expense_tracker_flutter/shared/provider/tab_bar_provider.dart';
import 'package:expense_tracker_flutter/shared/widget/expense_analytics_tab_bar.dart';
import 'package:expense_tracker_flutter/shared/widget/sort_by_widget.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomeExpensesListContent extends ConsumerWidget {
  final HomeEntity homeEntity;
  final HomeNotifier controller;
  final TextEditingController searchController;
  final List<Expense> originalExpenseList;

  const HomeExpensesListContent({
    super.key,
    required this.homeEntity,
    required this.controller,
    required this.searchController,
    required this.originalExpenseList,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Expenses List",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          2.hGap,
          Text(
            "Total Spend: Rs ${homeEntity.totalAmount.toCurrency}",
            style: const TextStyle(fontSize: 14, color: Color(0xff666666)),
          ),
          16.hGap,
          SearchTextField(
            searchController: searchController,
            homeEntity: homeEntity,
            controller: controller,
            originalExpenseList: originalExpenseList,
          ),
          20.hGap,
          const ExpenseAnalyticTabBar(),
          20.hGap,
          if (ref.watch(hometabProvider) == SelectedTab.expense) ...{
            const SortByWidget(),
            20.hGap,
          },
          const HomeExpenseList(),
          50.hGap,
        ],
      ),
    );
  }
}
