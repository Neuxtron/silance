import 'package:equatable/equatable.dart';

class const Message({
  required final String senderId,
  required final String receiverId,
  required final String content,
}) extends Equatable {
  Map<String, dynamic> toJson() {
    return {
      'sender_id': senderId,
      'receiver_id': receiverId,
      'content': content,
    };
  }

  factory fromJson(Map<String, dynamic> json) {
    return Message(
      senderId: json['sender_id'],
      receiverId: json['receiver_id'],
      content: json['content'],
    );
  }

  @override
  List<Object?> get props => [senderId, receiverId, content];
}
