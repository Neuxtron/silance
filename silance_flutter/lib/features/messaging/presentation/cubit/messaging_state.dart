import 'package:equatable/equatable.dart';
import 'package:silance/features/messaging/domain/entities/chat_room.dart';

enum ConnectionStatus { initial, connected, disconnected }

class const MessagingState({
  // Value to track when to rebuild list
  final int updateId = 0,
  final List<ChatRoom> rooms = const [],
  final ConnectionStatus status = .initial,
  final String? errorMessage,
}) extends Equatable {
  MessagingState copyWith({
    int? updateId,
    List<ChatRoom>? rooms,
    ConnectionStatus? status,
    String? Function()? errorMessage,
  }) {
    return MessagingState(
      updateId: updateId ?? this.updateId,
      rooms: rooms ?? this.rooms,
      status: status ?? this.status,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [rooms, status, errorMessage];
}
