import 'dart:async';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

class RemoteConfigKeys {
  static const String welcomeMessage = 'welcome_message';
  static const String isMaintenanceMode = 'is_maintenance_mode';
  static const String announcementMessage = 'announcement_message';
  static const String showAnnouncement = 'show_announcement';
  static const String minAppVersion = 'min_app_version';
}

class RemoteConfigService {
  final FirebaseRemoteConfig _remoteConfig;

  RemoteConfigService({FirebaseRemoteConfig? remoteConfig})
      : _remoteConfig = remoteConfig ?? FirebaseRemoteConfig.instance;

  static const Map<String, dynamic> _defaultValues = {
    RemoteConfigKeys.welcomeMessage: 'Welcome to Expense Tracker!',
    RemoteConfigKeys.isMaintenanceMode: false,
    RemoteConfigKeys.announcementMessage: 'Welcome to Expense Tracker!',
    RemoteConfigKeys.showAnnouncement: false,
    RemoteConfigKeys.minAppVersion: '1.0.0',
  };

  /// Initializes Remote Config with appropriate fetch intervals and default values.
  Future<void> initialize() async {
    try {
      await _remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: Duration.zero,
        ),
      );
      await _remoteConfig.setDefaults(_defaultValues);
      await fetchAndActivate();
    } catch (e) {
      debugPrint('RemoteConfig initialization error: $e');
    }
  }

  /// Fetches latest values from remote server and activates them.
  Future<bool> fetchAndActivate() async {
    try {
      final updated = await _remoteConfig.fetchAndActivate();
      debugPrint('RemoteConfig fetchAndActivate result: $updated');
      return updated;
    } catch (e) {
      debugPrint('RemoteConfig fetchAndActivate error: $e');
      return false;
    }
  }

  /// Real-time stream that emits whenever parameters are published to the remote config template.
  Stream<RemoteConfigUpdate> get onConfigUpdated =>
      _remoteConfig.onConfigUpdated;

  /// Activates the fetched configs.
  Future<void> activate() async {
    try {
      await _remoteConfig.activate();
    } catch (e) {
      debugPrint('RemoteConfig activate error: $e');
    }
  }

  bool getBool(String key) => _remoteConfig.getBool(key);
  String getString(String key) => _remoteConfig.getString(key);
  int getInt(String key) => _remoteConfig.getInt(key);
  double getDouble(String key) => _remoteConfig.getDouble(key);
}
