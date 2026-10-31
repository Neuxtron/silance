import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:silance/core/router/app_routes.dart';
import 'package:silance/features/home/presentation/cubit/home_cubit.dart';
import 'package:silance/features/home/presentation/cubit/home_states.dart';
import 'package:silance/features/messaging/presentation/cubit/messaging_cubit.dart';

class HomePage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeCubit, HomeState>(
      listener: (context, state) {
        final message = (state as HomeLoaded).errorMessage!;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));
      },
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: context.read<HomeCubit>().refresh,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              const SliverToBoxAdapter(
                child: Padding(
                  padding: .fromLTRB(24, 38, 0, 24),
                  child: Text(
                    'Messages',
                    style: TextStyle(
                      fontSize: 36,
                      color: Colors.white38,
                      fontWeight: .bold,
                    ),
                  ),
                ),
              ),
              BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  final cubit = context.read<HomeCubit>();
                  switch (state) {
                    //-----------/ Loading /-----------//
                    case HomeInitial() || HomeLoading():
                      return const SliverFillRemaining(
                        child: Center(child: CircularProgressIndicator()),
                      );

                    //-----------/ Error /-----------//
                    case HomeError(:final message):
                      return SliverFillRemaining(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: .center,
                            children: [
                              Text(message),
                              TextButton(
                                onPressed: cubit.refresh,
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        ),
                      );

                    //-----------/ Empty /-----------//
                    case HomeLoaded(:final users) when users.isEmpty:
                      return SliverFillRemaining(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: .center,
                            children: [
                              const Text(
                                'No other users are available',
                                style: TextStyle(
                                  fontStyle: .italic,
                                  color: Colors.white54,
                                ),
                              ),
                              // TODO remove
                              TextButton(
                                onPressed: cubit.refresh,
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        ),
                      );

                    //-----------/ Loaded /-----------//
                    case HomeLoaded(:final users):
                      final ids = users.map((user) => user.id).toList();
                      context.read<MessagingCubit>().preloadRooms(ids);
                      return SliverList.builder(
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          final user = users[index];
                          return ListTile(
                            onTap: () {
                              context.push(
                                '${AppRoutes.messagingRoom}/${user.id}',
                              );
                            },
                            leading: const CircleAvatar(
                              backgroundColor: Color(0xFF331B55),
                              child: Icon(Icons.person),
                            ),
                            title: Text(user.displayName),
                            subtitle: Text(
                              user.username ?? 'No username',
                              style: TextStyle(
                                color: user.username == null
                                    ? Colors.white24
                                    : null,
                                fontStyle: user.username == null
                                    ? .italic
                                    : null,
                              ),
                            ),
                          );
                        },
                      );

                    default:
                      return SliverToBoxAdapter(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: .center,
                            children: [
                              const Text(
                                'Something went wrong, please try again',
                              ),
                              TextButton(
                                onPressed: cubit.refresh,
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        ),
                      );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
