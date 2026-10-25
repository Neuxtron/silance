import 'package:equatable/equatable.dart';
import 'package:silance/features/messaging/domain/entities/message.dart';

enum ConnectionStatus { initial, connected, disconnected }

class const MessagingState({
  final List<Message> messages = const [],
  final ConnectionStatus status = .initial,
  final String? errorMessage,
}) extends Equatable {
  MessagingState copyWith({
    List<Message>? messages,
    ConnectionStatus? status,
    String? Function()? errorMessage,
  }) {
    return MessagingState(
      messages: messages ?? this.messages,
      status: status ?? this.status,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [messages, status, errorMessage];
}
