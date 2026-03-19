import 'package:json_annotation/json_annotation.dart';

part 'notification_item_model.g.dart';

/// Notification type enum
enum NotificationType {
  announcement,
  campaign,
  personal,
}

/// Model for a notification item (announcement or campaign)
@JsonSerializable()
class NotificationItemModel {
  final String id;
  final String title;
  final String? tagText;
  final String summary;
  final DateTime publishedAt;
  final DateTime? expiredAt;
  final String actionType;
  final String? actionLink;

  /// Local-only fields (not from API)
  @JsonKey(includeFromJson: false, includeToJson: false)
  final NotificationType? notificationType;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final bool isRead;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final DateTime? readAt;

  NotificationItemModel({
    required this.id,
    required this.title,
    this.tagText,
    required this.summary,
    required this.publishedAt,
    this.expiredAt,
    required this.actionType,
    this.actionLink,
    this.notificationType,
    this.isRead = false,
    this.readAt,
  });

  factory NotificationItemModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationItemModelToJson(this);

  /// Create a copy with updated fields
  NotificationItemModel copyWith({
    String? id,
    String? title,
    String? tagText,
    String? summary,
    DateTime? publishedAt,
    DateTime? expiredAt,
    String? actionType,
    String? actionLink,
    NotificationType? notificationType,
    bool? isRead,
    DateTime? readAt,
  }) {
    return NotificationItemModel(
      id: id ?? this.id,
      title: title ?? this.title,
      tagText: tagText ?? this.tagText,
      summary: summary ?? this.summary,
      publishedAt: publishedAt ?? this.publishedAt,
      expiredAt: expiredAt ?? this.expiredAt,
      actionType: actionType ?? this.actionType,
      actionLink: actionLink ?? this.actionLink,
      notificationType: notificationType ?? this.notificationType,
      isRead: isRead ?? this.isRead,
      readAt: readAt ?? this.readAt,
    );
  }

  /// Check if the notification is currently active (not expired)
  bool get isActive {
    final now = DateTime.now();
    if (expiredAt != null && expiredAt!.isBefore(now)) {
      return false;
    }
    return publishedAt.isBefore(now) || publishedAt.isAtSameMomentAs(now);
  }
}
