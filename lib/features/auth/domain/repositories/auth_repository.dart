import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/errors/app_failures.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> signUpWithEmail(String name,String email, String password);
  Future<Either<Failure, User>> signInWithEmail(String email, String password);
  Future<Either<Failure, User>> signInWithGoogle();
  Future<Either<Failure, void>> signOut();
  User? getCurrentUser();
}
