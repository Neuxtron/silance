import 'package:silance/features/notifications/data/datasources/local_notification_datasource.dart';
import 'package:silance/features/notifications/domain/entities/app_notification.dart';
import 'package:silance/features/notifications/domain/entities/notification_channel.dart';
import 'package:silance/features/notifications/domain/repositories/notification_repository.dart';

class const NotificationRepositoryImpl(
  final LocalNotificationDatasource datasource,
) implements NotificationRepository {
  @override
  Future<void> initialize(List<NotificationChannel> channels) =>
      datasource.init(channels);

  @override
  Future<void> requestPermissions() => datasource.requestPermissions();

  @override
  Future<void> show(AppNotification notification) =>
      datasource.show(notification);
}
