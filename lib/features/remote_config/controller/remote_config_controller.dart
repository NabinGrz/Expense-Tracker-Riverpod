import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../service/remote_config_service.dart';
import 'remote_config_state.dart';

final remoteConfigServiceProvider = Provider<RemoteConfigService>((ref) {
  return RemoteConfigService();
});

final remoteConfigControllerProvider =
    AsyncNotifierProvider<RemoteConfigController, RemoteConfigState>(
  RemoteConfigController.new,
);

class RemoteConfigController extends AsyncNotifier<RemoteConfigState> {
  late final RemoteConfigService _service;
  StreamSubscription? _realtimeSubscription;

  @override
  Future<RemoteConfigState> build() async {
    _service = ref.read(remoteConfigServiceProvider);

    await _service.initialize();
    _listenToRealtimeUpdates();

    ref.onDispose(() {
      _realtimeSubscription?.cancel();
    });

    return _readCurrentState();
  }

  void _listenToRealtimeUpdates() {
    _realtimeSubscription?.cancel();
    _realtimeSubscription = _service.onConfigUpdated.listen(
      (update) async {
        debugPrint('RemoteConfig Realtime update received: ${update.updatedKeys}');
        await _service.activate();
        state = AsyncValue.data(_readCurrentState());
      },
      onError: (error) {
        debugPrint('RemoteConfig Realtime update error: $error');
      },
    );
  }

  RemoteConfigState _readCurrentState() {
    return RemoteConfigState(
      welcomeMessage: _service.getString(RemoteConfigKeys.welcomeMessage),
      isMaintenanceMode: _service.getBool(RemoteConfigKeys.isMaintenanceMode),
      announcementMessage:
          _service.getString(RemoteConfigKeys.announcementMessage),
      showAnnouncement: _service.getBool(RemoteConfigKeys.showAnnouncement),
      minAppVersion: _service.getString(RemoteConfigKeys.minAppVersion),
      lastUpdated: DateTime.now(),
    );
  }

  /// Manually force a fetch and activate
  Future<void> refreshConfig() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _service.fetchAndActivate();
      return _readCurrentState();
    });
  }
}
