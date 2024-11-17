import 'package:expense_tracker_flutter/extension/num_extension.dart';
import 'package:expense_tracker_flutter/extension/sizebox_extension.dart';
import 'package:expense_tracker_flutter/extension/string_extension.dart';
import 'package:expense_tracker_flutter/shared/widget/expense_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../models/expense_model.dart';
import 'category_expense.dart';

class AnalyticsWidget extends StatelessWidget {
  final List<MapEntry<String, Map<String, dynamic>>>? sortedCategories;
  const AnalyticsWidget({super.key, this.sortedCategories});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 2,
      childAspectRatio: 1.7,
      crossAxisSpacing: 6,
      mainAxisSpacing: 6,
      padding: EdgeInsets.zero,
      children: List.generate(
        sortedCategories?.length ?? 0,
        (index) {
          final category = sortedCategories?[index];
          final expenses = category?.value['expenses'] as List<Expense>;
          return GestureDetector(
            onTap: () {
              showCupertinoModalPopup(
                context: context,
                builder: (context) {
                  return CategoryExpenses(
                    expenseData: expenses,
                    name: category.key,
                    iconPath: category.key.getIconPathByCategory,
                    totalAmount: category.value['totalAmount'].toString(),
                  );
                },
              );
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    category!.key.getColorByCategory.withOpacity(0.5),
                    category.key.getColorByCategory.withOpacity(0.7),
                    category.key.getColorByCategory.withOpacity(0.9)
                  ],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: Image.asset(
                      category.key.getIconPathByCategory,
                      height: 55,
                      width: 55,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        "Rs: ${int.tryParse("${category.value['totalAmount']}").toCurrency}-",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          overflow: TextOverflow.ellipsis,
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
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
