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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Expenses List",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xff1E293B),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xff1E293B)
                      : const Color(0xffF1F5F9),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark
                        ? const Color(0xff334155)
                        : const Color(0xffE2E8F0),
                  ),
                ),
                child: Text(
                  "Spend: Rs ${homeEntity.totalAmount.toCurrency}",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDark ? const Color(0xff94A3B8) : const Color(0xff64748B),
                  ),
                ),
              ),
            ],
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
