import 'package:hooks_riverpod/hooks_riverpod.dart';

enum SelectedTab { expense, analytic }

final hometabProvider =
    StateNotifierProvider<HomeDateFilterNotifier, SelectedTab>(
        (ref) => HomeDateFilterNotifier());

class HomeDateFilterNotifier extends StateNotifier<SelectedTab> {
  HomeDateFilterNotifier() : super(SelectedTab.expense);

  void selectTab(SelectedTab dateFilter) => state = dateFilter;
}

final filterScreentabProvider =
    StateNotifierProvider<HomeDateFilterNotifier, SelectedTab>(
        (ref) => HomeDateFilterNotifier());

class FilterScreenDateFilterNotifier extends StateNotifier<SelectedTab> {
  FilterScreenDateFilterNotifier() : super(SelectedTab.expense);

  void selectTab(SelectedTab dateFilter) => state = dateFilter;
}
