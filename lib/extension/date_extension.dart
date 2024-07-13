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
}
