import 'dart:convert';

import 'package:expense_tracker_flutter/constants/app_strings.dart';
import 'package:expense_tracker_flutter/extension/iterable_extension.dart';
import 'package:expense_tracker_flutter/extension/num_extension.dart';
import 'package:expense_tracker_flutter/extension/sizebox_extension.dart';
import 'package:expense_tracker_flutter/helper/expense_query_helper.dart';
import 'package:expense_tracker_flutter/models/expense_model.dart';
import 'package:flutter/material.dart';

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

        // Filter for current month and restaurant category
        final currentMonthExpenses = expenses.where((element) {
          final expenseDate = DateTime.parse(element.createAt);
          final currentMonth = DateTime.now().month;
          final currentYear = DateTime.now().year;
          // Check if expense is in current month/year
          final isCurrentMonth =
              expenseDate.month == currentMonth &&
              expenseDate.year == currentYear;
          // Check category strictly
          final isRestaurant =
              element.category.toLowerCase() == AppString.categoryRestaurant;
          return isCurrentMonth && isRestaurant;
        }).toList();

        final totalRestaurantSpend = currentMonthExpenses
            .map((e) => e.amount)
            .sum();

        if (totalRestaurantSpend <= 10000) {
          return const SizedBox.shrink();
        }

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
                      "You've spent Rs ${totalRestaurantSpend.toCurrency} on food. Time to cook at home!",
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
