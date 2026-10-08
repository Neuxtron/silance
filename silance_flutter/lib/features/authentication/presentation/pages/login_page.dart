import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:silance/core/router/app_routes.dart';

class LoginPage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: () => context.push(AppRoutes.register),
          child: const Text('Register'),
        ),
      ),
    );
  }
}
