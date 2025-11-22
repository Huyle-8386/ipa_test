import 'package:dartz/dartz.dart';
import 'package:fintrack/features/auth/domain/entities/user.dart';
import 'package:fintrack/features/auth/domain/repositories/auth_repository.dart';

class SignIn {
  final AuthRepository repository;

  SignIn(this.repository);

  Future<Either<String, User>> call({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    return await repository.signIn(
      email: email,
      password: password,
      rememberMe: rememberMe,
    );
  }
}
