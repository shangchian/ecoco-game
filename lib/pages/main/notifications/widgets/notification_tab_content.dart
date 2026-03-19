import 'package:ecoco_app/ecoco_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../utils/error_messages.dart';
import '/constants/colors.dart';
import '/models/notification_item_model.dart';
import 'notification_list_item.dart';
import 'empty_notifications_view.dart';
import 'mark_all_read_dialog.dart';

class NotificationTabContent extends StatelessWidget {
  final AsyncValue<List<NotificationItemModel>> notificationsAsync;
  final Future<void> Function() onRefresh;
  final Future<void> Function() onMarkAllRead;
  final void Function(NotificationItemModel notification) onNotificationTap;
  final int unreadCount;

  const NotificationTabContent({
    super.key,
    required this.notificationsAsync,
    required this.onRefresh,
    required this.onMarkAllRead,
    required this.onNotificationTap,
    required this.unreadCount,
  });

  @override
  Widget build(BuildContext context) {
    return notificationsAsync.when(
      data: (notifications) {
        if (notifications.isEmpty) {
          return const EmptyNotificationsView();
        }
        return RefreshIndicator(
          onRefresh: onRefresh,
          color: AppColors.primaryHighlightColor,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: _MarkAllReadHeader(
                  hasUnread: unreadCount > 0,
                  onTap: () => _handleMarkAllRead(context),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final notification = notifications[index];
                    return NotificationListItem(
                      notification: notification,
                      onTap: () => onNotificationTap(notification),
                      showDivider: index < notifications.length - 1,
                    );
                  },
                  childCount: notifications.length,
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const Center(
          child: CircularProgressIndicator(
            color: AppColors.primaryHighlightColor,
          )
      ),
      error: (error, stack) => Center(
        child: Text('載入失敗: ${ErrorMessages.getDisplayMessage(error.toString())}'),
      ),
    );
  }

  Future<void> _handleMarkAllRead(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => const MarkAllReadDialog(),
    );

    if (confirmed == true) {
      await onMarkAllRead();
    }
  }
}

class _MarkAllReadHeader extends StatelessWidget {
  final bool hasUnread;
  final VoidCallback onTap;

  const _MarkAllReadHeader({
    required this.hasUnread,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = hasUnread ? AppColors.indicatorColor : Colors.grey;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: hasUnread ? onTap : null,
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
}
