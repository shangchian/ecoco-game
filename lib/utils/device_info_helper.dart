import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_app_installations/firebase_app_installations.dart';

class DeviceInfoHelper {
  /// Get all device information required for login API
  /// Returns a map with: deviceId, platform, deviceModel, osVersion
  static Future<Map<String, String>> getDeviceInfo() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    final String deviceId = await FirebaseInstallations.instance.getId();

    String platform;
    String deviceModel;
    String osVersion;

    if (Platform.isAndroid) {
      final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      platform = 'ANDROID';
      deviceModel = androidInfo.model;
      osVersion = androidInfo.version.release;
    } else if (Platform.isIOS) {
      final IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      platform = 'IOS';
      deviceModel = iosInfo.modelName;
      osVersion = iosInfo.systemVersion;
    } else {
      // Fallback for unsupported platforms (e.g., web, desktop)
      platform = 'WEB';
      deviceModel = 'Unknown';
      osVersion = 'Unknown';
    }

    return {
      'deviceId': deviceId,
      'platform': platform,
      'deviceModel': deviceModel,
      'osVersion': osVersion,
    };
  }
}
