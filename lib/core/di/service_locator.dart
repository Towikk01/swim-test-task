import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../features/pace/data/pace_repository.dart';
import '../network/dio_client.dart';

final getIt = GetIt.instance;

/// Registers stateless, app-wide services (networking, repositories).
/// Blocs are intentionally NOT registered here — they live in the widget
/// tree via BlocProvider so their lifecycle (close()) is handled correctly.
void setupServiceLocator() {
  getIt
    ..registerLazySingleton<Dio>(createDio)
    ..registerLazySingleton<PaceRepository>(() => PaceRepository(getIt<Dio>()));
}
