import 'package:dartz/dartz.dart';
import '../../../../core/errors/app_failures.dart';
import '../entities/note_entity.dart';

abstract class NotesRepository {
  Future<Either<Failure, void>> addNote(String userId, NoteEntity note);
  Future<Either<Failure, void>> updateNote(String userId, NoteEntity note);
  Future<Either<Failure, void>> deleteNote(String userId, String noteId);
  Future<Either<Failure, List<NoteEntity>>> getNotes(String userId);
}
