# Graph Report - Expense-Tracker-Riverpod  (2026-08-21)

## Corpus Check
- 150 files · ~719,158 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 148 nodes · 165 edges · 8 communities
- Extraction: 100% EXTRACTED · 0% INFERRED · 0% AMBIGUOUS
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `cce5fc27`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- home_screen.dart
- settings_screen.dart
- remote_config_service.dart
- remote_config_controller.dart
- remote_config_announcement_banner.dart
- remote_config_state.dart
- GeneratedPluginRegistrant.swift
- _HomeScreenState

## God Nodes (most connected - your core abstractions)
1. `_HomeScreenState` - 6 edges
2. `remoteConfigControllerProvider` - 5 edges
3. `RemoteConfigController` - 4 edges
4. `SettingsScreen` - 4 edges
5. `build` - 4 edges
6. `HomeScreen` - 3 edges
7. `remoteConfigServiceProvider` - 3 edges
8. `RemoteConfigState` - 3 edges
9. `RemoteConfigAnnouncementBanner` - 3 edges
10. `_AppIconPicker` - 3 edges

## Surprising Connections (you probably didn't know these)
- `RemoteConfigController` --references--> `RemoteConfigState`  [EXTRACTED]
  lib/features/remote_config/controller/remote_config_controller.dart → lib/features/remote_config/controller/remote_config_state.dart
- `build` --references--> `remoteConfigControllerProvider`  [EXTRACTED]
  lib/features/remote_config/widgets/remote_config_announcement_banner.dart → lib/features/remote_config/controller/remote_config_controller.dart
- `RemoteConfigAnnouncementBanner` --references--> `remoteConfigControllerProvider`  [EXTRACTED]
  lib/features/remote_config/widgets/remote_config_announcement_banner.dart → lib/features/remote_config/controller/remote_config_controller.dart
- `build` --references--> `remoteConfigControllerProvider`  [EXTRACTED]
  lib/features/settings/screen/settings_screen.dart → lib/features/remote_config/controller/remote_config_controller.dart
- `SettingsScreen` --references--> `remoteConfigControllerProvider`  [EXTRACTED]
  lib/features/settings/screen/settings_screen.dart → lib/features/remote_config/controller/remote_config_controller.dart

## Import Cycles
- None detected.

## Communities (8 total, 0 thin omitted)

### Community 0 - "home_screen.dart"
Cohesion: 0.06
Nodes (33): bool get, dart:convert, ../entity/home_entity.dart, ../../../helper/expense_query_helper.dart, ../../../helper/firebase_query_handler.dart, HomeEntity get, HomeNotifier get, bottomNavBarProvider (+25 more)

### Community 1 - "settings_screen.dart"
Cohesion: 0.06
Nodes (32): AppIconOption, _AppIconPicker, _AppIconPickerState, availableCategories, _buildAppIconSection, _buildSectionHeader, _buildSettingCard, createState (+24 more)

### Community 2 - "remote_config_service.dart"
Cohesion: 0.09
Nodes (21): FirebaseRemoteConfig, activate, announcementMessage, _defaultValues, fetchAndActivate, getBool, getDouble, getInt (+13 more)

### Community 3 - "remote_config_controller.dart"
Cohesion: 0.15
Nodes (14): AsyncNotifier, dart:async, build, _listenToRealtimeUpdates, _readCurrentState, _realtimeSubscription, refreshConfig, RemoteConfigController (+6 more)

### Community 4 - "remote_config_announcement_banner.dart"
Cohesion: 0.18
Nodes (13): ConsumerWidget, ../controller/remote_config_controller.dart, remoteConfigControllerProvider, build, RemoteConfigAnnouncementBanner, build, SettingsScreen, MaterialPageRoute (+5 more)

### Community 5 - "remote_config_state.dart"
Cohesion: 0.17
Nodes (11): @immutable, DateTime, announcementMessage, copyWith, isMaintenanceMode, lastUpdated, minAppVersion, RemoteConfigState (+3 more)

### Community 6 - "GeneratedPluginRegistrant.swift"
Cohesion: 0.20
Nodes (9): cloud_firestore, firebase_core, firebase_remote_config, firebase_storage, FlutterMacOS, FlutterPluginRegistry, Foundation, RegisterGeneratedPlugins() (+1 more)

### Community 7 - "_HomeScreenState"
Cohesion: 0.25
Nodes (8): AutomaticKeepAliveClientMixin, ConsumerState, ConsumerStatefulWidget, homeEntityProvider, homeSortByProvider, HomeScreen, _HomeScreenState, listenToSorting

## Knowledge Gaps
- **62 isolated node(s):** `bottomNavBarProvider`, `wantKeepAlive`, `searchController`, `originalExpenseList`, `controller` (+57 more)
  These have ≤1 connection - possible missing edges or undocumented components.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `RemoteConfigService` connect `remote_config_controller.dart` to `remote_config_service.dart`?**
  _High betweenness centrality (0.070) - this node is a cross-community bridge._
- **Why does `_HomeScreenState` connect `_HomeScreenState` to `home_screen.dart`?**
  _High betweenness centrality (0.044) - this node is a cross-community bridge._
- **Why does `remoteConfigControllerProvider` connect `remote_config_announcement_banner.dart` to `remote_config_controller.dart`?**
  _High betweenness centrality (0.035) - this node is a cross-community bridge._
- **What connects `bottomNavBarProvider`, `wantKeepAlive`, `searchController` to the rest of the system?**
  _62 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `home_screen.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.058823529411764705 - nodes in this community are weakly interconnected._
- **Should `settings_screen.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.0625 - nodes in this community are weakly interconnected._
- **Should `remote_config_service.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.09090909090909091 - nodes in this community are weakly interconnected._