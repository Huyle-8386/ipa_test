import 'package:dartz/dartz.dart';
import 'package:fintrack/features/auth/domain/repositories/auth_repository.dart';

class ValidateEmail {
  final AuthRepository repository;

  ValidateEmail(this.repository);

  Future<Either<String, String?>> call(String email) async {
    return await repository.validateEmail(email);
  }
}
