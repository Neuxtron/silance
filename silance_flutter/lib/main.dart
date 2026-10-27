import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:silance/core/di/injection_container.dart';
import 'package:silance/core/router/app_router.dart';
import 'package:silance/features/authentication/presentation/cubit/auth_cubit.dart';
import 'package:silance/features/messaging/presentation/cubit/messaging_cubit.dart';

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
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<AuthCubit>()),
        BlocProvider(create: (context) => getIt<MessagingCubit>()),
      ],
      child: MaterialApp.router(
        title: 'Silance',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
        routerConfig: AppRouter.router,
      ),
    );
  }
}
