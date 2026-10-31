import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:silance/features/authentication/presentation/cubit/auth_cubit.dart';
import 'package:silance/features/authentication/presentation/cubit/register_cubit.dart';
import 'package:silance/features/authentication/presentation/cubit/register_state.dart';
import 'package:silance/features/authentication/presentation/widgets/password_text_field.dart';

class RegisterPage extends StatelessWidget {
  const new({super.key});

  void _register(BuildContext context) async {
    final registerCubit = context.read<RegisterCubit>();
    final authCubit = context.read<AuthCubit>();

    await registerCubit.submit();
    final user = registerCubit.state.user;
    if (user != null) {
      authCubit.authenticate(user);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RegisterCubit>();

    return Scaffold(
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
            PasswordTextField(
              onChanged: cubit.passwordChanged,
              hint: 'Password',
            ),
            PasswordTextField(
              onChanged: cubit.confirmPasswordChanged,
              hint: 'Confirm Password',
            ),
            const SizedBox(height: 24),
            BlocSelector<RegisterCubit, RegisterState, bool>(
              selector: (state) => state.status == .loading,
              builder: (context, loading) {
                return SizedBox(
                  width: .infinity,
                  child: ElevatedButton(
                    onPressed: loading ? null : () => _register(context),
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
                  onPressed: () => context.pop(),
                  child: const Text('Login'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
