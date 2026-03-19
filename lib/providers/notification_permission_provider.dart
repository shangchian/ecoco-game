import 'dart:developer';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:permission_handler/permission_handler.dart';

part 'notification_permission_provider.g.dart';

enum NotificationPermissionStatus {
  granted,
  provisional,
  denied,
  permanentlyDenied,
  notDetermined,
}

class NotificationPermissionState {
  final NotificationPermissionStatus permissionStatus;
  final bool isChecking;

  const NotificationPermissionState({
    required this.permissionStatus,
    this.isChecking = false,
  });

  bool get hasPermission =>
      permissionStatus == NotificationPermissionStatus.granted ||
      permissionStatus == NotificationPermissionStatus.provisional;

  bool get shouldHideBanner => isChecking || hasPermission;
}

@Riverpod(keepAlive: true)
class NotificationPermission extends _$NotificationPermission {
  @override
  NotificationPermissionState build() {
    _checkPermission();
    return const NotificationPermissionState(
      permissionStatus: NotificationPermissionStatus.notDetermined,
      isChecking: true,
    );
  }

  Future<void> _checkPermission() async {
    try {
      final status = await Permission.notification.status;
      if (!ref.mounted) return;
      state = NotificationPermissionState(
        permissionStatus: _mapPermissionStatus(status),
        isChecking: false,
      );
    } catch (e) {
      log('Error checking notification permission: $e');
      if (!ref.mounted) return;
      state = const NotificationPermissionState(
        permissionStatus: NotificationPermissionStatus.notDetermined,
        isChecking: false,
      );
    }
  }

  Future<void> refreshPermissionStatus() async {
    if (!ref.mounted) return;
    state = NotificationPermissionState(
      permissionStatus: state.permissionStatus,
      isChecking: true,
    );

    try {
      final status = await Permission.notification.status;
      if (!ref.mounted) return;
      state = NotificationPermissionState(
        permissionStatus: _mapPermissionStatus(status),
        isChecking: false,
      );
    } catch (e) {
      log('Error refreshing notification permission: $e');
      if (!ref.mounted) return;
      state = NotificationPermissionState(
        permissionStatus: state.permissionStatus,
        isChecking: false,
      );
    }
  }

  NotificationPermissionStatus _mapPermissionStatus(PermissionStatus status) {
    switch (status) {
      case PermissionStatus.granted:
        return NotificationPermissionStatus.granted;
      case PermissionStatus.provisional:
        return NotificationPermissionStatus.provisional;
      case PermissionStatus.denied:
        return NotificationPermissionStatus.denied;
      case PermissionStatus.permanentlyDenied:
        return NotificationPermissionStatus.permanentlyDenied;
      case PermissionStatus.restricted:
      case PermissionStatus.limited:
        return NotificationPermissionStatus.denied;
    }
  }
}
