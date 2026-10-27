import 'package:equatable/equatable.dart';

enum MessageStatus { pending, sent }

class const Message({
  required final String id,
  required final String senderId,
  required final String roomId,
  required final String content,
  final MessageStatus status = .pending,
}) extends Equatable {
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender_id': senderId,
      'room_id': roomId,
      'content': content,
    };
  }

  factory fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      senderId: json['sender_id'],
      roomId: json['room_id'],
      content: json['content'],
    );
  }

  Message copyWith({
    String? id,
    String? senderId,
    String? roomId,
    String? content,
    MessageStatus? status,
  }) {
    return Message(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      roomId: roomId ?? this.roomId,
      content: content ?? this.content,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [senderId, roomId, content, status];
}
