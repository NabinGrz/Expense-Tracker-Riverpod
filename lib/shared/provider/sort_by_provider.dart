import 'package:hooks_riverpod/hooks_riverpod.dart';

enum SortBy { none, hightolow, lowtohigh, highTolowDate, lowTohighDate }

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
