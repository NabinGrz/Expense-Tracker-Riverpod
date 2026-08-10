import 'package:expense_tracker_flutter/constants/app_color.dart';
import 'package:expense_tracker_flutter/extension/date_extension.dart';
import 'package:expense_tracker_flutter/extension/iterable_extension.dart';
import 'package:expense_tracker_flutter/extension/num_extension.dart';
import 'package:expense_tracker_flutter/extension/sizebox_extension.dart';
import 'package:expense_tracker_flutter/extension/string_extension.dart';
import 'package:expense_tracker_flutter/features/expense/provider/category_expense_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../models/expense_model.dart';

class CategoryExpenses extends ConsumerStatefulWidget {
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
  ConsumerState<CategoryExpenses> createState() => _CategoryExpensesState();
}

class _CategoryExpensesState extends ConsumerState<CategoryExpenses> {
  CategoryExpenseNotifier get controller =>
      ref.read(categoryExpenseProvider.notifier);
  CategoryExpenseNotifier get watchController =>
      ref.watch(categoryExpenseProvider);
  List<Expense> get sortedExpenseData => watchController.sortedExpenseData;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.updateOriginalExpense(widget.expenseData);
      widget.expenseData.sort((a, b) => b.amount.compareTo(a.amount));
      controller.updateSortByDate(false);
      controller.updateSortedExpense(widget.expenseData);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final categoryName = widget.name ?? "";
    final categoryColor = categoryName.getColorByCategory;
    final totalAmountInt = int.tryParse(widget.totalAmount ?? '0') ?? 0;

    return Material(
      color: Colors.transparent,
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.75,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.1),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Drag Handle Indicator
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 8),
                  width: 38,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xff475569)
                        : const Color(0xffCBD5E1),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Header Row: Avatar, Title, Total Spend Badge
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: categoryColor.withValues(
                          alpha: isDark ? 0.25 : 0.12,
                        ),
                      ),
                      child: Image.asset(
                        "${widget.iconPath}",
                        height: 26,
                        width: 26,
                        fit: BoxFit.contain,
                      ),
                    ),
                    14.wGap,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            categoryName.capitalize(),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                          2.hGap,
                          Text(
                            "${sortedExpenseData.length} transaction${sortedExpenseData.length == 1 ? '' : 's'}",
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark
                                  ? Colors.grey[400]
                                  : const Color(0xff64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: categoryColor.withValues(
                          alpha: isDark ? 0.2 : 0.1,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "Rs ${totalAmountInt.toCurrency}",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : categoryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Sort Toggle Row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "TRANSACTIONS",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.1,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        if (watchController.isSortByDate) {
                          widget.expenseData.sort(
                            (a, b) => b.amount.compareTo(a.amount),
                          );
                          controller.updateSortByDate(false);
                          controller.updateSortedExpense(widget.expenseData);
                        } else {
                          widget.expenseData.sort(
                            (a, b) => b.createAt.compareTo(a.createAt),
                          );
                          controller.updateSortByDate(true);
                          controller.updateSortedExpense(widget.expenseData);
                        }
                      },
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xff1E293B)
                              : const Color(0xffF1F5F9),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isDark
                                ? const Color(0xff334155)
                                : const Color(0xffE2E8F0),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Sort: ${watchController.isSortByDate ? "Date" : "Amount"}",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? Colors.white
                                    : const Color(0xff334155),
                              ),
                            ),
                            4.wGap,
                            Icon(
                              Icons.swap_vert_rounded,
                              size: 16,
                              color: isDark
                                  ? Colors.grey[400]
                                  : const Color(0xff64748B),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              12.hGap,
              const Divider(height: 1, thickness: 0.5),
              12.hGap,

              // Petrol Specific Detailed Stats Card
              if (categoryName.trim().toLowerCase() == "petrol")
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: PetrolCategoryDetail(expenseData: sortedExpenseData),
                ),

              // Itemized Expenses List
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: sortedExpenseData.length,
                shrinkWrap: true,
                separatorBuilder: (context, index) => 10.hGap,
                itemBuilder: (context, index) {
                  final expense = sortedExpenseData[index];
                  final expenseDate = DateTime.parse(expense.createAt);

                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xff1E293B)
                          : const Color(0xffF8FAFC),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark
                            ? const Color(0xff334155)
                            : const Color(0xffE2E8F0),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                expense.name.capitalize(),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: isDark
                                      ? Colors.white
                                      : const Color(0xff1E293B),
                                ),
                              ),
                              4.hGap,
                              Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today_rounded,
                                    size: 12,
                                    color: isDark
                                        ? Colors.grey[400]
                                        : Colors.grey[600],
                                  ),
                                  4.wGap,
                                  Text(
                                    expenseDate.toFormattedDateString(),
                                    style: TextStyle(
                                      color: isDark
                                          ? Colors.grey[400]
                                          : Colors.grey[600],
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              "- Rs ${expense.amount.toCurrency}",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xffEF4444),
                              ),
                            ),
                            8.wGap,
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? Colors.grey[800]
                                    : Colors.grey[200],
                                shape: BoxShape.circle,
                              ),
                              child: Image.asset(
                                expense.isCash
                                    ? "assets/images/dollar.png"
                                    : "assets/images/bank.png",
                                height: 14,
                                width: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
              24.hGap,
            ],
          ),
        ),
      ),
    );
  }
}

