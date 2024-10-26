import '../shared/provider/sort_by_provider.dart';

// extension StatusExtension on SortBy {
//   String get value {
//     switch (this) {
//       case SortBy.hightolow:
//         return 'High To Low Price';
//       case SortBy.lowtohigh:
//         return 'Low To High Price';
//       case SortBy.highTolowDate:
//         return 'Latest To Old Date';
//       case SortBy.none:
//         return 'None';
//       case SortBy.lowTohighDate:
//         return 'Old To Latest Date';
//     }
//   }
// }

extension StringToEnumExtension on String {
  SortBy get enumVal {
    switch (this) {
      case 'High To Low Price':
        return SortBy.hightolow;
      case 'Low To High Price':
        return SortBy.lowtohigh;
      case 'Latest To Old Date':
        return SortBy.highTolowDate;
      case 'Old To Latest Date':
        return SortBy.lowTohighDate;
      case 'Ascending':
        return SortBy.ascending;
      case 'Descending':
        return SortBy.descending;
      case 'None':
        return SortBy.none;
      default:
        return SortBy.none;
    }
  }
}
