import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:silance/features/messaging/domain/entities/chat_room.dart';
import 'package:silance/features/messaging/domain/entities/message.dart';
import 'package:silance/features/messaging/domain/repositories/socket_messaging_repository.dart';
import 'package:silance/features/messaging/presentation/cubit/messaging_state.dart';
import 'package:uuid/uuid.dart';

class MessagingCubit({required final SocketMessagingRepository repo})
    extends Cubit<MessagingState> {
  this : super(const MessagingState());

  String? _userId;
  String? _roomId;

  List<Message> get messages {
    return state.rooms.firstWhere((room) {
      return room.id == _roomId;
    }).messages;
  }

  set userId(String? value) {
    _userId = value;
  }

  set targetId(String? targetId) {
    if (targetId == null) {
      _roomId = null;
      return;
    }
    _roomId = _generateRoomId(targetId);
    if (!state.rooms.any((room) => room.id == _roomId)) {
      final room = ChatRoom(id: _roomId!, messages: []);
      emit(state.copyWith(rooms: [...state.rooms, room]));
    }
  }

  Future<void> startMessages() async {
    repo.watchMessages().listen((result) {
      result.fold(
        (failure) => emit(
          state.copyWith(
            status: .disconnected,
            errorMessage: () => failure.message,
          ),
        ),
        _onMessage,
      );
    });
  }

  Future<void> sendMessage(String content) async {
    if (_roomId == null || _userId == null) return;

    // Store message id
    final messageId = const Uuid().v7();
    final message = Message(
      id: messageId,
      senderId: _userId!,
      roomId: _roomId!,
      content: content,
    );
    emit(
      state.copyWith(
        updateId: state.updateId + 1,
        rooms: _addMessage(message),
      ),
    );

    final result = await repo.sendMessage(message);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: .disconnected,
          errorMessage: () => failure.message,
        ),
      ),
      (_) {
        // Change the status of message with matching id to .sent
        emit(
          state.copyWith(
            updateId: state.updateId + 1,
            status: .connected,
            rooms: _updateMessageStatus(messageId, .sent),
          ),
        );
      },
    );
  }

  void _onMessage(Message message) {
    emit(
      state.copyWith(
        updateId: state.updateId + 1,
        status: .connected,
        rooms: _addMessage(message),
      ),
    );
  }

  String _generateRoomId(String targetId) {
    final ids = [_userId!, targetId];
    ids.sort();
    return ids.join('_');
  }

  List<ChatRoom> _addMessage(Message message) {
    return state.rooms.map((room) {
      if (room.id != message.roomId) return room;
      return room.copyWith(messages: [...room.messages, message]);
    }).toList();
  }

  List<ChatRoom> _updateMessageStatus(String messageId, MessageStatus status) {
    return state.rooms.map((room) {
      if (room.id != _roomId) return room;
      final messages = room.messages.map((message) {
        if (message.id != messageId) return message;
        return message.copyWith(status: status);
      }).toList();
      return room.copyWith(messages: messages);
    }).toList();
  }

  Future<void> disconnect() async {
    emit(state.copyWith(rooms: [], status: .disconnected));
    await repo.disconnect();
  }

  @override
  Future<void> close() {
    repo.disconnect();
    emit(state.copyWith(rooms: [], status: .disconnected));
    return super.close();
  }
}
