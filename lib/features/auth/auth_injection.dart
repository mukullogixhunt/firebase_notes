import 'package:firebase_notes/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:get_it/get_it.dart';

import 'data/datasources/firebase_auth_remote_data_source.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/usecases/auth_usecases.dart';

final sl = GetIt.instance;

void initAuth() {
  /// Auth Use Cases Injection

  sl.registerLazySingleton(() => SignUpWithEmailUseCase(sl()));
  sl.registerLazySingleton(() => SignInWithEmailUseCase(sl()));
  sl.registerLazySingleton(() => SignInWithGoogleUseCase(sl()));
  sl.registerLazySingleton(() => SignOutUseCase(sl()));

  /// Auth Repository Injection
  ///
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));

  /// Auth Data sources Injection
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(firebaseAuth: sl(), googleSignIn: sl(), firebaseFirestore: sl()),
  );

  /// Auth  Bloc Injection
  sl.registerFactory(
    () => AuthBloc(
      signUpWithEmailUseCase: sl(),
      signInWithEmailUseCase: sl(),
      signInWithGoogleUseCase: sl(),
      signOutUseCase: sl(),
    ),
  );
}
