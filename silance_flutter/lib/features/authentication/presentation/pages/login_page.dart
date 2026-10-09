import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:silance/core/router/app_routes.dart';
import 'package:silance/features/authentication/presentation/cubit/login_cubit.dart';
import 'package:silance/features/authentication/presentation/cubit/login_state.dart';

class LoginPage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LoginCubit>();

    return BlocListener<LoginCubit, LoginState>(
      listenWhen: (p, c) => p.status != c.status,
      listener: (context, state) {
        if (state.status == .success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Login successful')),
          );
        }
      },
      child: Scaffold(
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
                selector: (state) => state.status == SubmitStatus.loading,
                builder: (context, loading) {
                  return SizedBox(
                    width: .infinity,
                    child: ElevatedButton(
                      onPressed: loading ? null : () => cubit.submit(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
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
      ),
    );
  }
}
