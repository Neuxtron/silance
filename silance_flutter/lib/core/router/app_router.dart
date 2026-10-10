import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:silance/core/di/injection_container.dart';
import 'package:silance/core/router/app_routes.dart';
import 'package:silance/features/authentication/presentation/cubit/login_cubit.dart';
import 'package:silance/features/authentication/presentation/cubit/register_cubit.dart';
import 'package:silance/features/authentication/presentation/pages/login_page.dart';
import 'package:silance/features/authentication/presentation/pages/register_page.dart';

class AppRouter {
  const AppRouter._();

  static final router = GoRouter(
    initialLocation: AppRoutes.login,
    debugLogDiagnostics: true,
    routes: [
      //-----------/ Authentication /-----------//
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) {
          return BlocProvider(
            create: (context) => getIt<LoginCubit>(),
            child: const LoginPage(),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) {
          return BlocProvider(
            create: (context) => getIt<RegisterCubit>(),
            child: const RegisterPage(),
          );
        },
      ),
    ],
  );
}
