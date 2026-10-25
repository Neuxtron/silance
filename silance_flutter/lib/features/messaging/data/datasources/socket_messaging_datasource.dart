import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:silance/core/error/exceptions.dart';
import 'package:silance/core/utils/remote_datasource_guard.dart';
import 'package:silance/features/messaging/domain/entities/message.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

abstract class SocketMessagingDatasource {
  Stream<Message> watchMessages(String userId, String targetId);
  void sendMessage(Message message);
  Future<void> disconnect();
}

class SocketMessagingDatasourceImpl()
    with RemoteDatasourceGuard
    implements SocketMessagingDatasource {
  WebSocketChannel? _channel;
  @override
  Stream<Message> watchMessages(String userId, String targetId) async* {
    final socketUrl = dotenv.env['SOCKET_URL'];
    final roomId = _getRoomId([userId, targetId]);
    final uri = Uri.parse('$socketUrl/messages/$roomId');
    final channel = WebSocketChannel.connect(uri);
    _channel = channel;

    try {
      await channel.ready;
      await for (final raw in channel.stream) {
        yield Message.fromJson(jsonDecode(raw as String));
      }
    } on WebSocketChannelException catch (e) {
      throw NetworkException(message: e.message);
    } finally {
      channel.sink.close();
      _channel = null;
    }
  }

  @override
  void sendMessage(Message message) {
    final channel = _channel;
    if (channel == null) throw const NetworkException();
    channel.sink.add(jsonEncode(message.toJson()));
  }

  @override
  Future<void> disconnect() async {
    await _channel?.sink.close();
    _channel = null;
  }

  String _getRoomId(List<String> ids) {
    ids.sort();
    return ids.join('_');
  }
}
