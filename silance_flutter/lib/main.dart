import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:silance/core/di/injection_container.dart';
import 'package:silance/core/router/app_router.dart';

void main() async {
  // Environment
  await dotenv.load(fileName: '.env');

  // Depency Injection
  setupLocator();
  await getIt.allReady();

  runApp(const SilanceApp());
}

class SilanceApp extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Silance',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      routerConfig: AppRouter.router,
    );
  }
}
