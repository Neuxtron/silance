import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:silance/features/home/presentation/cubit/home_cubit.dart';
import 'package:silance/features/home/presentation/cubit/home_states.dart';

class HomePage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<HomeCubit>();

    if (cubit.state is HomeLoading || cubit.state is HomeInitial) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (cubit.state is HomeError) {
      final message = (cubit.state as HomeError).message;
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: .center,
            children: [
              Text(message),
              TextButton(
                onPressed: cubit.getUsers,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    final users = (cubit.state as HomeLoaded).users;
    return Scaffold(
      body: Column(
        crossAxisAlignment: .start,
        children: [
          const Padding(
            padding: .fromLTRB(12, 32, 0, 24),
            child: Text(
              'Messages',
              style: TextStyle(
                fontSize: 36,
                color: Color(0xFF331B55),
                fontWeight: .bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return ListTile(
                  onTap: () {},
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFF331B55),
                    child: Icon(Icons.person),
                  ),
                  title: Text(user.displayName),
                  subtitle: Text(user.username ?? '-'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
