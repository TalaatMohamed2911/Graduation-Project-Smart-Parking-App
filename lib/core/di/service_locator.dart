import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:rotary_parking/bloc/parking_bloc.dart';

import '../../features/auth/data/datasources/auth_local_datasource.dart';
import '../../features/auth/data/datasources/auth_remote_database.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repo/auth_repo_impl.dart';
import '../../features/auth/presentation/blocs/auth_cubit.dart';
import '../../features/auth/presentation/repo/auth_repo.dart';
import '../services/auth_service.dart';
import '../services/cache_service.dart';
import '../services/remote_database_service.dart';

final sl = GetIt.instance;

void initServiceLocator() {
  // Cubits
  sl.registerFactory(() => AuthCubit(sl()));
  sl.registerFactory(() => ParkingBloc());

  // Repositories
  sl.registerLazySingleton<AuthRepo>(
    () => AuthRepoImpl(
      authLocalDataSource: sl(),
      authRemoteDataSource: sl(),
      authRemoteDatabase: sl(),
    ),
  );

  // DataSources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<AuthRemoteDatabase>(
    () => AuthRemoteDatabaseImpl(sl()),
  );

  // Services
  sl.registerLazySingleton<RemoteAuthService>(
    () => RemoteAuthServiceImpl(FirebaseAuth.instance),
  );
  sl.registerLazySingleton<RemoteDatabaseService>(
    () => RemoteDatabaseServiceImpl(FirebaseFirestore.instance),
  );
  sl.registerLazySingleton<CacheService>(() => CacheServiceImpl());
}
