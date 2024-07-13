import 'package:expense_tracker_flutter/extension/sizebox_extension.dart';
import 'package:expense_tracker_flutter/extension/string_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../constants/app_color.dart';
import '../../../models/expense_model.dart';
import 'category_expense.dart';

class AnalyticsWidget extends StatelessWidget {
  final List<MapEntry<String, Map<String, dynamic>>>? sortedCategories;
  const AnalyticsWidget({super.key, this.sortedCategories});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.4,
      child: Wrap(
        children: List.generate(
          sortedCategories?.length ?? 0,
          (index) {
            final category = sortedCategories?[index];
            final expenses = category?.value['expenses'] as List<Expense>;
            return GestureDetector(
              onTap: () {
                showCupertinoModalPopup(
                  context: context,
                  builder: (context) => CategoryExpenses(
                    expenseData: expenses,
                    name: category?.key,
                    iconPath: category?.key.getIconPathByCategory,
                    totalAmount: category?.value['totalAmount'].toString(),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(6),
                margin: const EdgeInsets.only(right: 10, bottom: 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 20,
                          spreadRadius: -9,
                          color: AppColor.primary.withOpacity(0.6),
                          offset: const Offset(1, 9))
                    ]),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Hero(
                      tag: "${category?.key}",
                      child: Image.asset(
                        "${category?.key.getIconPathByCategory}",
                        height: 45,
                        width: 45,
                        fit: BoxFit.contain,
                      ),
                    ),
                    6.hGap,
                    Text(
                      "Rs: ${category?.value['totalAmount']}",
                      style: const TextStyle(
                        fontSize: 10,
                      ),
                    ),
                    Text(
                      "${category?.key}",
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
