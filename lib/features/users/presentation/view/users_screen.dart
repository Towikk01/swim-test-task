import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/user.dart';
import '../../domain/users_repository.dart';
import '../cubit/users_cubit.dart';
import '../widgets/user_tile.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UsersCubit(getIt<UsersRepository>())..loadUsers(),
      child: const UsersView(),
    );
  }
}

class UsersView extends StatelessWidget {
  const UsersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Users')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (q) => context.read<UsersCubit>().search(q),
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search by name',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<UsersCubit, UsersState>(
              builder: (context, state) {
                return switch (state.status) {
                  UsersStatus.initial || UsersStatus.loading => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  UsersStatus.failure => _ErrorView(
                    message: state.error ?? 'Something went wrong',
                    onRetry: () => context.read<UsersCubit>().loadUsers(),
                  ),
                  UsersStatus.success => _UsersList(
                    users: state.visibleUsers,
                    onRefresh: () => context.read<UsersCubit>().loadUsers(),
                  ),
                };
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _UsersList extends StatelessWidget {
  const _UsersList({required this.users, required this.onRefresh});

  final List<User> users;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: users.isEmpty
          ? ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: const [
                SizedBox(height: 120),
                Center(child: Text('No users found')),
              ],
            )
          : ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: users.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (_, i) => UserTile(user: users[i]),
            ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 14,
        children: [
          const Icon(Icons.error_outline, color: AppColors.error, size: 48),
          Text(message, textAlign: TextAlign.center),
          ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}
