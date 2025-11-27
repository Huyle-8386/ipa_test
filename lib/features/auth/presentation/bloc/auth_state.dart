part of 'auth_bloc.dart';

class AuthState extends Equatable {
  final String email;
  final String password;
  final String fullName;
  final String phone;
  final bool rememberMe;
  final bool isLoading;
  final bool isAuthenticated;
  final User? user;
  final AuthRedirect redirect;
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
    required this.redirect,
    this.user,
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
      redirect: AuthRedirect.none,
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
    User? user,
    AuthRedirect? redirect,
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
      user: user ?? this.user,
      redirect: redirect ?? this.redirect,
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
    user,
    redirect,
    emailError,
    passwordError,
    errorMessage,
  ];
}
