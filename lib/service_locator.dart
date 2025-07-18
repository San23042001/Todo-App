import 'package:get_it/get_it.dart';
import 'package:todo_app/core/network_api_service.dart';
import 'package:todo_app/core/services/sp_service.dart';
import 'package:todo_app/data/data_source/auth/auth_local_repository.dart';

import 'package:todo_app/data/data_source/auth/auth_remote_data_source.dart';
import 'package:todo_app/data/data_source/task/task_local_repository.dart';
import 'package:todo_app/data/data_source/task/task_remote_data_source.dart';
import 'package:todo_app/data/repository/auth_repository_impl.dart';
import 'package:todo_app/data/repository/task_repository_impl.dart';
import 'package:todo_app/domain/repository/auth_repository/auth_repository.dart';
import 'package:todo_app/domain/repository/task_repository/task_repository.dart';
import 'package:todo_app/features/auth/cubit/auth_cubit.dart';
import 'package:todo_app/features/home/cubit/task_cubit.dart';

final sl = GetIt.instance;

void setup() {
  sl.registerLazySingleton(() => NetworkApiService());
  sl.registerLazySingleton(() => SpService());
  sl.registerLazySingleton(() => AuthLocalRepository());
  sl.registerLazySingleton(() => TaskLocalRepository());

  sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(sl(), sl(), sl()));
  sl.registerLazySingleton<TaskRemoteDataSource>(
      () => TaskRemoteDataSourceImpl(sl(),sl()));

  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
  sl.registerLazySingleton<TaskRepository>(() => TaskRepositoryImpl(sl()));
  sl.registerFactory(() => AuthCubit(sl(), sl(), sl()));
  sl.registerFactory(() => TaskCubit(sl(),sl()));
}
