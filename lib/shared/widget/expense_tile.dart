import 'package:expense_tracker_flutter/constants/app_color.dart';
import 'package:expense_tracker_flutter/extension/sizebox_extension.dart';
import 'package:expense_tracker_flutter/extension/string_extension.dart';
import 'package:expense_tracker_flutter/helper/expense_query_helper.dart';
import 'package:flutter/material.dart';

import '../../features/home/widgets/create_expense_dialog.dart';
import '../../models/expense_model.dart';

class ExpenseTile extends StatelessWidget {
  const ExpenseTile({
    super.key,
    required this.expenseData,
  });

  final Expense? expenseData;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      splashColor: AppColor.primary.withOpacity(0.3),
      highlightColor: AppColor.primary.withOpacity(0.4),
      splashFactory: InkSparkle.constantTurbulenceSeedSplashFactory,
      onTap: () {},
      onLongPress: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: Colors.white,
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      showDialog(
                        context: context,
                        builder: (context) {
                          return CreateUpdateDialog(
                            isUpdate: true,
                            expenseData: expenseData,
                            docId: expenseData?.docId,
                          );
                        },
                      );
                    },
                    child: Row(
                      children: [
                        const Icon(Icons.update_outlined),
                        4.wGap,
                        const Text(
                          "Update",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  25.hGap,
                  InkWell(
                    onTap: () {
                      ExpenseQueryHelper.deleteExpense(expenseData!.docId!);
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: [
                        const Icon(Icons.delete_outline_rounded),
                        4.wGap,
                        const Text(
                          "Delete",
                          style: TextStyle(
                            fontSize: 16,
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
      },
      child: Row(
        children: [
          Container(
            height: 50,
            width: 50,
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: const Color(0xffF0F6F5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Image.asset(
              expenseData?.category.getIconPathByCategory ?? "",
              fit: BoxFit.contain,
            ),
          ),
          10.wGap,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${expenseData?.name}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              6.hGap,
              Text(
                "${expenseData?.category}",
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xff666666),
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            "- Rs ${expenseData?.amount}",
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xffF95B51),
            ),
          ),
        ],
      ),
    );
  }
}
