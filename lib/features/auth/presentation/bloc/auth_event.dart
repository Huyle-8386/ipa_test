part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class EmailChanged extends AuthEvent {
  final String email;

  const EmailChanged(this.email);

  @override
  List<Object?> get props => [email];
}

class PasswordChanged extends AuthEvent {
  final String password;

  const PasswordChanged(this.password);

  @override
  List<Object?> get props => [password];
}

class FullNameChanged extends AuthEvent {
  final String fullName;

  const FullNameChanged(this.fullName);

  @override
  List<Object?> get props => [fullName];
}

class PhoneChanged extends AuthEvent {
  final String phone;

  const PhoneChanged(this.phone);

  @override
  List<Object?> get props => [phone];
}

class ToggleRememberMe extends AuthEvent {}

class SignInSubmitted extends AuthEvent {}

class SignUpSubmitted extends AuthEvent {}

class GoogleSignInSubmitted extends AuthEvent {}

class AuthNavigationHandled extends AuthEvent {
  const AuthNavigationHandled();
}
