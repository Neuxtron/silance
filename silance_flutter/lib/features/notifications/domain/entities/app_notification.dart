import 'package:silance/features/notifications/domain/entities/notification_channel.dart';

class const AppNotification({
  required final int id,
  required final String title,
  required final String body,
  required final NotificationChannel channel,
  final Map<String, dynamic> payload = const {},
}) {}