class PetrolCategoryDetail extends StatelessWidget {
  const PetrolCategoryDetail({super.key, required this.expenseData});

  final List<Expense> expenseData;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final scooterExpenses = expenseData
        .where((e) => !e.name.toLowerCase().contains("bike"))
        .toList();
    final bikeExpenses = expenseData
        .where((e) => e.name.toLowerCase().contains("bike"))
        .toList();

    final hasScooter = scooterExpenses.isNotEmpty;
    final hasBike = bikeExpenses.isNotEmpty;

    final dates =
        expenseData.map((e) => DateTime.parse(e.createAt)).toList();
    final firstDateStr = dates.firstDate()?.toFormattedDateString() ?? "";
    final lastDateStr = dates.lastDate()?.toFormattedDateString() ?? "";

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xff1E293B) : const Color(0xffF1F5F9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? const Color(0xff334155) : const Color(0xffE2E8F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (hasScooter)
                Expanded(
                  child: _VehicleStatTile(
                    title: "Scooter",
                    icon: Icons.two_wheeler_rounded,
                    amount: scooterExpenses.map((e) => e.amount).sum(),
                    daysCount: scooterExpenses
                        .map((e) => DateTime.parse(e.createAt))
                        .toList()
                        .daysDifferenceBetweenFirstAndLast(),
                  ),
                ),
              if (hasScooter && hasBike) 10.wGap,
              if (hasBike)
                Expanded(
                  child: _VehicleStatTile(
                    title: "Bike",
                    icon: Icons.directions_bike_rounded,
                    amount: bikeExpenses.map((e) => e.amount).sum(),
                    daysCount: bikeExpenses
                        .map((e) => DateTime.parse(e.createAt))
                        .toList()
                        .daysDifferenceBetweenFirstAndLast(),
                  ),
                ),
            ],
          ),
          if (firstDateStr.isNotEmpty && lastDateStr.isNotEmpty) ...[
            12.hGap,
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xff0F172A) : Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.calendar_month_rounded,
                    size: 15,
                    color: AppColor.primary,
                  ),
                  6.wGap,
                  Text(
                    firstDateStr,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Icon(
                      Icons.arrow_forward_rounded,
                      size: 13,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                  Text(
                    lastDateStr,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _VehicleStatTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final int amount;
  final int daysCount;

  const _VehicleStatTile({
    required this.title,
    required this.icon,
    required this.amount,
    required this.daysCount,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xff0F172A) : Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColor.primary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 18, color: AppColor.primary),
          ),
          10.wGap,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    if (daysCount > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColor.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          "${daysCount}D",
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: AppColor.primary,
                          ),
                        ),
                      ),
                  ],
                ),
                2.hGap,
                Text(
                  "Rs ${amount.toCurrency}",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.grey[400] : Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
