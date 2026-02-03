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

        final settingsState = ref.watch(settingsControllerProvider).value;
        final billingStartDay = settingsState?.billingStartDay ?? 7;
        final restaurantLimit = settingsState?.restaurantLimit ?? 4000;

        final expenses = _parseExpenses(snapshot.data!);
        final cycle = ExpenseUtils.getNepaliBillingCycle(
          startDay: billingStartDay,
        );
        final totalSpend = _calculateTotalSpend(expenses, cycle);

        // Threshold based on user preference
        if (totalSpend <= restaurantLimit) return const SizedBox.shrink();

        return _BannerUI(
          totalSpend: totalSpend,
          limit: restaurantLimit,
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
  final int limit;
  final NepaliDateTime startDate;
  final NepaliDateTime endDate;

  const _BannerUI({
    required this.totalSpend,
    required this.limit,
    required this.startDate,
    required this.endDate,
  });

  @override
  @override
  Widget build(BuildContext context) {
    final formattedStart = NepaliDateFormat("MMMM d").format(startDate);
    final formattedEnd = NepaliDateFormat("MMMM d").format(endDate);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = isDark ? const Color(0xff2C0B0E) : const Color(0xffFFEBEE);
    final textColor = isDark
        ? const Color(0xffEF9A9A)
        : const Color(0xffD32F2F);
    final iconColor = isDark
        ? const Color(0xffEF5350)
        : const Color(0xffD32F2F);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xffD32F2F).withOpacity(0.15),
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
                  "Restaurant Budget of Rs ${limit.toCurrency} Exceeded!",
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                4.hGap,
                Text(
                  "You've spent Rs ${totalSpend.toCurrency} between $formattedStart - $formattedEnd.",
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
