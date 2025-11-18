import 'package:dartz/dartz.dart';
import 'package:fintrack/features/auth/domain/entities/user.dart';
import 'package:fintrack/features/auth/domain/repositories/auth_repository.dart';

class SignUp {
  final AuthRepository repository;

  SignUp(this.repository);

  Future<Either<String, User>> call({
    required String email,
    required String password,
    required String fullName,
    String? phone,
  }) async {
    return await repository.signUp(
      email: email,
      password: password,
      fullName: fullName,
      phone: phone,
    );
  }
}
