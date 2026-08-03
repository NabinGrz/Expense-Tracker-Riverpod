import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker_flutter/constants/firebase_constants.dart';
import 'package:expense_tracker_flutter/helper/firebase_query_handler.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsState {
  final int billingStartDay;
  final int restaurantLimit;
  final ThemeMode themeMode;
  final Map<String, int> categoryLimits;

  SettingsState({
    required this.billingStartDay,
    required this.restaurantLimit,
    required this.themeMode,
    required this.categoryLimits,
  });

  SettingsState copyWith({
    int? billingStartDay,
    int? restaurantLimit,
    ThemeMode? themeMode,
    Map<String, int>? categoryLimits,
  }) {
    return SettingsState(
      billingStartDay: billingStartDay ?? this.billingStartDay,
      restaurantLimit: restaurantLimit ?? this.restaurantLimit,
      themeMode: themeMode ?? this.themeMode,
      categoryLimits: categoryLimits ?? this.categoryLimits,
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
  static const String _categoryLimitsKey = 'category_limits';

  StreamSubscription? _settingsSubscription;

  @override
  Future<SettingsState> build() async {
    final prefs = await SharedPreferences.getInstance();
    final billingStartDay = prefs.getInt(_billingStartDayKey) ?? 7;
    final restaurantLimit = prefs.getInt(_restaurantLimitKey) ?? 4000;
    final themeModeIndex = prefs.getInt(_themeModeKey) ?? 0;

    Map<String, int> initialCategoryLimits = {};
    final limitsJsonStr = prefs.getString(_categoryLimitsKey);
    if (limitsJsonStr != null) {
      try {
        final decoded = jsonDecode(limitsJsonStr) as Map<String, dynamic>;
        initialCategoryLimits = decoded.map((k, v) => MapEntry(k, (v as num).toInt()));
      } catch (_) {}
    }
    if (!initialCategoryLimits.containsKey('restaurant/cafe')) {
      initialCategoryLimits['restaurant/cafe'] = restaurantLimit;
    }

    final initialState = SettingsState(
      billingStartDay: billingStartDay,
      restaurantLimit: initialCategoryLimits['restaurant/cafe'] ?? restaurantLimit,
      themeMode: ThemeMode.values[themeModeIndex],
      categoryLimits: initialCategoryLimits,
    );

    // Listen to real-time updates from Firebase Firestore
    _listenToFirestoreSettings();

    return initialState;
  }

  void _listenToFirestoreSettings() {
    _settingsSubscription?.cancel();
    final stream = FirebaseQueryHelper.getSingleDocumentAsStream(
      collectionPath: FirebaseConstants.settingsCollection,
      docID: FirebaseConstants.settingsDocID,
    );

    if (stream != null) {
      _settingsSubscription = stream.listen((snapshot) async {
        if (snapshot.exists && snapshot.data() != null) {
          final data = snapshot.data()!;
          final current = state.value;

          final billingStartDay =
              (data['billing_start_day'] as num?)?.toInt() ??
                  current?.billingStartDay ??
                  7;

          final rawThemeIndex = (data['theme_mode'] as num?)?.toInt();
          final themeMode = rawThemeIndex != null
              ? ThemeMode.values[rawThemeIndex]
              : (current?.themeMode ?? ThemeMode.system);

          Map<String, int> categoryLimits = {};
          if (data['category_limits'] != null) {
            final rawMap = data['category_limits'] as Map<String, dynamic>;
            categoryLimits = rawMap.map((k, v) => MapEntry(k, (v as num).toInt()));
          } else if (data['restaurant_limit'] != null) {
            categoryLimits['restaurant/cafe'] =
                (data['restaurant_limit'] as num).toInt();
          } else if (current != null) {
            categoryLimits = Map<String, int>.from(current.categoryLimits);
          }

          if (!categoryLimits.containsKey('restaurant/cafe')) {
            categoryLimits['restaurant/cafe'] = 4000;
          }

          final newState = SettingsState(
            billingStartDay: billingStartDay,
            restaurantLimit: categoryLimits['restaurant/cafe'] ?? 4000,
            themeMode: themeMode,
            categoryLimits: categoryLimits,
          );

          // Update local SharedPreferences cache
          final prefs = await SharedPreferences.getInstance();
          await prefs.setInt(_billingStartDayKey, billingStartDay);
          await prefs.setInt(_themeModeKey, themeMode.index);
          await prefs.setString(_categoryLimitsKey, jsonEncode(categoryLimits));

          state = AsyncValue.data(newState);
        }
      });
    }
  }

  Future<void> updateBillingStartDay(int day) async {
    try {
      final docRef = FirebaseQueryHelper.firebaseFireStore
          .collection(FirebaseConstants.settingsCollection)
          .doc(FirebaseConstants.settingsDocID);

      await docRef.set({'billing_start_day': day}, SetOptions(merge: true));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateRestaurantLimit(int limit) async {
    await updateCategoryLimit('restaurant/cafe', limit);
  }

  Future<void> updateCategoryLimit(String category, int limit) async {
    try {
      final currentMap = Map<String, int>.from(state.value?.categoryLimits ?? {});
      currentMap[category] = limit;

      final docRef = FirebaseQueryHelper.firebaseFireStore
          .collection(FirebaseConstants.settingsCollection)
          .doc(FirebaseConstants.settingsDocID);

      final updateData = <String, dynamic>{
        'category_limits': currentMap,
      };
      if (category == 'restaurant/cafe') {
        updateData['restaurant_limit'] = limit;
      }

      await docRef.set(updateData, SetOptions(merge: true));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> removeCategoryLimit(String category) async {
    try {
      final currentMap = Map<String, int>.from(state.value?.categoryLimits ?? {});
      currentMap.remove(category);

      final docRef = FirebaseQueryHelper.firebaseFireStore
          .collection(FirebaseConstants.settingsCollection)
          .doc(FirebaseConstants.settingsDocID);

      try {
        await docRef.update({
          'category_limits.$category': FieldValue.delete(),
        });
      } catch (_) {
        await docRef.set({'category_limits': currentMap}, SetOptions(merge: true));
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_categoryLimitsKey, jsonEncode(currentMap));

      if (state.value != null) {
        state = AsyncValue.data(
          state.value!.copyWith(categoryLimits: currentMap),
        );
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateThemeMode(ThemeMode mode) async {
    try {
      final docRef = FirebaseQueryHelper.firebaseFireStore
          .collection(FirebaseConstants.settingsCollection)
          .doc(FirebaseConstants.settingsDocID);

      await docRef.set({'theme_mode': mode.index}, SetOptions(merge: true));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
