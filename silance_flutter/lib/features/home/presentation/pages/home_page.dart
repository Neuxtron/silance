import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:silance/features/authentication/presentation/cubit/auth_cubit.dart';

class HomePage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AuthCubit>();
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            const Text('You are logged in'),
            TextButton(
              onPressed: cubit.logout,
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
