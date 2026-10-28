import 'package:silance/features/notifications/data/utils/notification_channels.dart';
import 'package:silance/features/notifications/domain/repositories/notification_repository.dart';

class const InitNotifications(final NotificationRepository _repo) {
  Future<void> call() => _repo.initialize(notificationChannels);
}
