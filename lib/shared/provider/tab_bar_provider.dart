import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:haptic_feedback/haptic_feedback.dart';

enum SelectedTab {
  expense('Expenses'),
  analytic('Analytics');

  const SelectedTab(this.value);
  final String value;
}

final hometabProvider =
    StateNotifierProvider<HomeDateFilterNotifier, SelectedTab>(
        (ref) => HomeDateFilterNotifier());

class HomeDateFilterNotifier extends StateNotifier<SelectedTab> {
  HomeDateFilterNotifier() : super(SelectedTab.expense);

  void selectTab(SelectedTab dateFilter) {
    state = dateFilter;
  }
}

final filterScreentabProvider =
    StateNotifierProvider<FilterScreenDateFilterNotifier, SelectedTab>(
        (ref) => FilterScreenDateFilterNotifier());

class FilterScreenDateFilterNotifier extends StateNotifier<SelectedTab> {
  FilterScreenDateFilterNotifier() : super(SelectedTab.expense);

  void selectTab(SelectedTab dateFilter) => state = dateFilter;
}
