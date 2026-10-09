import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:silance/features/authentication/presentation/cubit/register_cubit.dart';
import 'package:silance/features/authentication/presentation/cubit/register_state.dart';

class RegisterPage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RegisterCubit>();

    return BlocListener<RegisterCubit, RegisterState>(
      listenWhen: (p, c) => p.status != c.status,
      listener: (context, state) {
        if (state.status == .success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Register successful')),
          );
        }
      },
      child: Scaffold(
        body: SingleChildScrollView(
          padding: const .all(24),
          child: Column(
            children: [
              const SizedBox(height: 90),
              const Text(
                'Create Account',
                style: TextStyle(fontSize: 32),
              ),
              const SizedBox(height: 48),
              BlocSelector<RegisterCubit, RegisterState, String?>(
                selector: (state) => state.errorMessage,
                builder: (context, message) {
                  return Text(
                    message ?? '',
                    style: const TextStyle(color: Colors.red),
                    textAlign: .center,
                  );
                },
              ),
              TextField(
                onChanged: cubit.nameChanged,
                decoration: const InputDecoration(
                  hintText: 'Your Name',
                ),
              ),
              TextField(
                onChanged: cubit.phoneChanged,
                decoration: const InputDecoration(
                  hintText: 'Phone Number',
                ),
              ),
              TextField(
                onChanged: cubit.usernameChanged,
                decoration: const InputDecoration(
                  hintText: 'Username (Optional)',
                ),
              ),
              TextField(
                onChanged: cubit.passwordChanged,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Password',
                ),
              ),
              TextField(
                onChanged: cubit.confirmPasswordChanged,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Confirm Password',
                ),
              ),
              const SizedBox(height: 24),
              BlocSelector<RegisterCubit, RegisterState, bool>(
                selector: (state) => state.status == .loading,
                builder: (context, state) {
                  return SizedBox(
                    width: .infinity,
                    child: ElevatedButton(
                      onPressed: cubit.submit,
                      child: const Text('Register'),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: .center,
                children: [
                  const Text('Already have an account?'),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Login'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
