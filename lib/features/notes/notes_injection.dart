import 'package:firebase_notes/features/notes/presentation/bloc/notes_bloc.dart';
import 'package:get_it/get_it.dart';

import 'data/datasources/notes_remote_data_source.dart';
import 'data/repositories/notes_repository_impl.dart';
import 'domain/repositories/notes_repository.dart';
import 'domain/usecases/notes_usecases.dart';

final sl = GetIt.instance;

void initNotes() {
  /// Use Cases
  sl.registerLazySingleton(() => AddNoteUseCase(sl()));
  sl.registerLazySingleton(() => UpdateNoteUseCase(sl()));
  sl.registerLazySingleton(() => DeleteNoteUseCase(sl()));
  sl.registerLazySingleton(() => GetNotesUseCase(sl()));

  /// Repository
  sl.registerLazySingleton<NotesRepository>(
    () => NotesRepositoryImpl(notesRemoteDataSource: sl()),
  );

  /// Remote Data Source
  sl.registerLazySingleton<NotesRemoteDataSource>(
    () => NotesRemoteDataSourceImpl(firestore: sl()),
  );

  /// Bloc
  sl.registerFactory(
    () => NotesBloc(
      addNoteUseCase: sl(),
      updateNoteUseCase: sl(),
      deleteNoteUseCase: sl(),
      getNotesUseCase: sl(),
    ),
  );
}
