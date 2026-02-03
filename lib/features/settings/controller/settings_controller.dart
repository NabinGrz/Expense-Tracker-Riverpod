import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsState {
  final int billingStartDay;
  final int restaurantLimit;

  SettingsState({required this.billingStartDay, required this.restaurantLimit});

  SettingsState copyWith({int? billingStartDay, int? restaurantLimit}) {
    return SettingsState(
      billingStartDay: billingStartDay ?? this.billingStartDay,
      restaurantLimit: restaurantLimit ?? this.restaurantLimit,
    );
  }
}

final settingsControllerProvider =
    AsyncNotifierProvider<SettingsController, SettingsState>(
      SettingsController.new,
    );

class SettingsController extends AsyncNotifier<SettingsState> {
  static const String _billingStartDayKey = 'billing_start_day';
  static const String _restaurantLimitKey = 'restaurant_limit';

  @override
  Future<SettingsState> build() async {
    final prefs = await SharedPreferences.getInstance();
    final billingStartDay = prefs.getInt(_billingStartDayKey) ?? 7;
    final restaurantLimit = prefs.getInt(_restaurantLimitKey) ?? 4000;

    return SettingsState(
      billingStartDay: billingStartDay,
      restaurantLimit: restaurantLimit,
    );
  }

  Future<void> updateBillingStartDay(int day) async {
    state = const AsyncValue.loading();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_billingStartDayKey, day);

      // Update state with new value while keeping others
      state = AsyncValue.data(
        (state.value ??
                SettingsState(billingStartDay: day, restaurantLimit: 4000))
            .copyWith(billingStartDay: day),
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateRestaurantLimit(int limit) async {
    state = const AsyncValue.loading();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_restaurantLimitKey, limit);

      state = AsyncValue.data(
        (state.value ??
                SettingsState(billingStartDay: 7, restaurantLimit: limit))
            .copyWith(restaurantLimit: limit),
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
