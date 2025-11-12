import 'package:dartz/dartz.dart';
import 'package:fintrack/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:fintrack/features/auth/domain/entities/user.dart';
import 'package:fintrack/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<String, User>> signIn({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    try {
      final user = await remoteDataSource.signIn(
        email: email,
        password: password,
        rememberMe: rememberMe,
      );
      return Right(user);
    } catch (e) {
      return Left('Sign in failed: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, User>> signUp({
    required String email,
    required String password,
    required String fullName,
    String? phone,
  }) async {
    try {
      final user = await remoteDataSource.signUp(
        email: email,
        password: password,
        fullName: fullName,
        phone: phone,
      );
      return Right(user);
    } catch (e) {
      return Left('Sign up failed: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, void>> signOut() async {
    try {
      await remoteDataSource.signOut();
      return const Right(null);
    } catch (e) {
      return Left('Sign out failed: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, String?>> validateEmail(String email) async {
    if (email.isEmpty) {
      return const Right(null); // No error for empty field
    }

    // Check if email ends with @gmail.com
    if (!email.endsWith('@gmail.com')) {
      return const Right('Please enter the correct email format');
    }

    // Check if there are at least 2 characters before @
    final atIndex = email.indexOf('@');
    if (atIndex < 2) {
      return const Right('Please enter the correct email format');
    }

    return const Right(null); // Valid email
  }

  @override
  Future<Either<String, String?>> validatePassword(String password) async {
    if (password.isEmpty) {
      return const Right(null); // No error for empty field
    }

    // Check minimum length
    if (password.length < 6) {
      return const Right('Please enter a password with at least 6 characters, containing at least 1 uppercase letter, 1 lowercase letter and 1 number');
    }

    // Check for at least 1 uppercase letter
    if (!password.contains(RegExp(r'[A-Z]'))) {
      return const Right('Please enter a password with at least 6 characters, containing at least 1 uppercase letter, 1 lowercase letter and 1 number');
    }

    // Check for at least 1 lowercase letter
    if (!password.contains(RegExp(r'[a-z]'))) {
      return const Right('Please enter a password with at least 6 characters, containing at least 1 uppercase letter, 1 lowercase letter and 1 number');
    }

    // Check for at least 1 number
    if (!password.contains(RegExp(r'[0-9]'))) {
      return const Right('Please enter a password with at least 6 characters, containing at least 1 uppercase letter, 1 lowercase letter and 1 number');
    }

    return const Right(null); // Valid password
  }
}
