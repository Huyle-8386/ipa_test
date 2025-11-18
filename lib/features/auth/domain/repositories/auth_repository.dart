import 'package:dartz/dartz.dart';
import 'package:fintrack/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  Future<Either<String, User>> signIn({
    required String email,
    required String password,
    required bool rememberMe,
  });

  Future<Either<String, User>> signUp({
    required String email,
    required String password,
    required String fullName,
    String? phone,
  });

  Future<Either<String, User>> signInWithGoogle();

  Future<Either<String, void>> signOut();
  
  Future<Either<String, String?>> validateEmail(String email);
  Future<Either<String, String?>> validatePassword(String password);
}
