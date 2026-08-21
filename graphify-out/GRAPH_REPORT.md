# Graph Report - Expense-Tracker-Riverpod  (2026-08-21)

## Corpus Check
- 155 files · ~722,449 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 298 nodes · 373 edges · 13 communities (12 shown, 1 thin omitted)
- Extraction: 100% EXTRACTED · 0% INFERRED · 0% AMBIGUOUS
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `91d46127`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- home_screen.dart
- settings_screen.dart
- remote_config_service.dart
- remote_config_controller.dart
- dashboard.dart
- create_update_expense_provider.dart
- GeneratedPluginRegistrant.swift
- expense_entity.dart
- settings_controller.dart
- add_edit_upcoming_dialog.dart
- firebase_constants.dart
- settingsControllerProvider
- settingsControllerProvider

## God Nodes (most connected - your core abstractions)
1. `_HomeScreenState` - 6 edges
2. `settingsControllerProvider` - 5 edges
3. `_DashboardState` - 4 edges
4. `SettingsScreen` - 4 edges
5. `build` - 4 edges
6. `_AddEditUpcomingDialogState` - 4 edges
7. `RemoteConfigController` - 4 edges
8. `Dashboard` - 3 edges
9. `SettingsController` - 3 edges
10. `_AppIconPicker` - 3 edges

## Surprising Connections (you probably didn't know these)
- `_AddEditUpcomingDialogState` --references--> `settingsControllerProvider`  [EXTRACTED]
  lib/features/upcoming_expenses/widgets/add_edit_upcoming_dialog.dart → lib/features/settings/controller/settings_controller.dart
- `initState` --references--> `settingsControllerProvider`  [EXTRACTED]
  lib/features/upcoming_expenses/widgets/add_edit_upcoming_dialog.dart → lib/features/settings/controller/settings_controller.dart
- `build` --references--> `settingsControllerProvider`  [EXTRACTED]
  lib/features/settings/screen/settings_screen.dart → lib/features/settings/controller/settings_controller.dart
- `SettingsScreen` --references--> `settingsControllerProvider`  [EXTRACTED]
  lib/features/settings/screen/settings_screen.dart → lib/features/settings/controller/settings_controller.dart
- `RemoteConfigController` --references--> `RemoteConfigState`  [EXTRACTED]
  lib/features/remote_config/controller/remote_config_controller.dart → lib/features/remote_config/controller/remote_config_state.dart

## Import Cycles
- None detected.

## Communities (13 total, 1 thin omitted)

### Community 0 - "home_screen.dart"
Cohesion: 0.05
Nodes (39): AutomaticKeepAliveClientMixin, ConsumerState, ConsumerStatefulWidget, ../entity/home_entity.dart, ../../../helper/expense_query_helper.dart, ../../../helper/firebase_query_handler.dart, HomeEntity get, homeEntityProvider (+31 more)

### Community 1 - "settings_screen.dart"
Cohesion: 0.05
Nodes (41): AppIconOption, _AppIconPicker, _AppIconPickerState, availableCategories, _buildAppIconSection, _buildSectionHeader, _buildSettingCard, createState (+33 more)

### Community 2 - "remote_config_service.dart"
Cohesion: 0.10
Nodes (20): FirebaseRemoteConfig, activate, announcementMessage, _defaultValues, fetchAndActivate, getBool, getDouble, getInt (+12 more)

### Community 3 - "remote_config_controller.dart"
Cohesion: 0.09
Nodes (24): @immutable, dart:async, DateTime, build, _listenToRealtimeUpdates, _readCurrentState, _realtimeSubscription, refreshConfig (+16 more)

### Community 4 - "dashboard.dart"
Cohesion: 0.10
Nodes (22): bottomNavBarProvider, ../controller/remote_config_controller.dart, ../expense/screen/home_screen.dart, int get, build, createState, currentIndex, Dashboard (+14 more)

### Community 5 - "create_update_expense_provider.dart"
Cohesion: 0.07
Nodes (30): ChangeNotifier, clearAllUpcomingExpenses, completeUpcomingExpense, createUpcomingExpense, deleteUpcomingExpense, getUpcomingExpensesStream, UpcomingExpenseHelper, updateUpcomingExpense (+22 more)

### Community 6 - "GeneratedPluginRegistrant.swift"
Cohesion: 0.20
Nodes (9): cloud_firestore, firebase_core, firebase_remote_config, firebase_storage, FlutterMacOS, FlutterPluginRegistry, Foundation, RegisterGeneratedPlugins() (+1 more)

### Community 7 - "expense_entity.dart"
Cohesion: 0.07
Nodes (28): bool?, dart:convert, int?, amount, category, copyWith, ExpenseEntity, fromJson (+20 more)

### Community 8 - "settings_controller.dart"
Cohesion: 0.07
Nodes (28): AsyncNotifier, _accentColorKey, accentColorValue, billingStartDay, _billingStartDayKey, build, categoryLimits, _categoryLimitsKey (+20 more)

### Community 9 - "add_edit_upcoming_dialog.dart"
Cohesion: 0.10
Nodes (19): bool get, FormState, _amountController, build, _buildLabel, createState, dispose, existingExpense (+11 more)

### Community 10 - "firebase_constants.dart"
Cohesion: 0.15
Nodes (12): balanceCollection, balanceDocID, expenseCategoryCollection, expenseCollection, FirebaseConstants, savingsCollection, savingsDocID, savingsGoalsCollection (+4 more)

### Community 11 - "settingsControllerProvider"
Cohesion: 0.33
Nodes (7): ConsumerWidget, settingsControllerProvider, build, SettingsScreen, initState, MaterialPageRoute, remoteConfigControllerProvider

## Knowledge Gaps
- **161 isolated node(s):** `FirebaseConstants`, `balanceCollection`, `balanceDocID`, `expenseCollection`, `expenseCategoryCollection` (+156 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **1 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `UpcomingExpense` connect `expense_entity.dart` to `add_edit_upcoming_dialog.dart`?**
  _High betweenness centrality (0.024) - this node is a cross-community bridge._
- **Why does `settingsControllerProvider` connect `settingsControllerProvider` to `settings_controller.dart`, `home_screen.dart`?**
  _High betweenness centrality (0.018) - this node is a cross-community bridge._
- **What connects `FirebaseConstants`, `balanceCollection`, `balanceDocID` to the rest of the system?**
  _161 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `home_screen.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.05384615384615385 - nodes in this community are weakly interconnected._
- **Should `settings_screen.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.053156146179401995 - nodes in this community are weakly interconnected._
- **Should `remote_config_service.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.09523809523809523 - nodes in this community are weakly interconnected._
- **Should `remote_config_controller.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.08615384615384615 - nodes in this community are weakly interconnected._