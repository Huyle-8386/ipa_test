import 'package:dartz/dartz.dart';
import 'package:fintrack/features/auth/domain/entities/user.dart';
import 'package:fintrack/features/auth/domain/repositories/auth_repository.dart';

class SignInWithGoogle {
  final AuthRepository repository;

  SignInWithGoogle(this.repository);

  Future<Either<String, User>> call() async {
    return await repository.signInWithGoogle();
  }
}
