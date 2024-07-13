import 'package:expense_tracker_flutter/extension/iterable_extension.dart';
import 'package:expense_tracker_flutter/extension/sizebox_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../models/expense_model.dart';

class DateWidget extends StatelessWidget {
  const DateWidget({
    super.key,
    required this.day,
    required this.weekDay,
    required this.month,
    required this.expenses,
  });

  final String day;
  final String weekDay;
  final String month;
  final List<Expense>? expenses;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 10,
        ),
        decoration: const BoxDecoration(color: Color(0xffECF3F3)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  day,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                6.wGap,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      weekDay,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xff666666),
                      ),
                    ),
                    Text(
                      month,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xff666666),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text(
                  "Total Spend",
                  style: TextStyle(
                    fontSize: 10,
                    color: Color(0xff666666),
                  ),
                ),
                Text(
                  "Rs. ${expenses?.map(
                        (e) => e.amount,
                      ).sum()}",
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xff666666),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            )
          ],
        ));
  }
}
