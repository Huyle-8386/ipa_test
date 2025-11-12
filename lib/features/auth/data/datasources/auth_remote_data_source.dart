import 'package:fintrack/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signIn({
    required String email,
    required String password,
    required bool rememberMe,
  });

  Future<UserModel> signUp({
    required String email,
    required String password,
    required String fullName,
    String? phone,
  });

  Future<void> signOut();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @override
  Future<UserModel> signIn({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    // Mock validation
    if (email.isEmpty || password.isEmpty) {
      throw Exception('Email and password are required');
    }

    // Mock successful sign in
    return UserModel(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      email: email,
      fullName: 'User Name',
      phone: null,
    );
  }

  @override
  Future<UserModel> signUp({
    required String email,
    required String password,
    required String fullName,
    String? phone,
  }) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    // Mock validation
    if (email.isEmpty || password.isEmpty || fullName.isEmpty) {
      throw Exception('All required fields must be filled');
    }

    // Mock successful sign up
    return UserModel(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      email: email,
      fullName: fullName,
      phone: phone,
    );
  }

  @override
  Future<void> signOut() async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
