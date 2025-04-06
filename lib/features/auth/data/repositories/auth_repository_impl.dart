import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/errors/app_exceptions.dart';
import '../../../../core/errors/app_failures.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/firebase_auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _authRemoteDataSource;

  AuthRepositoryImpl(this._authRemoteDataSource);

  @override
  Future<Either<Failure, User>> signUpWithEmail(String name,String email, String password) async {
    try {
      final user = await _authRemoteDataSource.signUpWithEmail(name,email, password);
      if (user == null) return Left(FirebaseGeneralFailure(message: "Signup failed", statusCode: 500));
      return Right(user);
    } catch (e) {
      return Left(FirebaseGeneralFailure(message: e.toString(), statusCode: 500));
    }
  }

  @override
  Future<Either<Failure, User>> signInWithEmail(String email, String password) async {
    try {
      final user = await _authRemoteDataSource.loginWithEmail(email, password);
      if (user == null) return Left(FirebaseGeneralFailure(message: "Login failed", statusCode: 500));
      return Right(user);
    } catch (e) {
      return Left(FirebaseGeneralFailure(message: e.toString(), statusCode: 500));
    }
  }

  @override
  Future<Either<Failure, User>> signInWithGoogle() async {
    try {
      final user = await _authRemoteDataSource.loginWithGoogle();
      if (user == null) return Left(FirebaseGeneralFailure(message: "Google sign-in failed", statusCode: 500));
      return Right(user);
    } catch (e) {
      return Left(FirebaseGeneralFailure(message: e.toString(), statusCode: 500));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await _authRemoteDataSource.logout();
      return const Right(null);
    } catch (e) {
      return Left(FirebaseGeneralFailure(message: e.toString(), statusCode: 500));
    }
  }

  @override
  User? getCurrentUser() {
    return _authRemoteDataSource.getCurrentUser();
  }
}
