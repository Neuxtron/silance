import 'package:silance/features/notifications/domain/repositories/notification_repository.dart';

class const RequestNotificationPermission(final NotificationRepository _repo) {
  Future<void> call() => _repo.requestPermissions();
}
