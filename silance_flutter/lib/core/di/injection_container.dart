import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:silance/core/network/api_client.dart';
import 'package:silance/features/authentication/data/datasources/remote_auth_datasource.dart';
import 'package:silance/features/authentication/data/repositories/remote_auth_repo.dart';
import 'package:silance/features/authentication/domain/repositories/auth_repo.dart';
import 'package:silance/features/authentication/presentation/cubit/auth_cubit.dart';
import 'package:silance/features/authentication/presentation/cubit/login_cubit.dart';
import 'package:silance/features/authentication/presentation/cubit/register_cubit.dart';
import 'package:silance/features/home/data/remote_home_repo.dart';
import 'package:silance/features/home/domain/repositories/home_repo.dart';
import 'package:silance/features/home/presentation/cubit/home_cubit.dart';
import 'package:silance/features/messaging/data/datasources/socket_messaging_datasource.dart';
import 'package:silance/features/messaging/data/repositories/socket_messaging_repository_impl.dart';
import 'package:silance/features/messaging/domain/repositories/socket_messaging_repository.dart';
import 'package:silance/features/messaging/presentation/cubit/messaging_cubit.dart';
import 'package:silance/features/notifications/data/datasources/local_notification_datasource.dart';
import 'package:silance/features/notifications/data/repositories/notification_repository_impl.dart';
import 'package:silance/features/notifications/data/use_cases/init_notifications.dart';
import 'package:silance/features/notifications/data/use_cases/request_notification_permission.dart';
import 'package:silance/features/notifications/data/use_cases/show_notification.dart';
import 'package:silance/features/notifications/domain/repositories/notification_repository.dart';

final getIt = GetIt.instance;

void setupLocator() {
  //-----------/ API Client /-----------//
  getIt.registerSingleton(ApiClient());

  //-----------/ Authentication /-----------//
  getIt.registerLazySingleton<RemoteAuthDatasource>(
    () => RemoteAuthDatasourceImpl(getIt()),
  );
  getIt.registerLazySingleton<AuthRepo>(() => RemoteAuthRepo(getIt()));
  getIt.registerLazySingleton(() => AuthCubit(getIt())..authenticate());
  getIt.registerFactory(() => LoginCubit(getIt()));
  getIt.registerFactory(() => RegisterCubit(getIt()));
  getIt.registerFactory<HomeRepo>(() => RemoteHomeRepo(getIt()));
  getIt.registerFactory(() => HomeCubit(getIt()));

  //-----------/ Messaging /-----------//
  getIt.registerLazySingleton<SocketMessagingDatasource>(
    () => SocketMessagingDatasourceImpl(),
  );
  getIt.registerLazySingleton<SocketMessagingRepository>(
    () => SocketMessagingRepositoryImpl(getIt()),
  );
  getIt.registerLazySingleton(
    () => MessagingCubit(repo: getIt(), showNotification: getIt()),
  );

  //-----------/ Notifications /-----------//
  getIt.registerSingleton<LocalNotificationDatasource>(
    LocalNotificationDatasourceImpl(FlutterLocalNotificationsPlugin()),
  );
  getIt.registerSingleton<NotificationRepository>(
    NotificationRepositoryImpl(getIt()),
  );
  // Use Cases
  getIt.registerLazySingleton(() => InitNotifications(getIt()));
  getIt.registerLazySingleton(() => RequestNotificationPermission(getIt()));
  getIt.registerLazySingleton(() => ShowNotification(getIt()));
}
