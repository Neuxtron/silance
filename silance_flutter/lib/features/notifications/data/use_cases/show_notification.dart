import 'package:silance/features/notifications/domain/entities/app_notification.dart';
import 'package:silance/features/notifications/domain/repositories/notification_repository.dart';

class const ShowNotification(final NotificationRepository _repo) {
  Future<void> call(AppNotification notification) => _repo.show(notification);
}
