import 'package:flutter_local_notifications/flutter_local_notifications.dart';

enum NotificationPriority { low, normal, high }

class const NotificationChannel({
  required final String id,
  required final String name,
  required final String description,
  required final NotificationPriority priority,
}) {
  AndroidNotificationChannel toAndroid() {
    return AndroidNotificationChannel(
      id,
      name,
      description: description,
      importance: switch (priority) {
        NotificationPriority.low => Importance.low,
        NotificationPriority.normal => Importance.defaultImportance,
        NotificationPriority.high => Importance.high,
      },
    );
  }
}
