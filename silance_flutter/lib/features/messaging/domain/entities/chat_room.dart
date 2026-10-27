import 'package:equatable/equatable.dart';
import 'package:silance/features/messaging/domain/entities/message.dart';

class const ChatRoom({
  required final String id,
  required final List<Message> messages,
}) extends Equatable {
  ChatRoom copyWith({List<Message>? messages}) {
    return ChatRoom(id: id, messages: messages ?? this.messages);
  }

  @override
  List<Object?> get props => [id, messages];
}
