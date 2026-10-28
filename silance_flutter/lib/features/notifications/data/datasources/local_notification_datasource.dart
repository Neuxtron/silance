import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:silance/features/notifications/domain/entities/app_notification.dart';
import 'package:silance/features/notifications/domain/entities/notification_channel.dart';

abstract class LocalNotificationDatasource {
  Future<void> init(List<NotificationChannel> channels);
  Future<void> requestPermissions();
  Future<void> show(AppNotification notification);
}

class LocalNotificationDatasourceImpl(
  final FlutterLocalNotificationsPlugin _plugin,
) implements LocalNotificationDatasource {
  @override
  Future<void> init(List<NotificationChannel> channels) async {
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
      onDidReceiveNotificationResponse: (response) {
        // TODO handle notification tap
      },
    );

    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    for (var channel in channels) {
      android?.createNotificationChannel(channel.toAndroid());
    }
  }

  @override
  Future<void> requestPermissions() async {
    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission(); // Android 13+
  }

  @override
  Future<void> show(AppNotification notification) {
    final channel = notification.channel;
    return _plugin.show(
      id: notification.id,
      title: notification.title,
      body: notification.body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(channel.id, channel.name),
      ),
      payload: jsonEncode(notification.payload),
    );
  }
}
