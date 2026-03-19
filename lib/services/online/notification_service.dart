import 'dart:developer';
import 'package:dio/dio.dart';

import '/models/notification_preferences.dart' as pref;
import 'base_service.dart';
import '/models/notification_settings_model.dart' as app_models;
import '/models/notification_item_model.dart';
import '/services/interface/i_notification_service.dart';

class NotificationService extends BaseService implements INotificationService {
  NotificationService({
    super.onTokenRefreshed,
    super.onRefreshFailed,
  });

  @override
  Future<app_models.NotificationSettings> getNotificationSettings() async {
    try {
      log('getNotificationSettings');
      final response = await dio.get(
        '/member/settings/notification',
      );

      validateResponse(response);
      return app_models.NotificationSettings.fromJson(response.data['result']);
    } on ApiException catch (e) {
      if (e.code == 404 || (e.code != null && e.code! >= 500)) {
        log('Backend API not yet implemented or error (${e.code}), using default notification settings.');
        return _getDefaultNotificationSettings();
      }
      throw handleError(e);
    } catch (e) {
      if (e is DioException && (e.response?.statusCode == 404 || (e.response?.statusCode != null && e.response!.statusCode! >= 500))) {
        log('Backend API not yet implemented or error (${e.response?.statusCode}), using default notification settings.');
        return _getDefaultNotificationSettings();
      }
      throw handleError(e);
    }
  }

  app_models.NotificationSettings _getDefaultNotificationSettings() {
    return app_models.NotificationSettings(
      status: true,
      typeSettings: [
        app_models.NotificationTypeSetting(typeCode: 'ECOCO_ANNOUNCE', typeName: 'ECOCO公告', isEnabled: true),
        app_models.NotificationTypeSetting(typeCode: 'CAMPAIGN_NEWS', typeName: '最新活動', isEnabled: true),
        app_models.NotificationTypeSetting(typeCode: 'BRAND_PROMO', typeName: '商家優惠', isEnabled: true),
        app_models.NotificationTypeSetting(typeCode: 'POINT_EXPIRY', typeName: '點數到期提醒', isEnabled: true),
        app_models.NotificationTypeSetting(typeCode: 'COUPON_EXPIRY', typeName: '優惠券到期提醒', isEnabled: true),
      ],
    );
  }

  @override
  Future<void> updateNotificationSettings({
    required bool globalStatus,
    required Map<pref.NotificationType, bool> preferences,
    required String fcmToken,
  }) async {
    try {
      log('updateNotificationSettings: globalStatus=$globalStatus');
      final notificationSettings = preferences.entries.map((entry) => {
        "typeCode": entry.key.typeCode,
        "isEnabled": entry.value,
      }).toList();

      final response = await dio.put(
        '/member/settings/notification',
        data: {
          "fcmToken": fcmToken,
          "notificationSettings": [
            {
              "typeCode": "GLOBAL_STATUS",
              "isEnabled": globalStatus,
            },
            ...notificationSettings,
          ],
        },
      );

      validateResponse(response);
    } on ApiException catch (e) {
      if (e.code == 404 || (e.code != null && e.code! >= 500)) {
        log('Backend API not yet implemented or error (${e.code}), ignoring save settings request.');
        return;
      }
      throw handleError(e);
    } catch (e) {
      if (e is DioException && (e.response?.statusCode == 404 || (e.response?.statusCode != null && e.response!.statusCode! >= 500))) {
        log('Backend API not yet implemented or error (${e.response?.statusCode}), ignoring save settings request.');
        return;
      }
      throw handleError(e);
    }
  }

  @override
  Future<List<NotificationItemModel>> getPersonalNotifications() async {
    try {
      log('getPersonalNotifications');
      final response = await dio.get(
        '/member/notifications/personal',
      );

      validateResponse(response);
      
      final List<dynamic> result = response.data['result'] ?? [];
      return result
          .map((json) => NotificationItemModel.fromJson(json))
          .toList();
    } on ApiException catch (e) {
      if (e.code == 404 || (e.code != null && e.code! >= 500)) {
        log('Backend API not yet implemented or error (${e.code}), returning empty personal notifications.');
        return [];
      }
      throw handleError(e);
    } catch (e) {
      if (e is DioException && (e.response?.statusCode == 404 || (e.response?.statusCode != null && e.response!.statusCode! >= 500))) {
        log('Backend API not yet implemented or error (${e.response?.statusCode}), returning empty personal notifications.');
        return [];
      }
      throw handleError(e);
    }
  }

  @override
  Future<void> reportReadStatus({
    required String id,
    required String type,
  }) async {
    try {
      log('reportReadStatus: id=$id, type=$type');
      final response = await dio.put(
        '/member/notifications/read',
        data: {
          "id": id,
          "type": type.toUpperCase(),
        },
      );

      validateResponse(response);
    } on ApiException catch (e) {
      if (e.code == 404 || (e.code != null && e.code! >= 500)) {
        log('Backend reportReadStatus API not yet implemented or error (${e.code}), skipping.');
        return;
      }
      throw handleError(e);
    } catch (e) {
      if (e is DioException && (e.response?.statusCode == 404 || (e.response?.statusCode != null && e.response!.statusCode! >= 500))) {
        log('Backend reportReadStatus API not yet implemented or error (${e.response?.statusCode}), skipping.');
        return;
      }
      throw handleError(e);
    }
  }
}
