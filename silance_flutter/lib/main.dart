import 'package:flutter/material.dart';
import 'package:silance/core/router/app_router.dart';

void main() {
  runApp(const SilanceApp());
}

class SilanceApp extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Silance',
      debugShowCheckedModeBanner: false,
      routerConfig: AppRouter.router,
    );
  }
}
