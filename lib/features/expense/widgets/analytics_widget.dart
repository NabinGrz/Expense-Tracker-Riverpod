import 'package:expense_tracker_flutter/extension/num_extension.dart';
import 'package:expense_tracker_flutter/extension/sizebox_extension.dart';
import 'package:expense_tracker_flutter/extension/string_extension.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../models/expense_model.dart';
import 'category_expense.dart';

class AnalyticsWidget extends StatefulWidget {
  final List<MapEntry<String, Map<String, dynamic>>>? sortedCategories;
  const AnalyticsWidget({super.key, this.sortedCategories});

  @override
  State<AnalyticsWidget> createState() => _AnalyticsWidgetState();
}

class _AnalyticsWidgetState extends State<AnalyticsWidget> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final categories = widget.sortedCategories ?? [];
    if (categories.isEmpty) {
      return const SizedBox.shrink();
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final grandTotal = categories.fold<int>(
      0,
      (sum, item) => sum + ((item.value['totalAmount'] as int?) ?? 0),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Interactive Donut Chart Container
        Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xff1E293B) : const Color(0xffF8FAFC),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark ? const Color(0xff334155) : const Color(0xffE2E8F0),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              const Text(
                "Category Share",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              16.hGap,
              SizedBox(
                height: 200,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    PieChart(
                      PieChartData(
                        pieTouchData: PieTouchData(
                          touchCallback: (FlTouchEvent event, pieTouchResponse) {
                            setState(() {
                              if (!event.isInterestedForInteractions ||
                                  pieTouchResponse == null ||
                                  pieTouchResponse.touchedSection == null) {
                                touchedIndex = -1;
                                return;
                              }
                              touchedIndex = pieTouchResponse
                                  .touchedSection!.touchedSectionIndex;
                            });
                          },
                        ),
                        borderData: FlBorderData(show: false),
                        sectionsSpace: 3,
                        centerSpaceRadius: 65,
                        sections: List.generate(categories.length, (i) {
                          final isTouched = i == touchedIndex;
                          final radius = isTouched ? 34.0 : 26.0;
                          final item = categories[i];
                          final amount = (item.value['totalAmount'] as int?) ?? 0;
                          final color = item.key.getColorByCategory;

                          return PieChartSectionData(
                            color: color,
                            value: amount.toDouble(),
                            title: '',
                            radius: radius,
                          );
                        }),
                      ),
                    ),
                    // Center Summary Info
                    Builder(
                      builder: (context) {
                        if (touchedIndex >= 0 &&
                            touchedIndex < categories.length) {
                          final selected = categories[touchedIndex];
                          final amount =
                              (selected.value['totalAmount'] as int?) ?? 0;
                          final percentage = grandTotal > 0
                              ? ((amount / grandTotal) * 100).toStringAsFixed(1)
                              : "0";

                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                selected.key.capitalize(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? Colors.grey[400]
                                      : const Color(0xff64748B),
                                ),
                              ),
                              2.hGap,
                              Text(
                                "Rs ${amount.toCurrency}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              2.hGap,
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: selected.key.getColorByCategory
                                      .withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  "$percentage%",
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: selected.key.getColorByCategory,
                                  ),
                                ),
                              ),
                            ],
                          );
                        } else {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Total Spend",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: isDark
                                      ? Colors.grey[400]
                                      : const Color(0xff64748B),
                                ),
                              ),
                              4.hGap,
                              Text(
                                "Rs ${grandTotal.toCurrency}",
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              2.hGap,
                              Text(
                                "${categories.length} categories",
                                style: TextStyle(
                                  fontSize: 11,
                                  color: isDark
                                      ? Colors.grey[500]
                                      : const Color(0xff94A3B8),
                                ),
                              ),
                            ],
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        20.hGap,

        // Detailed Category Breakdown List
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          itemCount: categories.length,
          separatorBuilder: (context, index) => 10.hGap,
          itemBuilder: (context, index) {
            final category = categories[index];
            final expenses = category.value['expenses'] as List<Expense>;
            final amount = (category.value['totalAmount'] as int?) ?? 0;
            final percentageNum =
                grandTotal > 0 ? (amount / grandTotal) : 0.0;
            final percentageStr = (percentageNum * 100).toStringAsFixed(1);
            final categoryColor = category.key.getColorByCategory;

            return Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  showCupertinoModalPopup(
                    context: context,
                    builder: (context) {
                      return CategoryExpenses(
                        expenseData: expenses,
                        name: category.key,
                        iconPath: category.key.getIconPathByCategory,
                        totalAmount: amount.toString(),
                      );
                    },
                  );
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xff1E293B)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark
                          ? const Color(0xff334155)
                          : const Color(0xffF1F5F9),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black
                            .withValues(alpha: isDark ? 0.25 : 0.03),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Category Avatar Icon
                      Container(
                        width: 44,
                        height: 44,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: categoryColor.withValues(
                            alpha: isDark ? 0.25 : 0.12,
                          ),
                        ),
                        child: Image.asset(
                          category.key.getIconPathByCategory,
                          height: 24,
                          width: 24,
                          fit: BoxFit.contain,
                        ),
                      ),
                      14.wGap,
                      // Category Name and transaction count
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              category.key.capitalize(),
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? Colors.white
                                    : const Color(0xff1E293B),
                              ),
                            ),
                            3.hGap,
                            Text(
                              "${expenses.length} transaction${expenses.length == 1 ? '' : 's'}",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: isDark
                                    ? const Color(0xff94A3B8)
                                    : const Color(0xff64748B),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Percentage Badge and Amount
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: categoryColor.withValues(
                                alpha: isDark ? 0.2 : 0.1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              "$percentageStr%",
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : categoryColor,
                              ),
                            ),
                          ),
                          12.wGap,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "Rs ${amount.toCurrency}",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : const Color(0xff1E293B),
                                ),
                              ),
                              2.hGap,
                              Icon(
                                Icons.chevron_right_rounded,
                                size: 16,
                                color: isDark
                                    ? Colors.grey[500]
                                    : const Color(0xff94A3B8),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
