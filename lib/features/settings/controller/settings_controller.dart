import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsState {
  final int billingStartDay;
  final int restaurantLimit;
  final ThemeMode themeMode;

  SettingsState({
    required this.billingStartDay,
    required this.restaurantLimit,
    required this.themeMode,
  });

  SettingsState copyWith({
    int? billingStartDay,
    int? restaurantLimit,
    ThemeMode? themeMode,
  }) {
    return SettingsState(
      billingStartDay: billingStartDay ?? this.billingStartDay,
      restaurantLimit: restaurantLimit ?? this.restaurantLimit,
      themeMode: themeMode ?? this.themeMode,
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
  static const String _themeModeKey = 'theme_mode';

  @override
  Future<SettingsState> build() async {
    final prefs = await SharedPreferences.getInstance();
    final billingStartDay = prefs.getInt(_billingStartDayKey) ?? 7;
    final restaurantLimit = prefs.getInt(_restaurantLimitKey) ?? 4000;
    final themeModeIndex =
        prefs.getInt(_themeModeKey) ?? 0; // 0: System, 1: Light, 2: Dark

    return SettingsState(
      billingStartDay: billingStartDay,
      restaurantLimit: restaurantLimit,
      themeMode: ThemeMode.values[themeModeIndex],
    );
  }

  Future<void> updateBillingStartDay(int day) async {
    state = const AsyncValue.loading();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_billingStartDayKey, day);

      state = AsyncValue.data(
        (state.value ??
                SettingsState(
                  billingStartDay: day,
                  restaurantLimit: 4000,
                  themeMode: ThemeMode.system,
                ))
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
                SettingsState(
                  billingStartDay: 7,
                  restaurantLimit: limit,
                  themeMode: ThemeMode.system,
                ))
            .copyWith(restaurantLimit: limit),
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateThemeMode(ThemeMode mode) async {
    state = const AsyncValue.loading();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_themeModeKey, mode.index);

      state = AsyncValue.data(
        (state.value ??
                SettingsState(
                  billingStartDay: 7,
                  restaurantLimit: 4000,
                  themeMode: mode,
                ))
            .copyWith(themeMode: mode),
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
