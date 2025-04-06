import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/models/note_model.dart';

abstract class NotesRemoteDataSource {
  Future<void> addNote(String userId, NoteModel note);
  Future<void> updateNote(String userId, NoteModel note);
  Future<void> deleteNote(String userId, String noteId);
  Future<List<NoteModel>> getNotes(String userId);
}

class NotesRemoteDataSourceImpl implements NotesRemoteDataSource {
  final FirebaseFirestore firestore;

  NotesRemoteDataSourceImpl({required this.firestore});

  @override
  Future<void> addNote(String userId, NoteModel note) async {
    await firestore
        .collection('users')
        .doc(userId)
        .collection('notes')
        .doc()
        .set(note.toMap());
  }

  @override
  Future<void> updateNote(String userId, NoteModel note) async {
    await firestore
        .collection('users')
        .doc(userId)
        .collection('notes')
        .doc(note.id)
        .update(note.toMap());
  }

  @override
  Future<void> deleteNote(String userId, String noteId) async {
    await firestore
        .collection('users')
        .doc(userId)
        .collection('notes')
        .doc(noteId)
        .delete();
  }

  @override
  Future<List<NoteModel>> getNotes(String userId) async {
    final snapshot = await firestore
        .collection('users')
        .doc(userId)
        .collection('notes')
        .orderBy('created_at', descending: true)
        .get();

    return snapshot.docs.map((doc) => NoteModel.fromFirestore(doc)).toList();
    // return snapshot.docs.map((doc) => NoteModel.fromMap(doc.data())).toList();
  }
}
