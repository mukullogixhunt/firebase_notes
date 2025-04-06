part of 'notes_bloc.dart';

sealed class NotesState extends Equatable {
  const NotesState();
  @override
  List<Object?> get props => [];
}

/// Initial State
class NotesInitial extends NotesState {}

/// Loading State
class NotesLoading extends NotesState {}

/// Notes Loaded Successfully
class NotesLoaded extends NotesState {
  final List<NoteEntity> notes;

  const NotesLoaded(this.notes);

  @override
  List<Object?> get props => [notes];
}

/// Notes Operation Failed
class NotesError extends NotesState {
  final String message;

  const NotesError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Notes Operation Success
class NotesSuccess extends NotesState {
  final String operation;
  final String message;

  const NotesSuccess({required this.operation, required this.message});

  @override
  List<Object?> get props => [operation,message];
}
