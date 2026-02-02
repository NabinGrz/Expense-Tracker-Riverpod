import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final settingsControllerProvider =
    AsyncNotifierProvider<SettingsController, int>(SettingsController.new);

class SettingsController extends AsyncNotifier<int> {
  static const String _billingStartDayKey = 'billing_start_day';

  @override
  Future<int> build() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_billingStartDayKey) ?? 7; // Default to 7
  }

  Future<void> updateBillingStartDay(int day) async {
    state = const AsyncValue.loading();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_billingStartDayKey, day);
      state = AsyncValue.data(day);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
