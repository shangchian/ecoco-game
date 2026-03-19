import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/repositories/notification_repository.dart';
import 'notification_service_provider.dart';

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  final notificationService = ref.watch(notificationServiceProvider);
  return NotificationRepository(
    ref: ref,
    notificationService: notificationService,
  );
});
