import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/errors/app_failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class SignUpWithEmailUseCase implements UseCase<User, SignUpParams> {
  final AuthRepository repository;

  SignUpWithEmailUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(SignUpParams params) {
    return repository.signUpWithEmail(params.name,params.email, params.password);
  }
}

class SignInWithEmailUseCase implements UseCase<User, SignInParams> {
  final AuthRepository repository;

  SignInWithEmailUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(SignInParams params) {
    return repository.signInWithEmail(params.email, params.password);
  }
}

class SignInWithGoogleUseCase implements UseCase<User, NoParams> {
  final AuthRepository repository;

  SignInWithGoogleUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(NoParams params) {
    return repository.signInWithGoogle();
  }
}

class SignOutUseCase implements UseCase<void, NoParams> {
  final AuthRepository repository;

  SignOutUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) {
    return repository.signOut();
  }
}

class SignUpParams {
  final String name;
  final String email;
  final String password;

  SignUpParams({required this.name,required this.email, required this.password});
}

class SignInParams {
  final String email;
  final String password;

  SignInParams({required this.email, required this.password});
}
