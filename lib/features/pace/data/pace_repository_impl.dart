import 'package:dio/dio.dart';

import '../domain/pace_repository.dart';

class PaceRepositoryImpl implements PaceRepository {
  PaceRepositoryImpl(this._dio);

  final Dio _dio;

  @override
  Future<void> submitPace(int paceSeconds) async {
    await _dio.post<void>('/posts', data: {'pace_seconds': paceSeconds});
  }
}
