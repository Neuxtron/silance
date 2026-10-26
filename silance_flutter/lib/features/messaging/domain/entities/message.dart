import 'package:equatable/equatable.dart';

enum MessageStatus { pending, sent }

class const Message({
  required final int id,
  required final String senderId,
  required final String receiverId,
  required final String content,
  final MessageStatus status = .pending,
}) extends Equatable {
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender_id': senderId,
      'receiver_id': receiverId,
      'content': content,
    };
  }

  factory fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      senderId: json['sender_id'],
      receiverId: json['receiver_id'],
      content: json['content'],
    );
  }

  Message copyWith({
    int? id,
    String? senderId,
    String? receiverId,
    String? content,
    MessageStatus? status,
  }) {
    return Message(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      content: content ?? this.content,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [senderId, receiverId, content, status];
}
