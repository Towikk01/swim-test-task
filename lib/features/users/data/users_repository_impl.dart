import 'package:dio/dio.dart';

import '../domain/users_repository.dart';
import 'models/user.dart';

class UsersRepositoryImpl implements UsersRepository {
  UsersRepositoryImpl(this._dio);

  final Dio _dio;

  @override
  Future<List<User>> fetchUsers() async {
    final response = await _dio.get<List<dynamic>>('/users');
    final data = response.data ?? const [];
    return data.map((e) => User.fromJson(e as Map<String, dynamic>)).toList();
  }
}
