import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:silance/features/home/domain/repositories/home_repo.dart';
import 'package:silance/features/home/presentation/cubit/home_states.dart';

class HomeCubit(final HomeRepo repo) extends Cubit<HomeState> {
  this : super(HomeInitial());

  Future<void> getUsers() async {
    emit(HomeLoading());
    final result = await repo.getUsers();

    result.fold(
      (failure) => emit(HomeError(failure.message)),
      (users) => emit(HomeLoaded(users)),
    );
  }

  Future<void> refresh() async {
    final currUsers = (state as HomeLoaded).users;
    final result = await repo.getUsers();

    result.fold(
      (failure) => emit(HomeLoaded(currUsers, failure.message)),
      (users) => emit(HomeLoaded(users)),
    );
  }
}
