import 'dart:convert';

import 'package:expense_tracker_flutter/constants/app_strings.dart';
import 'package:expense_tracker_flutter/extension/iterable_extension.dart';
import 'package:expense_tracker_flutter/extension/num_extension.dart';
import 'package:expense_tracker_flutter/extension/sizebox_extension.dart';
import 'package:expense_tracker_flutter/helper/expense_query_helper.dart';
import 'package:expense_tracker_flutter/models/expense_model.dart';
import 'package:flutter/material.dart';
import 'package:nepali_utils/nepali_utils.dart';

class RestaurantAlertBanner extends StatelessWidget {
  const RestaurantAlertBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: ExpenseQueryHelper.getExpense(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();

        final expenses = snapshot.data!.docs.map((e) {
          final expense = Expense.fromJson(jsonEncode(e.data()));
          return expense;
        }).toList();

        // Nepali Date Logic: 7th of current month to 7th of next month
        final now = NepaliDateTime.now();
        NepaliDateTime startDate;
        NepaliDateTime endDate;

        if (now.day >= 7) {
          // Current month 7th to next month 7th
          startDate = NepaliDateTime(now.year, now.month, 7);
          // Auto-handles year wrap if month is 12
          endDate = NepaliDateTime(now.year, now.month + 1, 7);
        } else {
          // Previous month 7th to current month 7th
          startDate = NepaliDateTime(now.year, now.month - 1, 7);
          endDate = NepaliDateTime(now.year, now.month, 7);
        }

        final currentMonthExpenses = expenses.where((element) {
          final expenseDateEnglish = DateTime.parse(element.createAt);
          final expenseDateNepali = expenseDateEnglish.toNepaliDateTime();

          final isRestaurant =
              element.category.toLowerCase() == AppString.categoryRestaurant;

          // Check if date is >= startDate AND < endDate
          // Using compareTo: a.compareTo(b) < 0 means a < b
          final isAfterStart = expenseDateNepali.compareTo(startDate) >= 0;
          final isBeforeEnd = expenseDateNepali.compareTo(endDate) < 0;

          return isRestaurant && isAfterStart && isBeforeEnd;
        }).toList();

        final totalRestaurantSpend = currentMonthExpenses
            .map((e) => e.amount)
            .sum();

        if (totalRestaurantSpend <= 4000) {
          return const SizedBox.shrink();
        }

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
                      "You've spent Rs ${totalRestaurantSpend.toCurrency} between ${NepaliDateFormat("MMMM d").format(startDate)} - ${NepaliDateFormat("MMMM d").format(endDate)}.",
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
      },
    );
  }
}
