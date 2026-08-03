import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker_flutter/extension/iterable_extension.dart';
import 'package:expense_tracker_flutter/extension/num_extension.dart';
import 'package:expense_tracker_flutter/extension/sizebox_extension.dart';
import 'package:expense_tracker_flutter/extension/string_extension.dart';
import 'package:expense_tracker_flutter/features/settings/controller/settings_controller.dart';
import 'package:expense_tracker_flutter/helper/expense_query_helper.dart';
import 'package:expense_tracker_flutter/models/expense_model.dart';
import 'package:expense_tracker_flutter/utils/expense_utils.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nepali_utils/nepali_utils.dart';

class CategoryOverBudgetInfo {
  final String category;
  final int totalSpend;
  final int limit;
  final NepaliDateTime startDate;
  final NepaliDateTime endDate;

  CategoryOverBudgetInfo({
    required this.category,
    required this.totalSpend,
    required this.limit,
    required this.startDate,
    required this.endDate,
  });
}

class CategoryBudgetBanner extends ConsumerWidget {
  const CategoryBudgetBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: ExpenseQueryHelper.getExpense(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();

        final settingsState = ref.watch(settingsControllerProvider).value;
        if (settingsState == null) return const SizedBox.shrink();

        final billingStartDay = settingsState.billingStartDay;
        final categoryLimits = settingsState.categoryLimits;
        if (categoryLimits.isEmpty) return const SizedBox.shrink();

        final expenses = _parseExpenses(snapshot.data!);
        final cycle = ExpenseUtils.getNepaliBillingCycle(
          startDay: billingStartDay,
        );

        final overBudgetList = <CategoryOverBudgetInfo>[];

        categoryLimits.forEach((category, limit) {
          if (limit > 0) {
            final spend = _calculateCategorySpend(expenses, cycle, category);
            if (spend > limit) {
              overBudgetList.add(
                CategoryOverBudgetInfo(
                  category: category,
                  totalSpend: spend,
                  limit: limit,
                  startDate: cycle.start,
                  endDate: cycle.displayEnd,
                ),
              );
            }
          }
        });

        if (overBudgetList.isEmpty) return const SizedBox.shrink();

        return Column(
          children: overBudgetList.map((info) {
            return _BannerUI(info: info);
          }).toList(),
        );
      },
    );
  }

  List<Expense> _parseExpenses(QuerySnapshot<Map<String, dynamic>> data) {
    return data.docs.map((e) {
      return Expense.fromJson(jsonEncode(e.data()));
    }).toList();
  }

  int _calculateCategorySpend(
    List<Expense> expenses,
    DateRange cycle,
    String category,
  ) {
    return expenses
        .where((element) {
          final expenseDateEnglish = DateTime.parse(element.createAt);
          final expenseDateNepali = expenseDateEnglish.toNepaliDateTime();

          final isTargetCategory =
              element.category.trim().toLowerCase() ==
              category.trim().toLowerCase();

          final isWithinCycle =
              expenseDateNepali.compareTo(cycle.start) >= 0 &&
              expenseDateNepali.compareTo(cycle.end) < 0;

          return isTargetCategory && isWithinCycle;
        })
        .map((e) => e.amount)
        .sum();
  }
}

class _BannerUI extends StatelessWidget {
  final CategoryOverBudgetInfo info;

  const _BannerUI({required this.info});

  @override
  Widget build(BuildContext context) {
    final formattedStart = NepaliDateFormat("MMMM d").format(info.startDate);
    final formattedEnd = NepaliDateFormat("MMMM d").format(info.endDate);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = isDark ? const Color(0xff2C0B0E) : const Color(0xffFFEBEE);
    final textColor = isDark ? const Color(0xffEF9A9A) : const Color(0xffD32F2F);
    final iconColor = isDark ? const Color(0xffEF5350) : const Color(0xffD32F2F);

    return Container(
      margin: const EdgeInsets.only(left: 14, right: 14, top: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xffD32F2F).withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: iconColor),
          12.wGap,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${info.category.capitalize()} Budget of Rs ${info.limit.toCurrency} Exceeded!",
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                4.hGap,
                Text(
                  "You've spent Rs ${info.totalSpend.toCurrency} between $formattedStart - $formattedEnd.",
                  style: TextStyle(color: textColor, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
