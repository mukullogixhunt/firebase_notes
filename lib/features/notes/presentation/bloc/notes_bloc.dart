import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/note_entity.dart';
import '../../domain/usecases/notes_usecases.dart';

part 'notes_event.dart';

part 'notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  final AddNoteUseCase addNoteUseCase;
  final UpdateNoteUseCase updateNoteUseCase;
  final DeleteNoteUseCase deleteNoteUseCase;
  final GetNotesUseCase getNotesUseCase;

  NotesBloc({
    required this.addNoteUseCase,
    required this.updateNoteUseCase,
    required this.deleteNoteUseCase,
    required this.getNotesUseCase,
  }) : super(NotesInitial()) {
    on<NotesEvent>((event, emit) {});

    on<LoadNotes>(_onLoadNotes);
    on<AddNote>(_onAddNote);
    on<UpdateNote>(_onUpdateNote);
    on<DeleteNote>(_onDeleteNote);
  }

  void _onLoadNotes(LoadNotes event, Emitter<NotesState> emit) async {
    emit(NotesLoading());
    final result = await getNotesUseCase(GetNotesParams(userId: event.userId));
    result.fold(
      (failure) => emit(NotesError(failure.message)),
      (notes) => emit(NotesLoaded(notes)),
    );
  }

  void _onAddNote(AddNote event, Emitter<NotesState> emit) async {
    emit(NotesLoading());

    final result = await addNoteUseCase(
      AddNoteParams(userId: event.userId, note: event.note),
    );

    result.fold((failure) => emit(NotesError(failure.message)), (notes) {
      emit(NotesSuccess(operation: "add", message: "Note added successfully"));
      add(LoadNotes(userId: event.userId));
    });
  }

  void _onUpdateNote(UpdateNote event, Emitter<NotesState> emit) async {
    emit(NotesLoading());

    final result = await updateNoteUseCase(
      UpdateNoteParams(userId: event.userId, note: event.note),
    );

    result.fold((failure) => emit(NotesError(failure.message)), (notes) {
      emit(
        NotesSuccess(operation: "update", message: "Note updated successfully"),
      );
      add(LoadNotes(userId: event.userId));
    });
  }

  void _onDeleteNote(DeleteNote event, Emitter<NotesState> emit) async {
    emit(NotesLoading());

    final result = await deleteNoteUseCase(
      DeleteNoteParams(userId: event.userId, noteId: event.noteId),
    );

    result.fold((failure) => emit(NotesError(failure.message)), (notes) {
      emit(
        NotesSuccess(operation: "delete", message: "Note deleted successfully"),
      );
      add(LoadNotes(userId: event.userId));
    });
  }
}
