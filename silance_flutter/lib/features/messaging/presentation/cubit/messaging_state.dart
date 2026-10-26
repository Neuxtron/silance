import 'package:equatable/equatable.dart';
import 'package:silance/features/messaging/domain/entities/message.dart';

enum ConnectionStatus { initial, connected, disconnected }

class const MessagingState({
  // Value to track when to rebuild list
  final int updateId = 0,
  final List<Message> messages = const [],
  final ConnectionStatus status = .initial,
  final String? errorMessage,
}) extends Equatable {
  MessagingState copyWith({
    int? updateId,
    List<Message>? messages,
    ConnectionStatus? status,
    String? Function()? errorMessage,
  }) {
    return MessagingState(
      updateId: updateId ?? this.updateId,
      messages: messages ?? this.messages,
      status: status ?? this.status,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [messages, status, errorMessage];
}
