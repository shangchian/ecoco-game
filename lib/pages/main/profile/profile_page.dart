import 'package:auto_route/auto_route.dart';
import 'package:ecoco_app/ecoco_icons.dart';
import '/pages/main/profile/widgets/profile_card.dart';
import '/providers/auth_provider.dart';

//import '/providers/bio_provider.dart';
import '/providers/wallet_provider.dart';
import '/providers/recycling_stats_provider.dart';
import '/providers/voucher_seen_provider.dart';
import '/providers/notifications_data_provider.dart';
import '/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import '/constants/colors.dart';
import '/widgets/profile_section.dart';
import '/pages/common/alerts/logout_confirm_alert.dart';
import '/utils/snackbar_helper.dart';
import '/widgets/notification_icon.dart';
import '/utils/router_analytics_extension.dart';

@RoutePage()
class ProfilePage extends ConsumerStatefulWidget {
  final Function(bool) onLoadingChanged;

  const ProfilePage({super.key, required this.onLoadingChanged});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  Future<void> _launchURL({String? appUrl, required String webUrl}) async {
    if (appUrl != null) {
      final uri = Uri.parse(appUrl);

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        return;
      }
    }

    final webUri = Uri.parse(webUrl);

    if (await canLaunchUrl(webUri)) {
      await launchUrl(webUri, mode: LaunchMode.externalApplication);
    } else {
      // Show error to user if URL cannot be launched
      if (mounted) {
        SnackBarHelper.show(context, '無法開啟網頁，請確認已安裝瀏覽器');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _refreshData();
    });
  }

  Future<void> _refreshData() async {
    await Future.wait<void>([
      ref.read(recyclingStatsProvider.notifier).fetchRecyclingStats(),
      ref.read(walletProvider.notifier).fetchWalletData(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final appLocale = AppLocalizations.of(context);
    final authState = ref.watch(authProvider);
    //final bioState = ref.watch(bioProvider);
    final walletData = ref.watch(walletProvider);
    final unreadCountsAsync = ref.watch(unreadNotificationCountsProvider);

    if (authState == null) {
      final navigator = AutoRouter.of(context);
      Future.microtask(() => navigator.replace(LoginRoute(isLogout: true)));
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: AppColors.primaryHighlightColor,
          ),
        ),
      );
    }

    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.grey[50],
          appBar: AppBar(
            backgroundColor: AppColors.secondaryHighlightColor,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            toolbarHeight: 64,
            centerTitle: false,
            title: Image.asset(
              'assets/images/ecoco_logo_pure.png',
              height: 25,
              errorBuilder: (context, error, stackTrace) {
                return const Text(
                  'ECOCO',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                );
              },
            ),
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 8),
                child: IconButton(
                  icon: NotificationIcon(
                    icon: ECOCOIcons.bell,
                    size: 28,
                    backgroundColor: AppColors.secondaryHighlightColor,
                    hasNotification: unreadCountsAsync.maybeWhen(
                      data: (counts) => counts.hasUnread,
                      orElse: () => false,
                    ),
                  ),
                  onPressed: () {
                    context.router.pushThrottledWithTracking(NotificationsRoute());
                  },
                ),
              ),
            ],
          ),
          body: Container(
            color: AppColors.secondaryHighlightColor,
            child: RefreshIndicator(
              // displacement: 60.0,  // 停下來轉動的位置 (預設 40)
              // edgeOffset: 20.0,    // 從哪裡開始出現 (預設 0)
              color: AppColors.primaryHighlightColor,
              onRefresh: _refreshData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Container(
                  color: AppColors.greyBackground,
                  child: Column(
                    children: [
                      // User Info Card with dual-color background
                      Stack(
                        children: [
                          // Dual-color background
                          Column(
                            children: [
                              // Yellow background (top half)
                              Container(
                                height: 125,
                                decoration: const BoxDecoration(
                                  color: AppColors.secondaryHighlightColor,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(20),
                                    bottomRight: Radius.circular(20),
                                  ),
                                ),
                              ),
                              // Grey background (bottom half)
                              Container(
                                height: 35,
                                color: AppColors.greyBackground,
                              ),
                            ],
                          ),
                          // Profile Card on top
                          ProfileCard(
                            points: walletData?.ecocoWallet.currentBalance ?? 0,
                            co2Reduction: 0,
                          ),
                        ],
                      ),

                      Transform.translate(
                        offset: const Offset(0, -20),
                        child: Column(
                          children: [
                            // Section 1: 個人專屬
                            ProfileSection(
                              title: '個人專屬',
                              icon: 'assets/icon/my_person_icon.png',
                              children: [
                                ListTile(
                                  dense: true,
                                  minVerticalPadding: 0,
                                  contentPadding: const EdgeInsets.fromLTRB(
                                    16,
                                    -6,
                                    16,
                                    -6,
                                  ),
                                  title: const Text(
                                    '編輯個人資料',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  trailing: Icon(
                                    Icons.chevron_right,
                                    color: AppColors.indicatorColor,
                                  ),
                                  onTap: () {
                                    context.router.pushThrottledWithTracking(
                                      const EditProfileRoute(),
                                    );
                                  },
                                ),
                                ListTile(
                                  dense: true,
                                  minVerticalPadding: 0,
                                  contentPadding: const EdgeInsets.fromLTRB(
                                    16,
                                    -6,
                                    16,
                                    -6,
                                  ),
                                  title: const Text(
                                    '帳號與安全',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  trailing: Icon(
                                    Icons.chevron_right,
                                    color: AppColors.indicatorColor,
                                  ),
                                  onTap: () {
                                    context.router.pushThrottledWithTracking(
                                      const AccountSecurityRoute(),
                                    );
                                  },
                                ),
                                ListTile(
                                  dense: true,
                                  minVerticalPadding: 0,
                                  contentPadding: const EdgeInsets.fromLTRB(
                                    16,
                                    -6,
                                    16,
                                    -6,
                                  ),
                                  title: Text(
                                    "常用站點",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  trailing: Icon(
                                    Icons.chevron_right,
                                    color: AppColors.indicatorColor,
                                  ),
                                  onTap: () {
                                    context.router.pushThrottledWithTracking(
                                      const FavoriteSitesRoute(),
                                    );
                                  },
                                ),
                                ListTile(
                                  dense: true,
                                  minVerticalPadding: 0,
                                  contentPadding: const EdgeInsets.fromLTRB(
                                    16,
                                    -6,
                                    16,
                                    -6,
                                  ),
                                  title: Row(
                                    children: [
                                      const Text(
                                        '我的票券',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      if (ref.watch(
                                            unseenActiveVouchersCountProvider,
                                          ) >
                                          0) ...[
                                        const SizedBox(width: 6),
                                        Container(
                                          width: 5,
                                          height: 5,
                                          decoration: const BoxDecoration(
                                            color:
                                                AppColors.formFieldErrorBorder,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  trailing: Icon(
                                    Icons.chevron_right,
                                    color: AppColors.indicatorColor,
                                  ),
                                  onTap: () {
                                    context.router.pushThrottledWithTracking(
                                      VoucherWalletRoute(),
                                    );
                                  },
                                ),
                                ListTile(
                                  dense: true,
                                  minVerticalPadding: 0,
                                  contentPadding: const EdgeInsets.fromLTRB(
                                    16,
                                    -6,
                                    16,
                                    -6,
                                  ),
                                  title: Text(
                                    "序號兌換",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  trailing: Icon(
                                    Icons.chevron_right,
                                    color: AppColors.indicatorColor,
                                  ),
                                  onTap: () {
                                    SnackBarHelper.show(
                                      context, '功能開發中，敬請期待！',
                                      margin: const EdgeInsets.only(
                                          bottom: 40, left: 16, right: 16),
                                    );                                  },
                                ),
                              ],
                            ),

                            // Section 2: ECOCO APP
                            ProfileSection(
                              title: 'ECOCO APP',
                              //icon: Icons.settings,
                              icon: 'assets/icon/my_cog_icon.png',
                              children: [
                                ListTile(
                                  dense: true,
                                  minVerticalPadding: 0,
                                  contentPadding: const EdgeInsets.fromLTRB(
                                    16,
                                    -6,
                                    16,
                                    -6,
                                  ),
                                  title: Text(
                                    appLocale?.notificationSetting ?? "通知設定",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  trailing: Icon(
                                    Icons.chevron_right,
                                    color: AppColors.indicatorColor,
                                  ),
                                  onTap: () {
                                    context.router.pushThrottledWithTracking(
                                      const NotificationSettingsRoute(),
                                    );
                                  },
                                ),
                                ListTile(
                                  dense: true,
                                  minVerticalPadding: 0,
                                  contentPadding: const EdgeInsets.fromLTRB(
                                    16,
                                    -6,
                                    16,
                                    -6,
                                  ),
                                  title: Text(
                                    appLocale?.priviledgeSetting ?? "權限管理",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  trailing: Icon(
                                    Icons.chevron_right,
                                    color: AppColors.indicatorColor,
                                  ),
                                  onTap: () {
                                    context.router.pushThrottledWithTracking(
                                      const PermissionManagementRoute(),
                                    );
                                  },
                                ),
                                ListTile(
                                  dense: true,
                                  minVerticalPadding: 0,
                                  contentPadding: const EdgeInsets.fromLTRB(
                                    16,
                                    -6,
                                    16,
                                    -6,
                                  ),
                                  title: Text(
                                    appLocale?.systemVersion ?? "版本資訊",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  trailing: Icon(
                                    Icons.chevron_right,
                                    color: AppColors.indicatorColor,
                                  ),
                                  onTap: () {
                                    context.router.pushThrottledWithTracking(
                                      const VersionRoute(),
                                    );
                                  },
                                ),
                              ],
                            ),

                            // Section 3: 服務與支援
                            ProfileSection(
                              title: '服務與支援',
                              //icon: Icons.help_outline,
                              icon: 'assets/icon/my_support_icon.png',
                              children: [
                                ListTile(
                                  dense: true,
                                  minVerticalPadding: 0,
                                  contentPadding: const EdgeInsets.fromLTRB(
                                    16,
                                    -6,
                                    16,
                                    -6,
                                  ),
                                  title: Text(
                                    appLocale?.manual ?? "使用教學",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  trailing: Icon(
                                    Icons.chevron_right,
                                    color: AppColors.indicatorColor,
                                  ),
                                  onTap: () {
                                    _launchURL(
                                      webUrl:
                                          'https://www.ecocogroup.com/how-to-play/',
                                    );
                                  },
                                ),
                                ListTile(
                                  dense: true,
                                  minVerticalPadding: 0,
                                  contentPadding: const EdgeInsets.fromLTRB(
                                    16,
                                    -6,
                                    16,
                                    -6,
                                  ),
                                  title: Text(
                                    appLocale?.qaTitle ?? "常見問題",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  trailing: Icon(
                                    Icons.chevron_right,
                                    color: AppColors.indicatorColor,
                                  ),
                                  onTap: () {
                                    _launchURL(
                                      webUrl: 'https://www.ecocogroup.com/qa/',
                                    );
                                  },
                                ),
                                ListTile(
                                  dense: true,
                                  minVerticalPadding: 0,
                                  contentPadding: const EdgeInsets.fromLTRB(
                                    16,
                                    -6,
                                    16,
                                    -6,
                                  ),
                                  title: Text(
                                    appLocale?.contactUs ?? "聯絡我們",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  trailing: Icon(
                                    Icons.chevron_right,
                                    color: AppColors.indicatorColor,
                                  ),
                                  onTap: () {
                                    _launchURL(
                                      webUrl:
                                          'https://ecocogroup.zendesk.com/hc/zh-tw/requests/new?ticket_form_id=41244248648473',
                                    );
                                  },
                                ),
                                ListTile(
                                  dense: true,
                                  minVerticalPadding: 0,
                                  contentPadding: const EdgeInsets.fromLTRB(
                                    16,
                                    -6,
                                    16,
                                    -6,
                                  ),
                                  title: Text(
                                    appLocale?.knownUs ?? "認識ECOCO",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  trailing: Icon(
                                    Icons.chevron_right,
                                    color: AppColors.indicatorColor,
                                  ),
                                  onTap: () {
                                    _launchURL(
                                      webUrl: 'https://www.ecocogroup.com/',
                                    );
                                  },
                                ),
                                // ListTile(
                                //   dense: true,
                                //   minVerticalPadding: 0,
                                //   contentPadding: const EdgeInsets.fromLTRB(
                                //     16,
                                //     -6,
                                //     16,
                                //     -6,
                                //   ),
                                //   title: const Text(
                                //     '寫評價',
                                //     style: TextStyle(fontSize: 16),
                                //   ),
                                //   trailing: Icon(
                                //     Icons.chevron_right,
                                //     color: AppColors.indicatorColor,
                                //   ),
                                //   onTap: () {
                                //     // Add app review functionality
                                //   },
                                // ),
                                ListTile(
                                  dense: true,
                                  minVerticalPadding: 0,
                                  contentPadding: const EdgeInsets.fromLTRB(
                                    16,
                                    -6,
                                    16,
                                    -6,
                                  ),
                                  title: const Text(
                                    '服務條款與隱私權政策',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  trailing: Icon(
                                    Icons.chevron_right,
                                    color: AppColors.indicatorColor,
                                  ),
                                  onTap: () {
                                    context.router.pushThrottledWithTracking(
                                      MarkdownViewerRoute(
                                        title: '服務條款與隱私權政策',
                                        localAssetPath: 'assets/data/tos.md',
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),

                      // 社群媒體按鈕
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // Facebook
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  _launchURL(
                                    appUrl: Platform.isIOS
                                        ? 'fb://profile/100064695848592'
                                        : 'fb://page/100064695848592',
                                    webUrl:
                                        'https://www.facebook.com/100064695848592/',
                                  );
                                },
                                child: Column(
                                  children: [
                                    Icon(
                                      FontAwesomeIcons.facebook,
                                      color: Colors.grey[700],
                                      size: 45,
                                    ),
                                    const SizedBox(height: 8),
                                    SizedBox(
                                      width: double.infinity,
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          'FACEBOOK',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Instagram
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  _launchURL(
                                    appUrl:
                                        'instagram://user?username=ecoco_official',
                                    webUrl:
                                        'https://www.instagram.com/ecoco_official/',
                                  );
                                },
                                child: Column(
                                  children: [
                                    Icon(
                                      FontAwesomeIcons.instagram,
                                      color: Colors.grey[700],
                                      size: 45,
                                    ),
                                    const SizedBox(height: 8),
                                    SizedBox(
                                      width: double.infinity,
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          'INSTAGRAM',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            // LINE
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  _launchURL(
                                    appUrl: Platform.isIOS
                                        ? 'https://lin.ee/8wSzFyv'
                                        : 'https://lin.ee/8wSzFyv',
                                    webUrl: 'https://line.me/R/ti/p/@xxr8148i',
                                  );
                                },
                                child: Column(
                                  children: [
                                    Icon(
                                      FontAwesomeIcons.line,
                                      color: Colors.grey[700],
                                      size: 45,
                                    ),
                                    const SizedBox(height: 8),
                                    SizedBox(
                                      width: double.infinity,
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          'LINE@',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // 登出按鈕
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: ElevatedButton(
                          onPressed: () {
                            _showLogoutConfirmation(context, ref);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.buttomBackground,
                            minimumSize: const Size(double.infinity, 40),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: Text(
                            appLocale?.logout ?? "登出",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 150),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showLogoutConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return LogoutConfirmAlert(
          onLogout: () async {
            await _handleLogout(ref);
          },
          onCancel: () {
            // Dialog is already dismissed by Navigator.pop in the alert
          },
        );
      },
    );
  }

  Future<void> _handleLogout(WidgetRef ref) async {
    widget.onLoadingChanged(true);
    try {
      await ref.read(authProvider.notifier).logout();
    } catch (e) {
      // Handle error
    } finally {
      if (mounted) {
        widget.onLoadingChanged(false);
      }
    }
  }
}
