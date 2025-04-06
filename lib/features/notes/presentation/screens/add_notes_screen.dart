import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/cache_helper.dart';
import '../../../../injection_container.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../domain/entities/note_entity.dart';
import '../bloc/notes_bloc.dart';

class AddNotesScreen extends StatefulWidget {
  const AddNotesScreen({super.key});

  static const path = '/notes/add';

  @override
  State<AddNotesScreen> createState() => _AddNotesScreenState();
}

class _AddNotesScreenState extends State<AddNotesScreen> {



  final cacheHelper = sl<CacheHelper>();
  late final String _userId;
  late final UserEntity? user;

  @override
  void initState() {
    _userId = cacheHelper.getUserId() ?? "";
    user = cacheHelper.getUser();


    super.initState();
  }


  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  bool _isSaving = false;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }


  void _saveNote() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSaving = true; 
      });

      
      
      final newNote = NoteEntity(
        id: "", 
        userId: _userId,
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        createdAt: DateTime.now(), 
        updatedAt: DateTime.now(), 
      );

      context.read<NotesBloc>().add(AddNote(userId: _userId, note: newNote));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Note'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        actions: [
          
          if (_isSaving)
            const Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: Center(child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3.0,)),
            )
          else
            IconButton(
              icon: const Icon(Icons.save),
              tooltip: 'Save Note',
              onPressed: _saveNote,
            ),
        ],
      ),
      body: BlocListener<NotesBloc, NotesState>(
        listener: (context, state) {
          
          if (state is NotesSuccess && state.operation == "add") {
            setState(() { _isSaving = false; });
            
            
            
            
            Navigator.pop(context); 
          } else if (state is NotesError) {
            setState(() { _isSaving = false; });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}'), backgroundColor: Colors.redAccent),
            );
          } else if (state is NotesLoading) {
            
            
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    hintText: 'Enter note title',
                    prefixIcon: Icon(Icons.title),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _contentController,
                  decoration: const InputDecoration(
                      labelText: 'Content',
                      hintText: 'Enter note content',
                      alignLabelWithHint: true, 
                      prefixIcon: Padding( 
                        padding: EdgeInsets.only(bottom: 80), 
                        child: Icon(Icons.notes),
                      )
                  ),
                  maxLines: 5, 
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter content';
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _saveNote(), 
                ),
                const SizedBox(height: 24.0),
                
                ElevatedButton.icon(
                  icon: _isSaving ? Container(width: 24, height: 24, padding: const EdgeInsets.all(2.0), child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 3,)) : const Icon(Icons.save),
                  label: Text(_isSaving ? 'Saving...' : 'Save Note'),
                  onPressed: _isSaving ? null : _saveNote, 
                  style: ElevatedButton.styleFrom(
                     backgroundColor: Colors.teal,
                     foregroundColor: Colors.white,
                     padding: const EdgeInsets.symmetric(vertical: 12),
                     textStyle: const TextStyle(fontSize: 16)
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}