import 'package:expense_tracker_flutter/extension/sizebox_extension.dart';
import 'package:expense_tracker_flutter/extension/string_extension.dart';
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
      // Create a grid with 2 columns. If you change the scrollDirection to
      // horizontal, this produces 2 rows.
      crossAxisCount: 2,
      childAspectRatio: 1.7,
      crossAxisSpacing: 6,
      mainAxisSpacing: 6,
      // padding: const EdgeInsets.all(10.0),
      padding: EdgeInsets.zero,

      // alignment: WrapAlignment.start,
      // runAlignment: WrapAlignment.center,
      children: List.generate(
        sortedCategories?.length ?? 0,
        (index) {
          final category = sortedCategories?[index];
          final expenses = category?.value['expenses'] as List<Expense>;
          return GestureDetector(
            onTap: () {
              showCupertinoModalPopup(
                context: context,
                // builder: (context) => CategoryExpenses(
                //   expenseData: expenses,
                //   name: category.key,
                //   iconPath: category.key.getIconPathByCategory,
                //   totalAmount: category.value['totalAmount'].toString(),
                // ),
                builder: (context) {
                  return CupertinoPopupSurface(
                    child: CategoryExpenses(
                      expenseData: expenses,
                      name: category.key,
                      iconPath: category.key.getIconPathByCategory,
                      totalAmount: category.value['totalAmount'].toString(),
                    ),
                  );
                },
              );
            },
            child: Container(
              // width: MediaQuery.sizeOf(context).width * 0.4,
              // width: MediaQuery.sizeOf(context).width * 0.41,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              // margin: const EdgeInsets.only(right: 10, bottom: 10),
              decoration: BoxDecoration(
                // color: Colors.white,
                // color: category?.key.getColorByCategory,
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
                        height: 50,
                        width: 50,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  // 6.hGap,
                  Row(
                    children: [
                      Text(
                        "Rs: ${category.value['totalAmount'].currency}-",
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
