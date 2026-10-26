import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:silance/features/authentication/presentation/cubit/auth_cubit.dart';
import 'package:silance/features/messaging/domain/entities/message.dart';
import 'package:silance/features/messaging/presentation/cubit/messaging_cubit.dart';
import 'package:silance/features/messaging/presentation/cubit/messaging_state.dart';

class MessagingRoomPage extends StatefulWidget {
  const new({super.key});

  @override
  State<MessagingRoomPage> createState() => _MessagingRoomPageState();
}

class _MessagingRoomPageState extends State<MessagingRoomPage> {
  final _newMessageController = TextEditingController();

  void _sendMessage() async {
    final cubit = context.read<MessagingCubit>();
    final content = _newMessageController.text.trim();
    _newMessageController.text = '';
    await cubit.sendMessage(content);
  }

  @override
  void dispose() {
    _newMessageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            BlocSelector<MessagingCubit, MessagingState, int>(
              selector: (state) => state.updateId,
              builder: (context, _) {
                // Get fresh messages every rebuild trigger
                final messages = context
                    .read<MessagingCubit>()
                    .state
                    .messages
                    .reversed
                    .toList();
                return Expanded(
                  child: ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      return _MessageItem(
                        message: message,
                        extraMargin: () {
                          if (index == messages.length - 1) return false;
                          return message.senderId !=
                              messages[index + 1].senderId;
                        },
                      );
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 48,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _newMessageController,
                      decoration: InputDecoration(
                        hintText: 'New message...',
                        isDense: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  AspectRatio(
                    aspectRatio: 1,
                    child: SizedBox(
                      height: .infinity,
                      child: IconButton.outlined(
                        onPressed: _sendMessage,
                        icon: const Icon(Icons.send),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageItem extends StatelessWidget {
  const new({
    required this.message,
    required this.extraMargin,
  });

  final Message message;
  final bool Function() extraMargin;

  IconData get _icon {
    switch (message.status) {
      case .pending:
        return Icons.schedule;
      case .sent:
        return Icons.check;
    }
  }

  @override
  Widget build(BuildContext context) {
    final userId = context.read<AuthCubit>().user?.id;
    final isSender = message.senderId == userId;
    return Align(
      alignment: isSender ? .centerRight : .centerLeft,
      child: Container(
        padding: const .symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        margin: .only(top: extraMargin() ? 18 : 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white),
          color: isSender ? null : Colors.white,
        ),
        child: Column(
          crossAxisAlignment: .end,
          children: [
            Text(
              message.content,
              style: TextStyle(
                color: isSender ? Colors.white : Colors.black,
              ),
            ),
            Icon(
              _icon,
              size: 12,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
