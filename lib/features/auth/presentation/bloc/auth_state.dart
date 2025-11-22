part of 'auth_bloc.dart';

class AuthState extends Equatable {
  final String email;
  final String password;
  final String fullName;
  final String phone;
  final bool rememberMe;
  final bool isLoading;
  final bool isAuthenticated;
  final String? emailError;
  final String? passwordError;
  final String? errorMessage;

  const AuthState({
    required this.email,
    required this.password,
    required this.fullName,
    required this.phone,
    required this.rememberMe,
    required this.isLoading,
    required this.isAuthenticated,
    this.emailError,
    this.passwordError,
    this.errorMessage,
  });

  factory AuthState.initial() {
    return const AuthState(
      email: '',
      password: '',
      fullName: '',
      phone: '',
      rememberMe: false,
      isLoading: false,
      isAuthenticated: false,
    );
  }

  AuthState copyWith({
    String? email,
    String? password,
    String? fullName,
    String? phone,
    bool? rememberMe,
    bool? isLoading,
    bool? isAuthenticated,
    String? emailError,
    String? passwordError,
    String? errorMessage,
  }) {
    return AuthState(
      email: email ?? this.email,
      password: password ?? this.password,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      rememberMe: rememberMe ?? this.rememberMe,
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      emailError: emailError,
      passwordError: passwordError,
      errorMessage: errorMessage,
    );
  }

  bool get isSignInValid =>
      emailError == null &&
      passwordError == null &&
      email.isNotEmpty &&
      password.isNotEmpty;

  bool get isSignUpValid => isSignInValid && fullName.isNotEmpty;

  @override
  List<Object?> get props => [
    email,
    password,
    fullName,
    phone,
    rememberMe,
    isLoading,
    isAuthenticated,
    emailError,
    passwordError,
    errorMessage,
  ];
}
