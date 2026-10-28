import 'package:silance/core/utils/constants.dart';
import 'package:silance/features/notifications/domain/entities/notification_channel.dart';

final notificationChannels = [
  NotificationChannel(
    id: AppConstants.notifChannels.incomingMessages,
    name: 'Incoming Messages',
    description: 'New incoming messages',
    priority: .high,
  ),
];

NotificationChannel channelById(String id) {
  return notificationChannels.firstWhere((channel) => channel.id == id);
}
