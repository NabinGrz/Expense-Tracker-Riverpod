import 'package:expense_tracker_flutter/extension/date_extension.dart';
import 'package:expense_tracker_flutter/extension/sizebox_extension.dart';
import 'package:expense_tracker_flutter/shared/widget/expense_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../models/expense_model.dart';

class CategoryExpenses extends StatelessWidget {
  final String? name;
  final String? totalAmount;
  final String? iconPath;
  final List<Expense> expenseData;
  const CategoryExpenses({
    super.key,
    required this.expenseData,
    this.name,
    this.iconPath,
    this.totalAmount,
  });

  @override
  Widget build(BuildContext context) {
    expenseData.sort(
      (a, b) => b.amount.compareTo(a.amount),
    );
    return Material(
      // color: Colors.white,
      color: Colors.transparent,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            )),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            10.hGap,
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Hero(
                  tag: "$name",
                  child: Image.asset(
                    "$iconPath",
                    height: 35,
                    width: 35,
                    fit: BoxFit.contain,
                  ),
                ),
                8.wGap,
                Text(
                  "Category: $name",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  "TotalAmount: Rs $totalAmount",
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            20.hGap,
            ListView.separated(
              physics: const ClampingScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: expenseData.length,
              shrinkWrap: true,
              separatorBuilder: (context, index) => 10.hGap,
              itemBuilder: (context, index) {
                final expense = expenseData[index];

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(expense.name),
                        Text(
                          DateTime.parse(expense.createAt)
                              .toFormattedDateString(),
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "- Rs ${expense.amount}",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xffF95B51),
                          ),
                        ),
                        6.wGap,
                        expense.isCash
                            ? Image.asset(
                                "assets/images/dollar.png",
                                height: 14,
                                width: 14,
                              )
                            : Image.asset(
                                "assets/images/bank.png",
                                height: 14,
                                width: 14,
                              ),
                      ],
                    )
                  ],
                );
              },
            ),
            20.hGap,
          ],
        ),
      ),
    );
  }
}
