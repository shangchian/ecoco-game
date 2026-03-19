import 'package:riverpod_annotation/riverpod_annotation.dart';
import '/services/interface/i_notifications_data_service.dart';
import '/services/online/notifications_data_service.dart';

part 'notifications_data_service_provider.g.dart';

@Riverpod(keepAlive: true)
INotificationsDataService notificationsDataService(Ref ref) {
  return NotificationsDataService();
}
