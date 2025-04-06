part of 'notes_bloc.dart';

sealed class NotesEvent extends Equatable {
  const NotesEvent();
  @override
  List<Object?> get props => [];
}

/// Load Notes Event
class LoadNotes extends NotesEvent {
  final String userId;

  const LoadNotes({required this.userId});

  @override
  List<Object?> get props => [userId];
}

/// Add Note Event
class AddNote extends NotesEvent {
  final String userId;
  final NoteEntity note;

  const AddNote({required this.userId, required this.note});

  @override
  List<Object?> get props => [userId, note];
}

/// Update Note Event
class UpdateNote extends NotesEvent {
  final String userId;
  final NoteEntity note;

  const UpdateNote({required this.userId, required this.note});

  @override
  List<Object?> get props => [userId, note];
}

/// Delete Note Event
class DeleteNote extends NotesEvent {
  final String userId;
  final String noteId;

  const DeleteNote({required this.userId, required this.noteId});

  @override
  List<Object?> get props => [userId, noteId];
}
