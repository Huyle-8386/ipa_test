import 'package:dartz/dartz.dart';
import 'package:fintrack/features/auth/domain/repositories/auth_repository.dart';

class ValidatePassword {
  final AuthRepository repository;

  ValidatePassword(this.repository);

  Future<Either<String, String?>> call(String password) async {
    return await repository.validatePassword(password);
  }
}
