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
    return Wrap(
      alignment: WrapAlignment.start,
      runAlignment: WrapAlignment.center,
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
                  name: category.key,
                  iconPath: category.key.getIconPathByCategory,
                  totalAmount: category.value['totalAmount'].toString(),
                ),
              );
            },
            child: Container(
              width: MediaQuery.sizeOf(context).width * 0.4,
              // width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              margin: const EdgeInsets.only(right: 10, bottom: 10),
              decoration: BoxDecoration(
                // color: Colors.white,
                // color: category?.key.getColorByCategory,
                gradient: LinearGradient(
                  colors: [
                    category!.key.getColorByCategory.withOpacity(0.4),
                    category.key.getColorByCategory.withOpacity(0.6),
                    category.key.getColorByCategory.withOpacity(0.8)
                  ],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
                borderRadius: BorderRadius.circular(8),
                // boxShadow: [
                //   BoxShadow(
                //       blurRadius: 20,
                //       spreadRadius: -9,
                //       color: AppColor.primary.withOpacity(0.5),
                //       offset: const Offset(8, 12))
                // ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: Hero(
                      tag: category.key,
                      child: Image.asset(
                        category.key.getIconPathByCategory,
                        height: 55,
                        width: 55,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  6.hGap,
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Rs: ${category.value['totalAmount']}",
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      category.key,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
