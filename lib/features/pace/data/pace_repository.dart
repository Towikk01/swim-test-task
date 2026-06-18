import 'package:dio/dio.dart';

/// Sends the selected pace to the backend.
class PaceRepository {
  PaceRepository(this._dio);

  final Dio _dio;

  /// POST /posts with body `{ "pace_seconds": ... }`.
  /// Throws [DioException] on any network/HTTP failure.
  Future<void> submitPace(int paceSeconds) async {
    await _dio.post<void>(
      '/posts',
      data: {'pace_seconds': paceSeconds},
    );
  }
}
