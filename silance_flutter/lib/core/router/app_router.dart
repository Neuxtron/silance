import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:silance/core/di/injection_container.dart';
import 'package:silance/core/router/app_routes.dart';
import 'package:silance/core/router/main_shell.dart';
import 'package:silance/core/utils/stream_listenable.dart';
import 'package:silance/features/authentication/presentation/cubit/auth_cubit.dart';
import 'package:silance/features/authentication/presentation/cubit/auth_states.dart';
import 'package:silance/features/authentication/presentation/cubit/login_cubit.dart';
import 'package:silance/features/authentication/presentation/cubit/register_cubit.dart';
import 'package:silance/features/authentication/presentation/pages/login_page.dart';
import 'package:silance/features/authentication/presentation/pages/register_page.dart';
import 'package:silance/features/calls/presentation/pages/calls_page.dart';
import 'package:silance/features/home/presentation/pages/home_page.dart';
import 'package:silance/features/home/presentation/pages/splash_screen.dart';

class AppRouter {
  const AppRouter._();

  static final router = GoRouter(
    initialLocation: AppRoutes.login,
    debugLogDiagnostics: true,
    refreshListenable: StreamListenable(getIt<AuthCubit>().stream),
    redirect: (context, state) {
      final authState = getIt<AuthCubit>().state;
      final loc = state.matchedLocation;
      String? redirect(String dest) => loc == dest ? null : dest;

      // Checking auth...
      if (authState is AuthInitial) {
        return redirect(AppRoutes.splash);
      }

      final loggedIn = authState is Authenticated;
      final authPages = [AppRoutes.login, AppRoutes.register];
      final onAuthPage = authPages.contains(loc);

      // Not logged in
      if (!loggedIn && !onAuthPage) {
        return AppRoutes.login;
      }

      // Logged in
      if (loggedIn && (onAuthPage || loc == AppRoutes.splash)) {
        return AppRoutes.home;
      }
      return null;
    },
    routes: [
      //-----------/ Authentication /-----------//
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
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

      //-----------/ Main Shell Layout /-----------//
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.calls,
                builder: (context, state) => const CallsPage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
