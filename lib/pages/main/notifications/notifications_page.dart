import 'package:app_settings/app_settings.dart';
import 'package:auto_route/auto_route.dart';
import 'package:ecoco_app/ecoco_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../utils/error_messages.dart';
import '/constants/colors.dart';
import '/models/notification_item_model.dart';
import '/models/notifications_response_model.dart';
import '/providers/notification_permission_provider.dart';
import '/providers/notifications_data_provider.dart';
import '/utils/snackbar_helper.dart';
import '/router/app_router.dart';
import '/router/deep_link_router.dart';
import '/services/deep_link/link_parser.dart';
import 'widgets/empty_notifications_view.dart';
import 'widgets/notification_permission_banner.dart';
import 'widgets/notification_list_item.dart';
import '/pages/common/alerts/mark_all_read_alert.dart';
import '/utils/router_analytics_extension.dart';

@RoutePage()
class NotificationsPage extends ConsumerStatefulWidget {
  final String? tab;

  const NotificationsPage({
    super.key,
    @QueryParam('tab') this.tab,
  });

  @override
  ConsumerState<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends ConsumerState<NotificationsPage>
    with WidgetsBindingObserver {
  bool _isNotificationBannerDismissed = false;
  int _selectedTabIndex = 0;

  // Tab indices
  static const int _announcementTab = 0;
  static const int _campaignTab = 1;
  static const int _personalTab = 2;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Set initial tab index based on route parameter
    if (widget.tab != null) {
      if (widget.tab == 'campaign') {
        _selectedTabIndex = _campaignTab;
      } else if (widget.tab == 'personal') {
        _selectedTabIndex = _personalTab;
      } else {
        _selectedTabIndex = _announcementTab;
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.read(notificationPermissionProvider.notifier).refreshPermissionStatus();
    }
  }

  Future<void> _onRefresh() async {
    if (_selectedTabIndex == _announcementTab) {
      await ref.read(announcementNotificationsProvider.notifier).refresh();
    } else if (_selectedTabIndex == _campaignTab) {
      await ref.read(campaignNotificationsProvider.notifier).refresh();
    }
    // Note: Personal notifications don't support pull-to-refresh
    // since we get them purely push-based/local DB.
  }

  @override
  Widget build(BuildContext context) {
    final unreadCounts = ref.watch(unreadNotificationCountsProvider).maybeWhen(
      data: (counts) => counts,
      orElse: () => null,
    );

    // Get notifications based on selected tab
    final notificationsAsync = _selectedTabIndex == _announcementTab
        ? ref.watch(announcementNotificationsProvider)
        : _selectedTabIndex == _campaignTab
            ? ref.watch(campaignNotificationsProvider)
            : ref.watch(personalNotificationsProvider);

    final unreadCount = _selectedTabIndex == _announcementTab
        ? (unreadCounts?.announcements ?? 0)
        : _selectedTabIndex == _campaignTab
            ? (unreadCounts?.campaigns ?? 0)
            : (unreadCounts?.personal ?? 0);

    final showBanner = !ref.watch(notificationPermissionProvider).shouldHideBanner &&
        !_isNotificationBannerDismissed;

    return Scaffold(
      backgroundColor: AppColors.greyBackground,
      appBar: AppBar(
        backgroundColor: AppColors.secondaryHighlightColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 56,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.router.maybePop(),
        ),
        title: const Text(
          '消息通知',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: Color(0xFF333333),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        color: AppColors.primaryHighlightColor,
        child: CustomScrollView(
          slivers: [
            // Spacing or Permission Banner
            SliverToBoxAdapter(
              child: showBanner
                  ? NotificationPermissionBanner(
                      onSettingsTap: () async {
                        await AppSettings.openAppSettings(
                            type: AppSettingsType.notification);
                      },
                      onClose: () {
                        setState(() {
                          _isNotificationBannerDismissed = true;
                        });
                      },
                    )
                  : const SizedBox(height: 16),
            ),
            // Sticky Tab bar
            SliverPersistentHeader(
              pinned: true,
              delegate: _NotificationTabsDelegate(
                selectedIndex: _selectedTabIndex,
                onIndexChanged: (index) => setState(() => _selectedTabIndex = index),
                unreadCounts: unreadCounts,
              ),
            ),
            // Divider below tabs
            const SliverToBoxAdapter(
              child: Divider(height: 2, thickness: 4, color: Color(0xFFF2F2F2)),
            ),
            // Tab content
            ..._buildTabContent(notificationsAsync, unreadCount),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildTabContent(
    AsyncValue<List<NotificationItemModel>> notificationsAsync,
    int unreadCount,
  ) {

    return notificationsAsync.when(
      loading: () => [
        const SliverFillRemaining(
          hasScrollBody: false,
          child: ColoredBox(
            color: Colors.white,
            child: Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryHighlightColor,
                )
            ),
          ),
        ),
      ],
      error: (error, stack) => [
        SliverFillRemaining(
          hasScrollBody: false,
          child: ColoredBox(
            color: Colors.white,
            child: Center(child: Text('載入失敗: ${ErrorMessages.getDisplayMessage(error.toString())}')),
          ),
        ),
      ],
      data: (notifications) {
        if (notifications.isEmpty) {
          return [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Container(
                color: Colors.white,
                child: const EmptyNotificationsView(),
              ),
            ),
          ];
        }
        return [
          // Mark all read header
          SliverToBoxAdapter(
            child: _buildMarkAllReadHeader(unreadCount > 0),
          ),
          // Notification list
          DecoratedSliver(
            decoration: const BoxDecoration(color: Colors.white),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final notification = notifications[index];
                  return _buildNotificationItem(notification, index, notifications.length);
                },
                childCount: notifications.length,
              ),
            ),
          ),
          // Fill remaining space with white background
          const SliverFillRemaining(
            hasScrollBody: false,
            child: ColoredBox(color: Colors.white),
          ),
        ];
      },
    );
  }

