import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:silance/features/messaging/domain/entities/message.dart';
import 'package:silance/features/messaging/domain/repositories/socket_messaging_repository.dart';
import 'package:silance/features/messaging/presentation/cubit/messaging_state.dart';

class MessagingCubit({
  required final SocketMessagingRepository repo,
  required final String userId,
  required final String targetId,
}) extends Cubit<MessagingState> {
  this : super(const MessagingState());

  Future<void> startMessages() async {
    repo.watchMessages(userId, targetId).listen((result) {
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
    final message = Message(
      senderId: userId,
      receiverId: targetId,
      content: content,
    );
    emit(state.copyWith(messages: [...state.messages, message]));

    final result = await repo.sendMessage(message);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: .disconnected,
          errorMessage: () => failure.message,
        ),
      ),
      (_) => emit(state.copyWith(status: .connected)),
    );
  }

  void _onMessage(Message message) {
    emit(
      state.copyWith(
        status: .connected,
        messages: [...state.messages, message],
      ),
    );
  }

  @override
  Future<void> close() {
    repo.disconnect();
    return super.close();
  }
}
