import 'package:get_it/get_it.dart';
import 'package:silance/core/network/api_client.dart';
import 'package:silance/features/authentication/data/repositories/remote_auth_repo.dart';
import 'package:silance/features/authentication/domain/repositories/auth_repo.dart';
import 'package:silance/features/authentication/presentation/cubit/auth_cubit.dart';
import 'package:silance/features/authentication/presentation/cubit/login_cubit.dart';
import 'package:silance/features/authentication/presentation/cubit/register_cubit.dart';
import 'package:silance/features/home/data/remote_home_repo.dart';
import 'package:silance/features/home/domain/repositories/home_repo.dart';
import 'package:silance/features/home/presentation/cubit/home_cubit.dart';

final getIt = GetIt.instance;

void setupLocator() {
  //-----------/ API Client /-----------//
  getIt.registerSingleton(ApiClient());

  //-----------/ Authentication /-----------//
  getIt.registerLazySingleton<AuthRepo>(() => RemoteAuthRepo(getIt()));
  getIt.registerLazySingleton(() => AuthCubit(getIt()));
  getIt.registerFactory(() => LoginCubit(getIt()));
  getIt.registerFactory(() => RegisterCubit(getIt()));
  getIt.registerFactory<HomeRepo>(() => RemoteHomeRepo(getIt()));
  getIt.registerFactory(() => HomeCubit(getIt()));
}
