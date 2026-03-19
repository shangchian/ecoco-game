import 'dart:developer';

import 'package:app_settings/app_settings.dart';
import 'package:auto_route/auto_route.dart';
import '/models/notification_preferences.dart';
import '/repositories/notification_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/l10n/app_localizations.dart';
import '/providers/notification_repository_provider.dart';
import '/pages/common/loading_overlay.dart';
import '/constants/colors.dart';
import '/flavors.dart';
import '/services/firebase_messaging_service.dart';
import '/utils/snackbar_helper.dart';

@RoutePage()
class NotificationSettingsPage extends ConsumerStatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  ConsumerState<NotificationSettingsPage> createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState
    extends ConsumerState<NotificationSettingsPage>
    with WidgetsBindingObserver {
  bool _isLoading = false;
  bool _isNotificationsEnabled = false;
  late NotificationPreferences _preferences;

  // Save repository reference to use in dispose()
  late final NotificationRepository _notificationRepository;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _preferences = NotificationPreferences();

    // Capture provider reference that is safe to use in dispose()
    _notificationRepository = ref.read(notificationRepositoryProvider);

    _loadNotificationSettings();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    // Auto-save all changes silently using saved reference
    // Fire and forget - errors will be retried on next app resume
    _notificationRepository.saveNotificationPreferences(
      _preferences,
      _isNotificationsEnabled,
    );

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    log('didChangeAppLifecycleState: $state');
    switch (state) {
      case AppLifecycleState.resumed:
        _loadNotificationSettings();
        break;
      default:
        break;
    }
  }

  // Load notification settings - local storage first, server fallback for first-time users
  Future<void> _loadNotificationSettings() async {
    setState(() => _isLoading = true);

    try {
      // Retry any pending changes first (background sync, doesn't reload settings)
      await ref.read(notificationRepositoryProvider).retryPendingSync();

      // Load from local storage first (or server if first-time user)
      _preferences = await ref
          .read(notificationRepositoryProvider)
          .getLocalNotificationPreferencesWithFallback();

      // Check OS-level permissions to determine global notification status
      _isNotificationsEnabled = await ref
          .read(notificationRepositoryProvider)
          .getNotificationEnabled();

      setState(() {
        // Preferences and global status are already set above
      });
    } catch (e) {
      _showError(e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }


  Future<void> _handleNotificationToggle(bool newState) async {
    setState(() => _isLoading = true);
    try {
      final notificationRepo = ref.read(notificationRepositoryProvider);
      if (newState) {
        // 開啟權限時，因為是再要一次權限，但是OS不一定理我們，所以轉到 AppSettings 設定頁面讓使用者設定
        _isNotificationsEnabled = await notificationRepo
            .setupNotifications(forceAsk: true);
      } else {
        // Mock mode: directly disable without opening system settings
        if (F.useMockService) {
          await notificationRepo.unregisterNotifications();
          _isNotificationsEnabled = false;
        } else {
          // 關閉權限要求使用者到 AppSettings 設定頁面設定
          // 使用者如果在 Android 內 revoke 推播權限，app 會被強制關閉
          // https://developer.android.com/training/permissions/requesting#app_process_terminates_when_permission_revoked
          await AppSettings.openAppSettings(
              type: AppSettingsType.notification, asAnotherTask: true);
        }

        // 當關閉 APP 通知時，自動將所有子類別通知設定為 false
        setState(() {
          for (var key in _preferences.notifications.keys) {
            _preferences.notifications[key] = false;
          }
        });
      }
    } catch (e) {
      _showError(e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    if (mounted) {
      SnackBarHelper.show(context, message);
    }
  }

  Widget _buildSwitchTile({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Column(
      children: [
        ListTile(
          title: Text(
            title,
            style: const TextStyle(
              color: AppColors.secondaryValueColor,
            ),
          ),
          trailing: Switch.adaptive(
            value: value,
            onChanged: onChanged,
          ),
        ),
        Divider(
          height: 1,
          thickness: 1,
          color: AppColors.dividerColor,
          indent: 16,
          endIndent: 16,
        ),
      ],
    );
  }

  Widget _buildNavigationTile({
    required String title,
    required bool isEnabled,
    required VoidCallback onTap,
  }) {
    final appLocale = AppLocalizations.of(context);

    final statusText = isEnabled
        ? (appLocale?.notificationStatusEnabled ?? "已開啟")
        : (appLocale?.notificationStatusDisabled ?? "已關閉");

    return Column(
      children: [
        Padding(padding:EdgeInsetsGeometry.fromLTRB(5, 0, 5, 0), child:
        ListTile(
          title: Text(title),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                statusText,
                style: const TextStyle(
                  color: AppColors.indicatorColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.chevron_right,
                color: AppColors.indicatorColor,
                size: 24,
              ),
            ],
          ),
          onTap: onTap,
        )),
        Divider(
          height: 1,
          thickness: 1,
          color: AppColors.dividerColor,
          indent: 16,
          endIndent: 16,
        ),
      ],
    );
  }

  Widget _buildNotificationSection() {
    final appLocale = AppLocalizations.of(context);
    if (!_isNotificationsEnabled) {
      return Container();
    }

    return _buildSection(appLocale?.notificationTitle ?? "", [
      _buildPublicNotificationSwitchTile(
          appLocale?.notificationTitleAnouncement ?? "",
          NotificationType.announcement),
      _buildPublicNotificationSwitchTile(
          appLocale?.notificationTitleActivity ?? "",
          NotificationType.activityInfo),
      _buildPublicNotificationSwitchTile(
          appLocale?.notificationBiz ?? "", NotificationType.merchantOffers),
      _buildPrivateNotificationSwitchTile(
          appLocale?.notificationPointsExpiry ?? "",
          NotificationType.pointsExpiry),
      _buildPrivateNotificationSwitchTile(
          appLocale?.notificationTicketExpiry ?? "",
          NotificationType.voucherExpiry),
    ]);
  }

  Widget _buildNotificationSwitchSection() {
    final appLocale = AppLocalizations.of(context);
    final mainNavigationTile = _buildNavigationTile(
      title: appLocale?.notificationActivateTitle ?? "開啟APP通知",
      isEnabled: _isNotificationsEnabled,
      onTap: () => _handleNotificationToggle(!_isNotificationsEnabled),
    );

    return _buildSection(
        appLocale?.notificationSettingTitle ?? "APP推播設定", [mainNavigationTile]);
  }

  @override
  Widget build(BuildContext context) {
    //final appLocale = AppLocalizations.of(context);

    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text(
              '通知設定',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: Color(0xFF333333),
              ),
            ),
            backgroundColor: AppColors.secondaryHighlightColor,
            surfaceTintColor: Colors.transparent,
            centerTitle: true,
            elevation: 0,
            toolbarHeight: 56,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => context.router.pop(),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildNotificationSwitchSection(),
                _buildNotificationSection(),
              ],
            ),
          ),
        ),
        if (_isLoading) const LoadingOverlay(),
      ],
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...children,
      ],
    );
  }

  Widget _buildPublicNotificationSwitchTile(
      String title, NotificationType key) {
    return _buildSwitchTile(
      title: title,
      value: _preferences.notifications[key] ?? false,
      onChanged: (bool value) {
        setState(() {
          _preferences.notifications[key] = value;
        });

        // Immediately update FCM topic subscription
        FirebaseMessagingService.updateTopicSubscriptions(_preferences.notifications);
      },
    );
  }

  Widget _buildPrivateNotificationSwitchTile(
      String title, NotificationType key) {
    return _buildSwitchTile(
      title: title,
      value: _preferences.notifications[key] ?? false,
      onChanged: (bool value) {
        setState(() {
          _preferences.notifications[key] = value;
        });

        // Immediately update FCM topic subscription
        FirebaseMessagingService.updateTopicSubscriptions(_preferences.notifications);
      },
    );
  }
}
