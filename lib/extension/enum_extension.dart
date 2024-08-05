import '../shared/provider/sort_by_provider.dart';

// extension StatusExtension on SortBy {
//   String get value {
//     switch (this) {
//       case SortBy.hightolow:
//         return 'High To Low Price';
//       case SortBy.lowtohigh:
//         return 'Low To High Price';
//       case SortBy.highTolowDate:
//         return 'High To Low Date';
//       case SortBy.none:
//         return 'None';
//       case SortBy.lowTohighDate:
//         return 'Low To High Date';
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
      case 'High To Low Date':
        return SortBy.highTolowDate;
      case 'Low To High Date':
        return SortBy.lowTohighDate;
      case 'None':
        return SortBy.none;
      default:
        return SortBy.none;
    }
  }
}
