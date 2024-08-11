import 'package:expense_tracker_flutter/constants/app_color.dart';
import 'package:expense_tracker_flutter/extension/date_extension.dart';
import 'package:expense_tracker_flutter/extension/iterable_extension.dart';
import 'package:expense_tracker_flutter/extension/num_extension.dart';
import 'package:expense_tracker_flutter/extension/sizebox_extension.dart';
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
        height: MediaQuery.sizeOf(context).height * 0.55,
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
        child: SingleChildScrollView(
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
                      height: 32,
                      width: 32,
                      fit: BoxFit.contain,
                    ),
                  ),
                  8.wGap,
                  Text(
                    "$name",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    "Total Amount: Rs $totalAmount",
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              20.hGap,
              if (name == "Petrol")
                PetrolCategoryDetail(expenseData: expenseData),
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
                          4.hGap,
                          Row(
                            children: [
                              const Icon(
                                Icons.date_range,
                                size: 12,
                              ),
                              4.wGap,
                              Text(
                                DateTime.parse(expense.createAt)
                                    .toFormattedDateString(),
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "- Rs ${expense.amount.toCurrency}",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xffF95B51),
                            ),
                          ),
                          6.wGap,
                          Image.asset(
                            expense.isCash
                                ? "assets/images/dollar.png"
                                : "assets/images/bank.png",
                            height: 12,
                            width: 12,
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
      ),
    );
  }
}

class PetrolCategoryDetail extends StatelessWidget {
  const PetrolCategoryDetail({
    super.key,
    required this.expenseData,
  });

  final List<Expense> expenseData;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          decoration: BoxDecoration(
            color: AppColor.primary.withOpacity(0.2),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              expenseData
                      .map((e) => e.name.toLowerCase())
                      .contains("scooter petrol")
                  ? Row(
                      children: [
                        Text(
                          "${expenseData.where((e) => !e.name.toLowerCase().contains("bike")).map(
                                (e) => DateTime.parse(e.createAt),
                              ).toList().daysDifferenceBetweenFirstAndLast()} D",
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        4.wGap,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Scooter",
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              "Rs: ${expenseData.where((e) => !e.name.toLowerCase().contains("bike")).map(
                                    (e) => e.amount,
                                  ).toList().sum().toCurrency}",
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        )
                      ],
                    )
                  : const SizedBox.shrink(),
              expenseData
                      .map((e) => e.name.toLowerCase())
                      .contains("bike petrol")
                  ? Row(
                      children: [
                        Text(
                          "${expenseData.where((e) => e.name.toLowerCase().contains("bike")).map(
                                (e) => DateTime.parse(e.createAt),
                              ).toList().daysDifferenceBetweenFirstAndLast()} D",
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        4.wGap,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Bike",
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              "Rs: ${expenseData.where((e) => e.name.toLowerCase().contains("bike")).map(
                                    (e) => e.amount,
                                  ).toList().sum().toCurrency}",
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        )
                      ],
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        ),
        const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_month,
              color: AppColor.primary,
            ),
            4.wGap,
            Text(
              "${expenseData.map(
                    (e) => DateTime.parse(e.createAt),
                  ).toList().firstDate()?.toFormattedDateString()}",
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Icon(Icons.arrow_right),
            Text(
              "${expenseData.map(
                    (e) => DateTime.parse(e.createAt),
                  ).toList().lastDate()?.toFormattedDateString()}",
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        20.hGap,
      ],
    );
  }
}
