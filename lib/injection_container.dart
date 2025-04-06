import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/utils/cache_helper.dart';
import 'features/auth/auth_injection.dart';
import 'features/notes/notes_injection.dart';

final sl = GetIt.instance;

Future<void> init() async {
  final prefs = await SharedPreferences.getInstance();

  sl
    ..registerLazySingleton(() => prefs)
    ..registerLazySingleton(() => FirebaseAuth.instance)
    ..registerLazySingleton(() => GoogleSignIn())
    ..registerLazySingleton(() => CacheHelper(sl()))
    ..registerLazySingleton(() => FirebaseFirestore.instance);

  initAuth();
  initNotes();
}