  Widget _buildMarkAllReadHeader(bool hasUnread) {
    final color = hasUnread ? AppColors.indicatorColor : Colors.grey;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: hasUnread ? () => _handleMarkAllRead() : null,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  ECOCOIcons.openeye,
                  size: 16,
                  color: color,
                ),
                const SizedBox(width: 16),
                Text(
                  '全部已讀',
                  style: TextStyle(
                    color: color,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleMarkAllRead() async {
    await showDialog(
      context: context,
      builder: (context) => MarkAllReadAlert(
        onConfirm: () async {
          if (_selectedTabIndex == _announcementTab) {
            await ref
                .read(announcementNotificationsProvider.notifier)
                .markAllAsRead();
          } else if (_selectedTabIndex == _campaignTab) {
            await ref
                .read(campaignNotificationsProvider.notifier)
                .markAllAsRead();
          } else if (_selectedTabIndex == _personalTab) {
            await ref
                .read(personalNotificationsProvider.notifier)
                .markAllAsRead();
          }
        },
        onCancel: () {},
      ),
    );
  }

  Widget _buildNotificationItem(
    NotificationItemModel notification,
    int index,
    int totalCount,
  ) {
    return Column(
      children: [
        NotificationListItem(
          notification: notification,
          onTap: () => _handleNotificationTap(
            notification,
            _selectedTabIndex == _announcementTab
                ? NotificationType.announcement
                : _selectedTabIndex == _campaignTab
                    ? NotificationType.campaign
                    : NotificationType.personal,
          ),
          showDivider: index < totalCount - 1,
        ),
      ],
    );
  }

  void _handleNotificationTap(NotificationItemModel notification, NotificationType type) {
    // Mark as read
    if (!notification.isRead) {
      if (type == NotificationType.announcement) {
        ref.read(announcementNotificationsProvider.notifier).markAsRead(notification.id);
      } else if (type == NotificationType.campaign) {
        ref.read(campaignNotificationsProvider.notifier).markAsRead(notification.id);
      } else if (type == NotificationType.personal) {
        ref.read(personalNotificationsProvider.notifier).markAsRead(notification.id);
      }
    }

    // Handle action based on actionType
    switch (notification.actionType) {
      case 'LOAD_MARKDOWN':
        if (notification.actionLink != null) {
          context.router.pushThrottledWithTracking(MarkdownViewerRoute(
            title: notification.title,
            tagText: notification.tagText,
            url: notification.actionLink!,
            pageType: type == NotificationType.announcement
                ? 'announcement'
                : 'campaign',
          ));
        } else {
          _showInvalidLinkSnackBar();
        }
        break;
      case 'APP_PAGE':
        if (notification.actionLink != null) {
          final data = LinkParser.parseString(notification.actionLink!);
          if (data != null) {
            final router = DeepLinkRouterForWidgetRef(ref);
            router.navigate(data);
          } else {
            _showInvalidLinkSnackBar();
          }
        } else {
          _showInvalidLinkSnackBar();
        }
        break;
      case 'EXTERNAL_URL':
      case 'DEEPLINK':
        if (notification.actionLink != null) {
          final uri = Uri.parse(notification.actionLink!);
          launchUrl(uri, mode: LaunchMode.inAppBrowserView);
        } else {
          _showInvalidLinkSnackBar();
        }
        break;
      case 'NONE':
      default:
        // No action
        break;
    }
  }

  /*void _showExternalUrlConfirmDialog(String url) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => SimpleConfirmAlert(
        title: '前往外部連結',
        message: '是否確定離開ECOCO APP\n前往第三方網站',
        confirmText: '確定',
        cancelText: '取消',
        onConfirm: () async {
          final uri = Uri.parse(url);
          await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
        },
        onCancel: () {},
      ),
    );
  }*/

  void _showInvalidLinkSnackBar() {
    SnackBarHelper.show(context, '連結失效 (null link)');
  }
}

/// Sticky notification tabs delegate
class _NotificationTabsDelegate extends SliverPersistentHeaderDelegate {
  final int selectedIndex;
  final Function(int) onIndexChanged;
  final UnreadNotificationCounts? unreadCounts;

  _NotificationTabsDelegate({
    required this.selectedIndex,
    required this.onIndexChanged,
    required this.unreadCounts,
  });

  @override
  double get minExtent => 48.0;

  @override
  double get maxExtent => 48.0;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: Row(
          children: [
            _buildTab(0, '公告', (unreadCounts?.announcements ?? 0) > 0, context),
            _buildTab(1, '活動', (unreadCounts?.campaigns ?? 0) > 0, context),
            _buildTab(2, '個人', (unreadCounts?.personal ?? 0) > 0, context),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(int index, String label, bool hasUnread, BuildContext context) {
    final isSelected = selectedIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => onIndexChanged(index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 7),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            border: Border(
              bottom: BorderSide(
                color: Colors.grey.shade300,
                width: 1,
              ),
            ),
          ),
          child: Center(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                isSelected
                    ? Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.primaryHighlightColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: MediaQuery(
                          data: MediaQuery.of(context).copyWith(
                            textScaler: TextScaler.linear(1.0),
                          ),
                          child: Text(
                            label,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      )
                    : Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 5),
                        child: MediaQuery(
                          data: MediaQuery.of(context).copyWith(
                            textScaler: TextScaler.linear(1.0),
                          ),
                          child: Text(
                            label,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: AppColors.secondaryValueColor,
                              fontWeight: FontWeight.normal,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                if (hasUnread)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(1),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Container(
                        width: 5,
                        height: 5,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(_NotificationTabsDelegate oldDelegate) {
    return oldDelegate.selectedIndex != selectedIndex ||
        oldDelegate.unreadCounts != unreadCounts;
  }
}
