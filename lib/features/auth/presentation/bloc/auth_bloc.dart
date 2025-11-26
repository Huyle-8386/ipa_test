import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fintrack/core/error/failure.dart';
import 'package:fintrack/features/auth/domain/usecases/sign_in.dart';
import 'package:fintrack/features/auth/domain/usecases/sign_up.dart';
import 'package:fintrack/features/auth/domain/usecases/sign_in_with_google.dart';
import 'package:fintrack/features/auth/domain/usecases/validate_email.dart';
import 'package:fintrack/features/auth/domain/usecases/validate_password.dart';
import 'package:fintrack/features/auth/domain/entities/user.dart';
import 'package:fintrack/features/money_source/domain/usecases/check_user_has_money_source.dart';

part 'auth_event.dart';
part 'auth_state.dart';

enum AuthRedirect { none, home, moneySource }

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignIn signIn;
  final SignUp signUp;
  final SignInWithGoogle signInWithGoogle;
  final ValidateEmail validateEmail;
  final ValidatePassword validatePassword;
  final CheckUserHasMoneySourceUseCase checkUserHasMoneySourceUseCase;

  AuthBloc({
    required this.signIn,
    required this.signUp,
    required this.signInWithGoogle,
    required this.validateEmail,
    required this.validatePassword,
    required this.checkUserHasMoneySourceUseCase,
  }) : super(AuthState.initial()) {
    on<EmailChanged>(_onEmailChanged);
    on<PasswordChanged>(_onPasswordChanged);
    on<FullNameChanged>(_onFullNameChanged);
    on<PhoneChanged>(_onPhoneChanged);
    on<ToggleRememberMe>(_onToggleRememberMe);
    on<SignInSubmitted>(_onSignInSubmitted);
    on<SignUpSubmitted>(_onSignUpSubmitted);
    on<GoogleSignInSubmitted>(_onGoogleSignInSubmitted);
    on<AuthNavigationHandled>(_onNavigationHandled);
  }

  Future<void> _onEmailChanged(
    EmailChanged event,
    Emitter<AuthState> emit,
  ) async {
    final result = await validateEmail(event.email);
    result.fold(
      (error) => emit(state.copyWith(email: event.email, emailError: error)),
      (errorMessage) =>
          emit(state.copyWith(email: event.email, emailError: errorMessage)),
    );
  }

  Future<void> _onPasswordChanged(
    PasswordChanged event,
    Emitter<AuthState> emit,
  ) async {
    final result = await validatePassword(event.password);
    result.fold(
      (error) =>
          emit(state.copyWith(password: event.password, passwordError: error)),
      (errorMessage) => emit(
        state.copyWith(password: event.password, passwordError: errorMessage),
      ),
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
      emit(
        state.copyWith(emailError: emailError, passwordError: passwordError),
      );
      return;
    }

    emit(state.copyWith(isLoading: true, errorMessage: null));

    final result = await signIn(
      email: state.email,
      password: state.password,
      rememberMe: state.rememberMe,
    );

    await result.fold(
      (error) async =>
          emit(state.copyWith(isLoading: false, errorMessage: error)),
      (user) async => _handleAuthSuccess(user, emit),
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
      emit(
        state.copyWith(emailError: emailError, passwordError: passwordError),
      );
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

    await result.fold(
      (error) async =>
          emit(state.copyWith(isLoading: false, errorMessage: error)),
      (user) async => _handleAuthSuccess(user, emit),
    );
  }

  Future<void> _onGoogleSignInSubmitted(
    GoogleSignInSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    final result = await signInWithGoogle();

    await result.fold(
      (error) async =>
          emit(state.copyWith(isLoading: false, errorMessage: error)),
      (user) async => _handleAuthSuccess(user, emit),
    );
  }

  Future<void> _handleAuthSuccess(User user, Emitter<AuthState> emit) async {
    final checkResult = await checkUserHasMoneySourceUseCase(user.id);
    checkResult.fold(
      (Failure failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (hasSources) => emit(
        state.copyWith(
          isLoading: false,
          isAuthenticated: true,
          user: user,
          redirect: hasSources ? AuthRedirect.home : AuthRedirect.moneySource,
          errorMessage: null,
        ),
      ),
    );
  }

  void _onNavigationHandled(
    AuthNavigationHandled event,
    Emitter<AuthState> emit,
  ) {
    emit(state.copyWith(redirect: AuthRedirect.none));
  }
}
