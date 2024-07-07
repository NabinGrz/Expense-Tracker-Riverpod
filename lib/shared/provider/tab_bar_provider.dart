import 'package:hooks_riverpod/hooks_riverpod.dart';

enum SelectedTab { expense, analytic }

final tabProvider = StateNotifierProvider<DateFilterNotifier, SelectedTab>(
    (ref) => DateFilterNotifier());

class DateFilterNotifier extends StateNotifier<SelectedTab> {
  DateFilterNotifier() : super(SelectedTab.expense);

  void selectTab(SelectedTab dateFilter) => state = dateFilter;
}
