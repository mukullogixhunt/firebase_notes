import 'package:dartz/dartz.dart';
import '../../../../core/errors/app_failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/note_entity.dart';
import '../repositories/notes_repository.dart';

class AddNoteUseCase implements UseCase<void, AddNoteParams> {
  final NotesRepository repository;

  AddNoteUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(AddNoteParams params) {
    return repository.addNote(params.userId, params.note);
  }
}

class AddNoteParams {
  final String userId;
  final NoteEntity note;

  AddNoteParams({required this.userId, required this.note});
}

class UpdateNoteUseCase implements UseCase<void, UpdateNoteParams> {
  final NotesRepository repository;

  UpdateNoteUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(UpdateNoteParams params) {
    return repository.updateNote(params.userId, params.note);
  }
}

class UpdateNoteParams {
  final String userId;
  final NoteEntity note;

  UpdateNoteParams({required this.userId, required this.note});
}


class DeleteNoteUseCase implements UseCase<void, DeleteNoteParams> {
  final NotesRepository repository;

  DeleteNoteUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteNoteParams params) {
    return repository.deleteNote(params.userId, params.noteId);
  }
}

class DeleteNoteParams {
  final String userId;
  final String noteId;

  DeleteNoteParams({required this.userId, required this.noteId});
}

class GetNotesUseCase implements UseCase<List<NoteEntity>, GetNotesParams> {
  final NotesRepository repository;

  GetNotesUseCase(this.repository);

  @override
  Future<Either<Failure, List<NoteEntity>>> call(GetNotesParams params) {
    return repository.getNotes(params.userId);
  }
}

class GetNotesParams {
  final String userId;

  GetNotesParams({required this.userId});
}
