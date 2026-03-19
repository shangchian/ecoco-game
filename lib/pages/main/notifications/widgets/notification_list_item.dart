import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/models/notification_item_model.dart';
import '/constants/colors.dart';

class NotificationListItem extends StatelessWidget {
  final NotificationItemModel notification;
  final VoidCallback onTap;
  final bool showDivider;

  const NotificationListItem({
    super.key,
    required this.notification,
    required this.onTap,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.white,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Icon
                Stack(
                  children: [
                    Container(
                      width: 31,
                      height: 31,
                      decoration: BoxDecoration(
                        color: AppColors.stationHeaderBlue,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        notification.notificationType ==
                                NotificationType.announcement
                            ? Icons.settings
                            : Icons.campaign,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    // Unread indicator
                    if (!notification.isRead)
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(1),
                          decoration: BoxDecoration(
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
                const SizedBox(width: 12),
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title row with optional tag
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Tag if present
                          if (notification.tagText != null) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 0,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColors.warningRed,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                notification.tagText!,
                                style: TextStyle(
                                  color: AppColors.warningRed,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                          ],
                          // Title
                          Expanded(
                            child: Text(
                              notification.title,
                              style: TextStyle(
                                color: AppColors.secondaryTextColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      // Summary
                      Text(
                        notification.summary,
                        style: TextStyle(color: AppColors.secondaryValueColor, fontSize: 14, fontWeight: FontWeight.w500),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      // Date
                      Text(
                        _formatDate(notification.publishedAt),
                        style: TextStyle(color: AppColors.secondaryValueColor, fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                // Chevron
                Icon(
                  Icons.chevron_right,
                  color: AppColors.indicatorColor,
                  size: 24,
                ),
              ],
            ),
          ),
          if (showDivider)
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                height: 1,
                color: AppColors.dividerColor,
              ),
            ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd HH:mm').format(date.toLocal());
  }
}
