import 'package:hooks_riverpod/hooks_riverpod.dart';

enum SortBy {
  none('None'),
  hightolow('High To Low Price'),
  lowtohigh('Low To High Price'),
  highTolowDate('Latest To Old Date'),
  lowTohighDate('Old To Latest Date'),
  ascending('Ascending'),
  descending('Descending');

  const SortBy(this.value);
  final String value;
}

final homeSortByProvider =
    StateNotifierProvider<SortByNotifier, SortBy>((ref) => SortByNotifier());

class SortByNotifier extends StateNotifier<SortBy> {
  SortByNotifier() : super(SortBy.none);

  void selectSortBy(SortBy sortBy) => state = sortBy;
}

final filterScreenSortByProvider =
    StateNotifierProvider<FilterScreenSortByNotifier, SortBy>(
        (ref) => FilterScreenSortByNotifier());

class FilterScreenSortByNotifier extends StateNotifier<SortBy> {
  FilterScreenSortByNotifier() : super(SortBy.none);

  void selectSortBy(SortBy sortBy) => state = sortBy;
}
