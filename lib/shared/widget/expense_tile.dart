import 'package:expense_tracker_flutter/constants/app_color.dart';
import 'package:expense_tracker_flutter/extension/date_extension.dart';
import 'package:expense_tracker_flutter/extension/num_extension.dart';
import 'package:expense_tracker_flutter/extension/sizebox_extension.dart';
import 'package:expense_tracker_flutter/extension/string_extension.dart';
import 'package:expense_tracker_flutter/helper/expense_query_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../features/expense/widgets/create_expense_dialog.dart';
import '../../models/expense_model.dart';

class ExpenseTile extends ConsumerWidget {
  const ExpenseTile({
    super.key,
    required this.expenseData,
    this.isFilter = false,
    this.isHome = false,
    this.showDate = true,
  });

  final Expense? expenseData;
  final bool? isFilter;
  final bool? isHome;
  final bool? showDate;

  @override
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return InkWell(
      key: ValueKey(expenseData?.id),
      borderRadius: BorderRadius.circular(8),
      splashColor: AppColor.primary.withValues(alpha: .3),
      splashFactory: InkSparkle.constantTurbulenceSeedSplashFactory,
      highlightColor: Colors.transparent,
      onTap: () {}, // Required to show ripple
      onLongPress: () {
        HapticFeedback.lightImpact();
        showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              backgroundColor: theme.cardColor,
              surfaceTintColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Manage Expense",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    16.hGap,
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        showDialog(
                          context: context,
                          builder: (context) {
                            return CreateUpdateDialog(
                              isUpdate: true,
                              expenseData: expenseData,
                              isCashPreviously: expenseData?.isCash,
                              docId: expenseData?.docId ?? "from expense tile",
                            );
                          },
                        );
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blueAccent.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.edit_rounded,
                              color: Colors.blueAccent,
                              size: 20,
                            ),
                            12.wGap,
                            Text(
                              "Update Expense",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: isDark
                                    ? Colors.blue[200]
                                    : Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    12.hGap,
                    InkWell(
                      onTap: () {
                        ExpenseQueryHelper.deleteExpense(expenseData!.docId!);
                        Navigator.pop(context);
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.redAccent.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.delete_rounded,
                              color: Colors.redAccent,
                              size: 20,
                            ),
                            12.wGap,
                            const Text(
                              "Delete Expense",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.redAccent,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },

      child: Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? const Color(0xff334155) : const Color(0xffF1F5F9),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            // Category Icon Avatar
            Container(
              width: 44,
              height: 44,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: (expenseData?.category.getColorByCategory ?? Colors.teal)
                    .withValues(alpha: isDark ? 0.25 : 0.12),
              ),
              child: Image.asset(
                expenseData?.category.getIconPathByCategory ?? "",
                fit: BoxFit.contain,
                height: 24,
                width: 24,
              ),
            ),
            14.wGap,
            // Title, Category & Date
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${expenseData?.name.capitalize()}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xff1E293B),
                    ),
                  ),
                  2.hGap,
                  Text(
                    "${expenseData?.category.capitalize()}",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: isDark ? const Color(0xff94A3B8) : const Color(0xff64748B),
                    ),
                  ),
                  if (showDate == true) ...[
                    4.hGap,
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_rounded,
                          size: 12,
                          color: isDark ? const Color(0xff64748B) : const Color(0xff94A3B8),
                        ),
                        4.wGap,
                        Text(
                          DateTime.parse(
                            expenseData!.createAt,
                          ).toFormattedDateString(),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: isDark
                                ? const Color(0xff64748B)
                                : const Color(0xff94A3B8),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            8.wGap,
            // Amount & Payment Type
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "-Rs ${expenseData?.amount.toCurrency}",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: isDark ? const Color(0xffF87171) : const Color(0xffE11D48),
                  ),
                ),
                4.hGap,
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      expenseData?.isCash == true
                          ? Icons.payments_outlined
                          : Icons.account_balance_rounded,
                      size: 12,
                      color: isDark
                          ? const Color(0xff94A3B8)
                          : const Color(0xff64748B),
                    ),
                    4.wGap,
                    Text(
                      expenseData?.isCash == true ? "Cash" : "Bank",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: isDark
                            ? const Color(0xff94A3B8)
                            : const Color(0xff64748B),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
