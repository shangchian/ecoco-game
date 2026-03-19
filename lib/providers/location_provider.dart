import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../router/app_router.dart';
import '../pages/common/alerts/location_permission_alert.dart';

part 'location_provider.g.dart';

// 定義位置資料的型別
typedef LocationData = ({double lat, double lng});

// 定義位置權限狀態
enum LocationPermissionStatus {
  granted,
  grantedWhenInUse,  // iOS "While Using App"
  denied,
  deniedForever,
  notDetermined,
}

// 定義位置狀態 (包含位置資料和權限狀態)
class LocationState {
  final LocationData location;
  final LocationPermissionStatus permissionStatus;
  final bool isChecking;

  const LocationState({
    required this.location,
    required this.permissionStatus,
    this.isChecking = false,
  });

  bool get hasPermission =>
      permissionStatus == LocationPermissionStatus.granted ||
      permissionStatus == LocationPermissionStatus.grantedWhenInUse;

  bool get shouldHideBanner =>
      hasPermission ||
      permissionStatus == LocationPermissionStatus.notDetermined;
}

@Riverpod(keepAlive: true)
class UserLocationNotifier extends _$UserLocationNotifier {
  @override
  LocationState build() => const LocationState(
        location: (lat: 23.1417, lng: 120.2513),
        permissionStatus: LocationPermissionStatus.notDetermined,
        isChecking: false,
      );

  Future<void> getUserLocation({bool requestPermission = true}) async {
    // Prevent duplicate execution while already checking
    if (state.isChecking) return;

    // Set checking state before starting permission check
    if (!ref.mounted) return;
    state = LocationState(
      location: state.location,
      permissionStatus: state.permissionStatus,
      isChecking: true,
    );

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      if (requestPermission) {
        // Check if we have already requested permission before
        final prefs = await SharedPreferences.getInstance();
        final hasRequested = prefs.getBool('has_requested_location_permission') ?? false;

        if (!hasRequested) {
          final context = ref.read(appRouterProvider).navigatorKey.currentContext;
          if (context != null && context.mounted) {
            final agreed = await showDialog<bool>(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return const LocationPermissionAlert();
              },
            );

            if (agreed != true) {
              if (!ref.mounted) return;
              state = const LocationState(
                location: (lat: 23.1417, lng: 120.2513),
                permissionStatus: LocationPermissionStatus.denied,
                isChecking: false,
              );
              log('Location permissions are denied by user in pre-prompt');
              return;
            }
          }

          permission = await Geolocator.requestPermission();
          await prefs.setBool('has_requested_location_permission', true);
        }
      }
      if (permission == LocationPermission.denied) {
        if (!ref.mounted) return;
        state = LocationState(
          location: (lat: 23.1417, lng: 120.2513),
          permissionStatus: _mapGeolocatorPermission(permission),
          isChecking: false,
        );
        log('Location permissions are denied');
        return;
      }
    }

    try {
      final currentLocation = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.best,
          distanceFilter: 0,
        ),
      );
      if (!ref.mounted) return;
      state = LocationState(
        location: (
          lat: currentLocation.latitude,
          lng: currentLocation.longitude,
        ),
        permissionStatus: _mapGeolocatorPermission(permission),
        isChecking: false,
      );
    } catch (e) {
      log('getUserLocation error: $e');
      if (!ref.mounted) return;
      state = LocationState(
        location: state.location,
        permissionStatus: _mapGeolocatorPermission(permission),
        isChecking: false,
      );
    }
  }

  Future<void> refreshPermissionStatus() async {
    // Prevent duplicate execution while already checking
    if (state.isChecking) return;

    // Set checking state before starting permission check
    if (!ref.mounted) return;
    state = LocationState(
      location: state.location,
      permissionStatus: state.permissionStatus,
      isChecking: true,
    );

    final permission = await Geolocator.checkPermission();
    if (!ref.mounted) return;
    final newStatus = _mapGeolocatorPermission(permission);

    // If permission changed to granted, get location
    if (newStatus == LocationPermissionStatus.granted ||
        newStatus == LocationPermissionStatus.grantedWhenInUse) {
      await getUserLocation();
    } else {
      // Update permission status only
      state = LocationState(
        location: state.location,
        permissionStatus: newStatus,
        isChecking: false,
      );
    }
  }

  double calculateDistance(double startLat, double startLng, double endLat, double endLng) {
    return Geolocator.distanceBetween(startLat, startLng, endLat, endLng);
  }

  LocationPermissionStatus _mapGeolocatorPermission(
      LocationPermission permission) {
    switch (permission) {
      case LocationPermission.always:
        return LocationPermissionStatus.granted;
      case LocationPermission.whileInUse:
        return LocationPermissionStatus.grantedWhenInUse;
      case LocationPermission.denied:
        return LocationPermissionStatus.denied;
      case LocationPermission.deniedForever:
        return LocationPermissionStatus.deniedForever;
      case LocationPermission.unableToDetermine:
        return LocationPermissionStatus.notDetermined;
    }
  }
}
