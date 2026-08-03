import 'package:flutter/foundation.dart';
import 'package:flutter_dynamic_icon/flutter_dynamic_icon.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Available app icon options.
enum AppIconOption {
  defaultIcon,
  dark,
  gold;

  /// The iOS alternate icon name as registered in Info.plist.
  /// Null means reset to primary icon.
  String? get iconName {
    switch (this) {
      case AppIconOption.defaultIcon:
        return null;
      case AppIconOption.dark:
        return 'AppIcon-Dark';
      case AppIconOption.gold:
        return 'AppIcon-Gold';
    }
  }

  String get label {
    switch (this) {
      case AppIconOption.defaultIcon:
        return 'Default';
      case AppIconOption.dark:
        return 'Dark';
      case AppIconOption.gold:
        return 'Gold';
    }
  }

  /// Asset path for the preview thumbnail shown in the settings UI.
  String get previewAsset {
    switch (this) {
      case AppIconOption.defaultIcon:
        return 'assets/images/app_icon.png';
      case AppIconOption.dark:
        return 'assets/images/app_icon_dark.png';
      case AppIconOption.gold:
        return 'assets/images/app_icon_gold.png';
    }
  }
}

const _kPrefsKey = 'selected_app_icon';

class AppIconService {
  AppIconService._();

  /// Returns whether the device supports alternate icons.
  static Future<bool> get isSupported async {
    try {
      return await FlutterDynamicIcon.supportsAlternateIcons;
    } catch (_) {
      return false;
    }
  }

  /// Returns the currently active icon option by reading SharedPreferences.
  static Future<AppIconOption> getCurrentIcon() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_kPrefsKey);
    return AppIconOption.values.firstWhere(
      (e) => e.name == saved,
      orElse: () => AppIconOption.defaultIcon,
    );
  }

  /// Switches the app icon to [option].
  /// Returns true on success, false on failure.
  static Future<bool> switchIcon(AppIconOption option) async {
    try {
      final supported = await isSupported;
      if (!supported) return false;

      await FlutterDynamicIcon.setAlternateIconName(option.iconName);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_kPrefsKey, option.name);
      return true;
    } catch (e) {
      debugPrint('AppIconService.switchIcon error: $e');
      return false;
    }
  }
}
