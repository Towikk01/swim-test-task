import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../features/pace/data/pace_repository_impl.dart';
import '../../features/pace/domain/pace_repository.dart';
import '../../features/users/data/users_repository_impl.dart';
import '../../features/users/domain/users_repository.dart';
import '../network/dio_client.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  // Bind each abstract repository to its concrete Dio implementation.
  getIt
    ..registerLazySingleton<Dio>(createDio)
    ..registerLazySingleton<PaceRepository>(
      () => PaceRepositoryImpl(getIt<Dio>()),
    )
    ..registerLazySingleton<UsersRepository>(
      () => UsersRepositoryImpl(getIt<Dio>()),
    );
}
