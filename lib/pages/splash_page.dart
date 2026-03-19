
import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/services.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import '/providers/auth_provider.dart';
import '/providers/area_district_provider.dart';
import '/providers/app_mode_provider.dart';
import '/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'common/alerts/app_update_alert.dart';
import '/utils/snackbar_helper.dart';
import '/constants/colors.dart';
import '/utils/system_ui_style_helper.dart';

@RoutePage()
class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  // 記錄 NewVersionPlus 的檢查結果 (正式環境用)
  VersionStatus? _productionVersionStatus;
  
  @override
  void initState() {
    super.initState();
    // Start with update check
    _checkAndForceUpdate();
  }

  Future<void> _checkAndForceUpdate() async {
    // 取得當前 App 的套件資訊
    final packageInfo = await PackageInfo.fromPlatform();
    final String packageName = packageInfo.packageName;
    // 取得當前版本 (含 build number, e.g. "3.0.0+103")
    final String currentVersion =
        '${packageInfo.version}+${packageInfo.buildNumber}';

    // 判斷是否為測試環境
    bool isTestEnvironment = false;
    if (Platform.isAndroid && packageName == 'com.ECOCO.ECOCO.Test') {
      isTestEnvironment = true;
    } else if (Platform.isIOS && packageName == 'com.funleadchange.ecStore') {
      isTestEnvironment = true;
    }

    bool isUpdateRequired = false;
    String? serverVersion; // 用於 Log 顯示

    if (isTestEnvironment) {
      // Logic A: 測試環境 -> 使用 Firebase Remote Config
      try {
        final remoteConfig = FirebaseRemoteConfig.instance;
        await remoteConfig.setConfigSettings(
          RemoteConfigSettings(
            fetchTimeout: const Duration(seconds: 10),
            minimumFetchInterval: const Duration(minutes: 1),
          ),
        );

        await remoteConfig.setDefaults({
          'min_required_version': currentVersion,
        });
        await remoteConfig.fetchAndActivate();

        serverVersion = remoteConfig.getString('min_required_version');

        // 檢查是否需更新
        if (_isVersionLower(currentVersion, serverVersion)) {
          isUpdateRequired = true;
        }
      } catch (e) {
        debugPrint('測試環境版本檢查失敗 (Remote Config): $e');
      }
    } else {
      // Logic B: 正式環境 -> 使用 NewVersionPlus 檢查
      try {
        final newVersion = NewVersionPlus(
          androidId: packageName,
          iOSId: packageName,
        );

        final status = await newVersion.getVersionStatus();
        if (status != null) {
          _productionVersionStatus = status; // 儲存狀態供後續跳轉使用
          serverVersion = status.storeVersion;
          if (status.canUpdate) {
            isUpdateRequired = true;
          }
        }
      } catch (e) {
        debugPrint('正式環境版本檢查失敗 (NewVersionPlus): $e');
      }
    }

    debugPrint(
      '版本檢查結果: Env=${isTestEnvironment ? "Test" : "Prod"}, Current=$currentVersion, Server=$serverVersion, Update=$isUpdateRequired',
    );

    if (isUpdateRequired) {
      debugPrint('準備顯示強制更新視窗 (isUpdateRequired=true)');
      if (!mounted) {
        debugPrint('SplashPage unmounted, skipping alert');
        return;
      }

      debugPrint('直接呼叫 _showAppUpdateAlert');
      _showAppUpdateAlert();
    } else {
      _checkAuthStatus();
    }
  }

  /// 比較版本號 (支援 build number, e.g. "3.0.0+103")
  /// 回傳 true 若 currentVersion < minVersion
  bool _isVersionLower(String currentVersion, String minVersion) {
    try {
      // 分割 Version 與 Build Number
      final currentParts = currentVersion.split('+');
      final minParts = minVersion.split('+');

      final currentVerStr = currentParts[0];
      final minVerStr = minParts[0];

      final currentBuild = currentParts.length > 1
          ? int.tryParse(currentParts[1]) ?? 0
          : 0;
      final minBuild = minParts.length > 1 ? int.tryParse(minParts[1]) ?? 0 : 0;

      // 1. 比對主版本號 (X.Y.Z)
      List<int> current = currentVerStr.split('.').map(int.parse).toList();
      List<int> min = minVerStr.split('.').map(int.parse).toList();

      // 補齊位數
      final length = current.length > min.length ? current.length : min.length;
      while (current.length < length) {
        current.add(0);
      }
      while (min.length < length) {
        min.add(0);
      }

      for (int i = 0; i < length; i++) {
        if (current[i] < min[i]) return true; // 版本較舊
        if (current[i] > min[i]) return false; // 版本較新
      }

      // 2. 主版本號相同，比對 Build Number
      if (currentBuild < minBuild) return true;

      return false; // 版本 >= 最低需求
    } catch (e) {
      debugPrint('版本號解析錯誤: $e');
      return false;
    }
  }

  Future<void> _checkAuthStatus() async {
    try {
      // Pre-load AreaDistrict early (parallel with auth check)
      // This ensures registration flow has data ready
      _preloadAreaDistrict();

      await ref.read(authProvider.notifier).initialize();

      if (!mounted) return;

      final authData = ref.read(authProvider);
      if (authData != null) {
        // Post-auth initialization is now handled internally by authProvider.initialize()
        // or authProvider.login() so we don't need to call it manually here.

        if (mounted) {
          final mode = ref.read(appModeStateProvider);
          if (mode == AppMode.game) {
            context.router.replaceAll([const GameHomeRoute()]);
          } else {
            context.router.replaceAll([const MainRoute()]);
          }
        }
      } else {
        context.router.replaceAll([LoginRoute(isLogout: true)]);
      }
    } catch (e) {
      if (!mounted) return;
      context.router.replaceAll([LoginRoute(isLogout: true)]);
    }
  }

  /// Pre-load area/district data in background
  /// Runs in parallel with auth initialization
  void _preloadAreaDistrict() {
    Future.microtask(() async {
      try {
        await ref.read(areaDistrictProvider.notifier).loadAreaDistrict();
      } catch (e) {
        // Silent failure - data will load on-demand if this fails
        // Errors are already logged in repository
      }
    });
  }

  void _showAppUpdateAlert() {
    showDialog(
      context: context,
      barrierDismissible: false,
      useSafeArea: false, // Allow dialog to extend behind system bars
      barrierColor: Colors.transparent, // 使用 AppUpdateAlert 內部的遮罩，讓系統列顏色能精準對齊
      builder: (context) => PopScope(
        canPop: false, // 禁止返回鍵關閉
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiStyleHelper.splashStyle,
          child: SizedBox.expand(
            child: AppUpdateAlert(
              onConfirm: () {
                _navigateToAppStore();
              },
              // onCancel is null to hide the cancel button (Forced Update)
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _navigateToAppStore() async {
    // 取得當前 App 的套件資訊 (Package Name / Bundle ID)
    final packageInfo = await PackageInfo.fromPlatform();
    final String packageName = packageInfo.packageName;

    // 優先使用 NewVersionPlus 查到的連結 (Production)
    if (_productionVersionStatus != null &&
        _productionVersionStatus!.appStoreLink.isNotEmpty) {
      try {
        final newVersion = NewVersionPlus(
          androidId: packageName,
          iOSId: packageName,
        );
        await newVersion.launchAppStore(_productionVersionStatus!.appStoreLink);
        return;
      } catch (e) {
        debugPrint('NewVersionPlus launchAppStore failed: $e');
        // Fallback to manual logic below
      }
    }

    String url = '';

    if (Platform.isAndroid) {
      // Android
      if (packageName == 'com.ECOCO.ECOCO.Test') {
        // Internal Testing URL
        url = 'https://play.google.com/apps/internaltest/4701332869607427766';
      } else {
        // Production: com.ECOCO.ECOCO
        url = 'market://details?id=$packageName';
      }
    } else if (Platform.isIOS) {
      // iOS
      if (packageName == 'com.funleadchange.ecStore') {
        // Dev / TestFlight: Open TestFlight App directly
        url = 'itms-beta://';
      } else {
        // Production
        url = 'https://apps.apple.com/tw/app/ecoco循環經濟/id1433866801';
      }
    }

    if (url.isNotEmpty) {
      final uri = Uri.parse(url);

      // Try to launch primary URL
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        // Fallback or specific error handling
        if (Platform.isAndroid && packageName != 'com.ECOCO.ECOCO.Test') {
          // Fallback to web Play Store if market:// fails (Production only)
          final webUrl = Uri.parse(
            'https://play.google.com/store/apps/details?id=$packageName',
          );
          if (await canLaunchUrl(webUrl)) {
            await launchUrl(webUrl, mode: LaunchMode.externalApplication);
            return;
          }
        }

        if (mounted) {
          SnackBarHelper.show(context, '無法開啟商店頁面，請確認已安裝商店應用程式');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiStyleHelper.splashStyle,
        child: Scaffold(
          body: Container(
            width: MediaQuery
                .of(context)
                .size
                .width,
            height: MediaQuery
                .of(context)
                .size
                .height,
            decoration: const BoxDecoration(
              color: AppColors.primaryHighlightColor,
            ),
            child: Center(
              child: Image.asset("assets/images/wh_brand.png", width: 178),
            ),
          ),
        ),
    );
  }
}
