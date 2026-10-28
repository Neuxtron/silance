import 'package:silance/features/notifications/domain/entities/app_notification.dart';
import 'package:silance/features/notifications/domain/entities/notification_channel.dart';

abstract class NotificationRepository {
  Future<void> initialize(List<NotificationChannel> channels);
  Future<void> requestPermissions();
  Future<void> show(AppNotification notification);
}
