import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:silance/features/authentication/presentation/cubit/auth_cubit.dart';
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
    final userId = context.read<AuthCubit>().user!.id;

    return BlocListener<MessagingCubit, MessagingState>(
      listenWhen: (p, c) {
        return p.messages.length != c.messages.length &&
            c.messages.lastOrNull?.receiverId == userId;
      },
      listener: (context, state) {
        final message = state.messages.lastOrNull?.content;
        if (message == null) return;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));
      },
      child: Scaffold(
        body: Column(
          children: [
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(12),
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _newMessageController,
                        decoration: InputDecoration(
                          hintText: 'New message...',
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
            ),
          ],
        ),
      ),
    );
  }
}
