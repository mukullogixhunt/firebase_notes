import 'package:firebase_notes/features/profile/presentation/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/cache_helper.dart';
import '../../../../injection_container.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../domain/entities/note_entity.dart';
import '../bloc/notes_bloc.dart';
import 'add_notes_screen.dart';
import 'edit_notes_screen.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  static const path = '/notes';

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final cacheHelper = sl<CacheHelper>();
  late final String _userId;
  late final UserEntity? user;

  @override
  void initState() {
    _userId = cacheHelper.getUserId() ?? "";
    user = cacheHelper.getUser();

    context.read<NotesBloc>().add(LoadNotes(userId: _userId));

    super.initState();
  }

  void _showDeleteConfirmationDialog(BuildContext context, NoteEntity note) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Delete Note'),
          content: Text('Are you sure you want to delete "${note.title}"?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
              onPressed: () {
                context.read<NotesBloc>().add(
                  DeleteNote(userId: _userId, noteId: note.id),
                );
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes'),
        centerTitle: false,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle,size: 30,),
            tooltip: 'Profile',
            onPressed: () {
              context.push(ProfileScreen.path);
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: BlocConsumer<NotesBloc, NotesState>(
        listener: (context, state) {
          if (state is NotesError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.message}'),
                backgroundColor: Colors.redAccent,
              ),
            );
          } else if (state is NotesSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is NotesLoading && state is! NotesLoaded) {
            if (context.read<NotesBloc>().state is NotesInitial ||
                context.read<NotesBloc>().state is NotesLoading &&
                    context.read<NotesBloc>().state is! NotesLoaded) {
              return const Center(child: CircularProgressIndicator());
            }
          }

          if (state is NotesLoaded) {
            if (state.notes.isEmpty) {
              return const Center(
                child: Text(
                  'No notes yet. Add one!',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: state.notes.length,
              itemBuilder: (context, index) {
                final note = state.notes[index];
                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(vertical: 6.0),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 15.0,
                    ),
                    title: Text(
                      note.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        note.content,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.teal[600]),
                          tooltip: 'Edit Note',
                          onPressed: () {
                            context.push(EditNotesScreen.path, extra: note);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red[400]),
                          tooltip: 'Delete Note',
                          onPressed: () {
                            _showDeleteConfirmationDialog(context, note);
                          },
                        ),
                      ],
                    ),
                    onTap: () {
                      context.push(EditNotesScreen.path, extra: note);
                    },
                  ),
                );
              },
            );
          }

          return const Center(child: Text('Loading notes...'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add Note',
        onPressed: () {
          context.push(AddNotesScreen.path);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
