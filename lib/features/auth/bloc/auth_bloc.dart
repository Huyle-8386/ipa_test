import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fintrack/features/auth/domain/usecases/sign_in.dart';
import 'package:fintrack/features/auth/domain/usecases/sign_up.dart';
import 'package:fintrack/features/auth/domain/usecases/validate_email.dart';
import 'package:fintrack/features/auth/domain/usecases/validate_password.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignIn signIn;
  final SignUp signUp;
  final ValidateEmail validateEmail;
  final ValidatePassword validatePassword;

  AuthBloc({
    required this.signIn,
    required this.signUp,
    required this.validateEmail,
    required this.validatePassword,
  }) : super(AuthState.initial()) {
    on<EmailChanged>(_onEmailChanged);
    on<PasswordChanged>(_onPasswordChanged);
    on<FullNameChanged>(_onFullNameChanged);
    on<PhoneChanged>(_onPhoneChanged);
    on<ToggleRememberMe>(_onToggleRememberMe);
    on<SignInSubmitted>(_onSignInSubmitted);
    on<SignUpSubmitted>(_onSignUpSubmitted);
  }

  Future<void> _onEmailChanged(EmailChanged event, Emitter<AuthState> emit) async {
    final result = await validateEmail(event.email);
    result.fold(
      (error) => emit(state.copyWith(email: event.email, emailError: error)),
      (errorMessage) => emit(state.copyWith(email: event.email, emailError: errorMessage)),
    );
  }

  Future<void> _onPasswordChanged(PasswordChanged event, Emitter<AuthState> emit) async {
    final result = await validatePassword(event.password);
    result.fold(
      (error) => emit(state.copyWith(password: event.password, passwordError: error)),
      (errorMessage) => emit(state.copyWith(password: event.password, passwordError: errorMessage)),
    );
  }

  void _onFullNameChanged(FullNameChanged event, Emitter<AuthState> emit) {
    emit(state.copyWith(fullName: event.fullName));
  }

  void _onPhoneChanged(PhoneChanged event, Emitter<AuthState> emit) {
    emit(state.copyWith(phone: event.phone));
  }

  void _onToggleRememberMe(ToggleRememberMe event, Emitter<AuthState> emit) {
    emit(state.copyWith(rememberMe: !state.rememberMe));
  }

  Future<void> _onSignInSubmitted(
    SignInSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    // Validate before submitting
    final emailValidation = await validateEmail(state.email);
    final passwordValidation = await validatePassword(state.password);

    String? emailError;
    String? passwordError;

    emailValidation.fold(
      (error) => emailError = error,
      (error) => emailError = error,
    );

    passwordValidation.fold(
      (error) => passwordError = error,
      (error) => passwordError = error,
    );

    if (emailError != null || passwordError != null) {
      emit(state.copyWith(
        emailError: emailError,
        passwordError: passwordError,
      ));
      return;
    }

    emit(state.copyWith(isLoading: true, errorMessage: null));

    final result = await signIn(
      email: state.email,
      password: state.password,
      rememberMe: state.rememberMe,
    );

    result.fold(
      (error) => emit(state.copyWith(
        isLoading: false,
        errorMessage: error,
      )),
      (user) => emit(state.copyWith(
        isLoading: false,
        isAuthenticated: true,
      )),
    );
  }

  Future<void> _onSignUpSubmitted(
    SignUpSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    // Validate before submitting
    final emailValidation = await validateEmail(state.email);
    final passwordValidation = await validatePassword(state.password);

    String? emailError;
    String? passwordError;

    emailValidation.fold(
      (error) => emailError = error,
      (error) => emailError = error,
    );

    passwordValidation.fold(
      (error) => passwordError = error,
      (error) => passwordError = error,
    );

    if (emailError != null || passwordError != null) {
      emit(state.copyWith(
        emailError: emailError,
        passwordError: passwordError,
      ));
      return;
    }

    if (state.fullName.isEmpty) {
      emit(state.copyWith(errorMessage: 'Full name is required'));
      return;
    }

    emit(state.copyWith(isLoading: true, errorMessage: null));

    final result = await signUp(
      email: state.email,
      password: state.password,
      fullName: state.fullName,
      phone: state.phone.isNotEmpty ? state.phone : null,
    );

    result.fold(
      (error) => emit(state.copyWith(
        isLoading: false,
        errorMessage: error,
      )),
      (user) => emit(state.copyWith(
        isLoading: false,
        isAuthenticated: true,
      )),
    );
  }
}
