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
                          color: Colors.blueAccent.withOpacity(0.1),
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
                          color: Colors.redAccent.withOpacity(0.1),
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

      child: Ink(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.3 : 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: isHome == true
            ? const EdgeInsets.symmetric(horizontal: 16, vertical: 12)
            : const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    expenseData?.category.getColorByCategory.withOpacity(0.5) ??
                        Colors.red,
                    expenseData?.category.getColorByCategory.withOpacity(0.7) ??
                        Colors.red,
                    expenseData?.category.getColorByCategory.withOpacity(
                          0.95,
                        ) ??
                        Colors.red,
                  ],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
              ),
              child: Image.asset(
                expenseData?.category.getIconPathByCategory ?? "",
                fit: BoxFit.contain,
                height: 32,
                width: 32,
              ),
            ),
            12.wGap,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.sizeOf(context).width * 0.4,
                  child: Text(
                    "${expenseData?.name.capitalize()}",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.4,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
                Text(
                  "${expenseData?.category}",
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.grey[400] : const Color(0xff666666),
                    letterSpacing: 1.1,
                  ),
                ),
                1.hGap,
                if (showDate == true) ...{
                  4.hGap,
                  Row(
                    children: [
                      Icon(
                        Icons.date_range,
                        size: 12,
                        color: isDark
                            ? Colors.grey[400]
                            : const Color(0xff666666),
                      ),
                      4.wGap,
                      Text(
                        DateTime.parse(
                          expenseData!.createAt,
                        ).toFormattedDateString(),
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark
                              ? Colors.grey[400]
                              : const Color(0xff666666),
                        ),
                      ),
                    ],
                  ),
                },
              ],
            ),
            const Spacer(),
            Text(
              "-Rs ${expenseData?.amount.toCurrency}",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.1,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            3.wGap,
            Image.asset(
              expenseData?.isCash == true
                  ? "assets/images/dollar.png"
                  : "assets/images/bank.png",
              height: 12,
              width: 12,
            ),
          ],
        ),
      ),
    );
  }
}
