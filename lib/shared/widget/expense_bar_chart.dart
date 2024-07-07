import 'package:expense_tracker_flutter/extension/iterable_extension.dart';
import 'package:expense_tracker_flutter/models/expense_model.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../models/expense_entity.dart';

class ExpenseBarChart extends StatelessWidget {
  final List<Expense> expenses;

  const ExpenseBarChart({super.key, required this.expenses});

  @override
  Widget build(BuildContext context) {
    Map<String, int> categoryTotals = expenses.totalAmountByCategory();
    List<BarChartGroupData> barGroups = [];
    int index = 0;

    categoryTotals.forEach((category, amount) {
      barGroups.add(
        BarChartGroupData(
          x: index++,
          barRods: [
            BarChartRodData(
              toY: amount.toDouble(),
              color: Colors.blue,
            )
          ],
        ),
      );
    });

    return BarChart(
      BarChartData(
        barGroups: barGroups,
        titlesData: FlTitlesData(
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: true),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double value, TitleMeta meta) {
                return Text(categoryTotals.keys.elementAt(value.toInt()));
              },
            ),
          ),
        ),
      ),
    );
  }
}
