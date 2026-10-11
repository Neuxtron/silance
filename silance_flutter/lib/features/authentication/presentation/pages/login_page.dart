import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:silance/core/router/app_routes.dart';
import 'package:silance/features/authentication/presentation/cubit/auth_cubit.dart';
import 'package:silance/features/authentication/presentation/cubit/login_cubit.dart';
import 'package:silance/features/authentication/presentation/cubit/login_state.dart';

class LoginPage extends StatelessWidget {
  const new({super.key});

  void _login(BuildContext context) async {
    final loginCubit = context.read<LoginCubit>();
    final authCubit = context.read<AuthCubit>();

    await loginCubit.submit();
    final user = loginCubit.state.user;
    if (user != null) {
      authCubit.authenticate(user);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LoginCubit>();

    return Scaffold(
      body: SingleChildScrollView(
        padding: const .all(24),
        child: Column(
          children: [
            const SizedBox(height: 128),
            const Text(
              'Welcome',
              style: TextStyle(fontSize: 32),
            ),
            const SizedBox(height: 48),
            BlocSelector<LoginCubit, LoginState, String?>(
              selector: (state) => state.errorMessage,
              builder: (context, errorMessage) {
                return Text(
                  errorMessage ?? '',
                  style: const TextStyle(color: Colors.red),
                  textAlign: .center,
                );
              },
            ),
            TextField(
              decoration: const InputDecoration(
                hintText: 'Username/Phone',
              ),
              onChanged: cubit.usernameChanged,
            ),
            TextField(
              obscureText: true,
              keyboardType: .visiblePassword,
              decoration: const InputDecoration(
                hintText: 'Password',
              ),
              onChanged: cubit.passwordChanged,
            ),
            const SizedBox(height: 36),
            BlocSelector<LoginCubit, LoginState, bool>(
              selector: (state) => state.status == .loading,
              builder: (context, loading) {
                return SizedBox(
                  width: .infinity,
                  child: ElevatedButton(
                    onPressed: loading ? null : () => _login(context),
                    child: const Text('Login'),
                  ),
                );
              },
            ),

            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: .center,
              children: [
                const Text('Don\'t have an account yet?'),
                TextButton(
                  onPressed: () => context.push(AppRoutes.register),
                  child: const Text('Create account'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
