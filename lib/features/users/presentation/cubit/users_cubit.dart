import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/user.dart';
import '../../domain/users_repository.dart';

part 'users_state.dart';

class UsersCubit extends Cubit<UsersState> {
  UsersCubit(this._repository) : super(const UsersState());

  final UsersRepository _repository;

  Future<void> loadUsers() async {
    emit(state.copyWith(status: UsersStatus.loading));
    try {
      final users = await _repository.fetchUsers();
      emit(state.copyWith(status: UsersStatus.success, users: users));
    } catch (_) {
      emit(
        state.copyWith(
          status: UsersStatus.failure,
          error: 'Failed to load users. Check your connection.',
        ),
      );
    }
  }

  void search(String query) => emit(state.copyWith(query: query));
}
