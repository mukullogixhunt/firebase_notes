import 'package:firebase_notes/features/auth/presentation/screens/signup_screen.dart';
import 'package:firebase_notes/features/notes/domain/entities/note_entity.dart';
import 'package:firebase_notes/features/notes/presentation/screens/add_notes_screen.dart';
import 'package:firebase_notes/features/notes/presentation/screens/edit_notes_screen.dart';
import 'package:firebase_notes/features/notes/presentation/screens/notes_screen.dart';
import 'package:firebase_notes/features/profile/presentation/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'features/auth/presentation/screens/login_screen.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

const Duration transitionDuration = Duration(milliseconds: 600);
const Offset slideInFromRight = Offset(1.0, 0.0);
const Offset slideUpFromBottom = Offset(0.0, 1.0);
const Curve transitionCurve = Curves.easeInOut;

CustomTransitionPage buildTransitionPage(Widget child, Offset begin) {
  return CustomTransitionPage(
    child: child,
    transitionDuration: transitionDuration,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var tween = Tween(
        begin: begin,
        end: Offset.zero,
      ).chain(CurveTween(curve: transitionCurve));
      var offsetAnimation = animation.drive(tween);
      return SlideTransition(position: offsetAnimation, child: child);
    },
  );
}

final GoRouter router = GoRouter(
  initialLocation: /*'/'*/LoginScreen.path,
  navigatorKey: rootNavigatorKey,
  routes: [
    GoRoute(
      path: LoginScreen.path,
      pageBuilder:
          (context, state) =>
              buildTransitionPage(const LoginScreen(), slideInFromRight),
    ),

    GoRoute(
      path: SignupScreen.path,
      pageBuilder:
          (context, state) =>
              buildTransitionPage(const SignupScreen(), slideInFromRight),
    ),

    GoRoute(
      path: NotesScreen.path,
      pageBuilder:
          (context, state) =>
              buildTransitionPage(const NotesScreen(), slideInFromRight),
    ),

    GoRoute(
      path: AddNotesScreen.path,
      pageBuilder:
          (context, state) =>
              buildTransitionPage(const AddNotesScreen(), slideUpFromBottom),
    ),

    GoRoute(
      path: EditNotesScreen.path,
      pageBuilder: (context, state) {
        final note = state.extra as NoteEntity;


        return buildTransitionPage(
          EditNotesScreen(note: note),
          slideUpFromBottom,
        );
      },
    ),

    GoRoute(
      path: ProfileScreen.path,
      pageBuilder:
          (context, state) =>
              buildTransitionPage(const ProfileScreen(), slideInFromRight),
    ),
  ],
);
