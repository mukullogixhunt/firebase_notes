import 'package:dartz/dartz.dart';
import '../../../../core/errors/app_failures.dart';
import '../../domain/entities/note_entity.dart';
import '../../domain/repositories/notes_repository.dart';
import '../datasources/notes_remote_data_source.dart';
import '../models/note_model.dart';

class NotesRepositoryImpl implements NotesRepository {
  final NotesRemoteDataSource notesRemoteDataSource;

  NotesRepositoryImpl({required this.notesRemoteDataSource});

  @override
  Future<Either<Failure, void>> addNote(String userId, NoteEntity note) async {
    try {
      await notesRemoteDataSource.addNote(
        userId,
        NoteModel(
          id: note.id,
          title: note.title,
          content: note.content,
          createdAt: note.createdAt,
          updatedAt: note.updatedAt,
          userId: note.userId,
        ),
      );
      return const Right(null);
    } catch (e) {
      return Left(
        FirebaseGeneralFailure(message: e.toString(), statusCode: 500),
      );
    }
  }

  @override
  Future<Either<Failure, void>> updateNote(
    String userId,
    NoteEntity note,
  ) async {
    try {
      await notesRemoteDataSource.updateNote(
        userId,
        NoteModel(
          id: note.id,
          title: note.title,
          content: note.content,
          createdAt: note.createdAt,
          updatedAt: note.updatedAt,
          userId: note.userId,
        ),
      );
      return const Right(null);
    } catch (e) {
      return Left(
        FirebaseGeneralFailure(message: e.toString(), statusCode: 500),
      );
    }
  }

  @override
  Future<Either<Failure, void>> deleteNote(String userId, String noteId) async {
    try {
      await notesRemoteDataSource.deleteNote(userId, noteId);
      return const Right(null);
    } catch (e) {
      return Left(
        FirebaseGeneralFailure(message: e.toString(), statusCode: 500),
      );
    }
  }

  @override
  Future<Either<Failure, List<NoteEntity>>> getNotes(String userId) async {
    try {
      final notes = await notesRemoteDataSource.getNotes(userId);
      return Right(notes);
    } catch (e) {
      return Left(
        FirebaseGeneralFailure(message: e.toString(), statusCode: 500),
      );
    }
  }
}
