import 'package:intl/intl.dart';

extension DateExtension on DateTime {
  bool isSameDateAs(DateTime date) =>
      date.year == year && date.month == month && date.day == day;

  bool isDateInRange(DateTime startDate, DateTime endDate) {
    DateTime strippedDate = DateTime(year, month, day);
    DateTime strippedStartDate =
        DateTime(startDate.year, startDate.month, startDate.day);
    DateTime strippedEndDate =
        DateTime(endDate.year, endDate.month, endDate.day);

    return (strippedDate.isAtSameMomentAs(strippedStartDate) ||
            strippedDate.isAfter(strippedStartDate)) &&
        (strippedDate.isAtSameMomentAs(strippedEndDate) ||
            strippedDate.isBefore(strippedEndDate));
  }

  String toFormattedDateString() => DateFormat('EEEE, d MMMM').format(this);

  String formatCustomDate(String format) => DateFormat(format).format(this);

  bool isYesterday() {
    final now = DateTime.now();
    final yesterday = DateTime(now.year, now.month, now.day - 1);

    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }
}

extension DateDifferenceExtension on List<DateTime> {
  int daysDifferenceBetweenFirstAndLast() {
    if (isEmpty) return 0; // Return 0 for an empty list

    // Sort dates to get the earliest and latest dates
    final sortedDates = this..sort();

    final firstDate = sortedDates.first;
    final lastDate = sortedDates.last;

    // Adding 1 to include both first and last date in the difference
    return lastDate.difference(firstDate).inDays + 1;
  }

  DateTime? firstDate() {
    if (isEmpty) return null;
    final sortedDates = this..sort();
    return sortedDates.first;
  }

  DateTime? lastDate() {
    if (isEmpty) return null;
    final sortedDates = this..sort();
    return sortedDates.last;
  }
}
