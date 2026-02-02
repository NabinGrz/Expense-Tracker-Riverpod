import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker_flutter/constants/app_strings.dart';
import 'package:expense_tracker_flutter/extension/iterable_extension.dart';
import 'package:expense_tracker_flutter/extension/num_extension.dart';
import 'package:expense_tracker_flutter/extension/sizebox_extension.dart';
import 'package:expense_tracker_flutter/features/settings/controller/settings_controller.dart';
import 'package:expense_tracker_flutter/helper/expense_query_helper.dart';
import 'package:expense_tracker_flutter/models/expense_model.dart';
import 'package:expense_tracker_flutter/utils/expense_utils.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nepali_utils/nepali_utils.dart';

class RestaurantAlertBanner extends ConsumerWidget {
  const RestaurantAlertBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: ExpenseQueryHelper.getExpense(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();

        final billingStartDay =
            ref.watch(settingsControllerProvider).value ?? 7;
        final expenses = _parseExpenses(snapshot.data!);
        final cycle = ExpenseUtils.getNepaliBillingCycle(
          startDay: billingStartDay,
        );
        final totalSpend = _calculateTotalSpend(expenses, cycle);

        // Threshold set to 4000 as per user preference
        if (totalSpend <= 4000) return const SizedBox.shrink();

        return _BannerUI(
          totalSpend: totalSpend,
          startDate: cycle.start,
          endDate: cycle.displayEnd,
        );
      },
    );
  }

  List<Expense> _parseExpenses(QuerySnapshot<Map<String, dynamic>> data) {
    return data.docs.map((e) {
      return Expense.fromJson(jsonEncode(e.data()));
    }).toList();
  }

  int _calculateTotalSpend(List<Expense> expenses, DateRange cycle) {
    return expenses
        .where((element) {
          final expenseDateEnglish = DateTime.parse(element.createAt);
          final expenseDateNepali = expenseDateEnglish.toNepaliDateTime();

          final isRestaurant =
              element.category.toLowerCase() == AppString.categoryRestaurant;

          // Expense must be >= start AND < end
          final isWithinCycle =
              expenseDateNepali.compareTo(cycle.start) >= 0 &&
              expenseDateNepali.compareTo(cycle.end) < 0;

          return isRestaurant && isWithinCycle;
        })
        .map((e) => e.amount)
        .sum();
  }
}

class _BannerUI extends StatelessWidget {
  final int totalSpend;
  final NepaliDateTime startDate;
  final NepaliDateTime endDate;

  const _BannerUI({
    required this.totalSpend,
    required this.startDate,
    required this.endDate,
  });

  @override
  Widget build(BuildContext context) {
    final formattedStart = NepaliDateFormat("MMMM d").format(startDate);
    final formattedEnd = NepaliDateFormat("MMMM d").format(endDate);

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 16, 12, 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xffFFEBEE), // Light Red background
        border: Border.all(color: const Color(0xffEF5350)), // Red border
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: Color(0xffD32F2F)),
          12.wGap,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Restaurant Budget Exceeded!",
                  style: TextStyle(
                    color: Color(0xffD32F2F),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                4.hGap,
                Text(
                  "You've spent Rs ${totalSpend.toCurrency} between $formattedStart - $formattedEnd.",
                  style: const TextStyle(
                    color: Color(0xffD32F2F),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
