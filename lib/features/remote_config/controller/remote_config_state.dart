import 'package:flutter/foundation.dart';

@immutable
class RemoteConfigState {
  final String welcomeMessage;
  final bool isMaintenanceMode;
  final String announcementMessage;
  final bool showAnnouncement;
  final String minAppVersion;
  final DateTime lastUpdated;

  const RemoteConfigState({
    required this.welcomeMessage,
    required this.isMaintenanceMode,
    required this.announcementMessage,
    required this.showAnnouncement,
    required this.minAppVersion,
    required this.lastUpdated,
  });

  RemoteConfigState copyWith({
    String? welcomeMessage,
    bool? isMaintenanceMode,
    String? announcementMessage,
    bool? showAnnouncement,
    String? minAppVersion,
    DateTime? lastUpdated,
  }) {
    return RemoteConfigState(
      welcomeMessage: welcomeMessage ?? this.welcomeMessage,
      isMaintenanceMode: isMaintenanceMode ?? this.isMaintenanceMode,
      announcementMessage: announcementMessage ?? this.announcementMessage,
      showAnnouncement: showAnnouncement ?? this.showAnnouncement,
      minAppVersion: minAppVersion ?? this.minAppVersion,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}
