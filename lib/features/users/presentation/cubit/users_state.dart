part of 'users_cubit.dart';

enum UsersStatus { initial, loading, success, failure }

class UsersState extends Equatable {
  const UsersState({
    this.status = UsersStatus.initial,
    this.users = const [],
    this.query = '',
    this.error,
  });

  final UsersStatus status;
  final List<User> users;
  final String query;
  final String? error;

  List<User> get visibleUsers {
    if (query.isEmpty) return users;
    final q = query.toLowerCase();
    return users.where((u) => u.name.toLowerCase().contains(q)).toList();
  }

  UsersState copyWith({
    UsersStatus? status,
    List<User>? users,
    String? query,
    String? error,
  }) {
    return UsersState(
      status: status ?? this.status,
      users: users ?? this.users,
      query: query ?? this.query,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [status, users, query, error];
}
