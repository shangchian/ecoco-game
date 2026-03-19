import 'dart:io';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'version_provider.g.dart';

typedef VersionData = ({String version, String systemVersion, String model});

@riverpod
class VersionNotifier extends _$VersionNotifier {
  @override
  VersionData build() => (version: '', systemVersion: '', model: '');

  Future<void> loadInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      state = (
        version: 'Version ${packageInfo.version}+${packageInfo.buildNumber}',
        systemVersion: 'Android ${androidInfo.version.release}',
        model: androidInfo.model
      );
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      state = (
        version: 'Version ${packageInfo.version}+${packageInfo.buildNumber}',
        systemVersion: 'iOS ${iosInfo.systemVersion}',
        model: iosInfo.modelName
      );
    }
    return;
  }
}
