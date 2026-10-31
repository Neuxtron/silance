import 'package:silance/features/home/domain/entities/home_user.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded(final List<HomeUser> users, [final String? errorMessage])
    extends HomeState {}

class HomeError(final String message) extends HomeState {}
