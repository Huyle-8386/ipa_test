import 'package:fintrack/core/theme/app_colors.dart';
import 'package:fintrack/core/theme/app_text_styles.dart';
import 'package:fintrack/core/utils/size_utils.dart';
import 'package:fintrack/features/auth/presentation/page/sign_in_page.dart';
import 'package:fintrack/features/auth/presentation/widget/auth_widgets.dart';
import 'package:fintrack/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:fintrack/features/auth/data/datasource/auth_remote_data_source.dart';
import 'package:fintrack/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:fintrack/features/auth/domain/usecases/sign_in.dart';
import 'package:fintrack/features/auth/domain/usecases/sign_up.dart';
import 'package:fintrack/features/auth/domain/usecases/sign_in_with_google.dart';
import 'package:fintrack/features/auth/domain/usecases/validate_email.dart';
import 'package:fintrack/features/auth/domain/usecases/validate_password.dart';
import 'package:fintrack/features/home/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Setup dependencies
    final remoteDataSource = AuthRemoteDataSourceImpl();
    final repository = AuthRepositoryImpl(remoteDataSource);
    final signInUseCase = SignIn(repository);
    final signUpUseCase = SignUp(repository);
    final signInWithGoogleUseCase = SignInWithGoogle(repository);
    final validateEmailUseCase = ValidateEmail(repository);
    final validatePasswordUseCase = ValidatePassword(repository);

    return BlocProvider(
      create: (context) => AuthBloc(
        signIn: signInUseCase,
        signUp: signUpUseCase,
        signInWithGoogle: signInWithGoogleUseCase,
        validateEmail: validateEmailUseCase,
        validatePassword: validatePasswordUseCase,
      ),
      child: const _SignUpView(),
    );
  }
}

class _SignUpView extends StatefulWidget {
  const _SignUpView();

  @override
  State<_SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<_SignUpView> {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.isAuthenticated) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        }
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: AppColors.red,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: SizeUtils.width(context) * 0.06,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: SizeUtils.height(context) * 0.08),
                  // Logo
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/icons/fintrack_icon.png',
                          width: 40,
                          height: 40,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'fintrack',
                          style: AppTextStyles.heading1.copyWith(
                            color: AppColors.main,
                            fontSize: 36,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: SizeUtils.height(context) * 0.08),
                  // Sign up title
                  Text(
                    'Sign up!',
                    style: AppTextStyles.heading1.copyWith(
                      color: AppColors.white,
                      fontSize: 28,
                    ),
                  ),
                  SizedBox(height: SizeUtils.height(context) * 0.04),
                  // Full name field
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return CustomTextField(
                        label: 'Full name',
                        hintText: 'Enter your full name',
                        controller: _fullNameController,
                        onChanged: (value) {
                          context.read<AuthBloc>().add(FullNameChanged(value));
                        },
                      );
                    },
                  ),
                  SizedBox(height: SizeUtils.height(context) * 0.02),
                  // Email field
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return CustomTextField(
                        label: 'E-mail',
                        hintText: 'Enter your email',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        errorText: state.emailError,
                        onChanged: (value) {
                          context.read<AuthBloc>().add(EmailChanged(value));
                        },
                      );
                    },
                  ),
                  SizedBox(height: SizeUtils.height(context) * 0.02),
                  // Password field
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return CustomTextField(
                        label: 'Password',
                        hintText: 'Enter your password',
                        controller: _passwordController,
                        isPassword: true,
                        errorText: state.passwordError,
                        onChanged: (value) {
                          context.read<AuthBloc>().add(PasswordChanged(value));
                        },
                      );
                    },
                  ),
                  SizedBox(height: SizeUtils.height(context) * 0.02),
                  // Phone number field
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return CustomTextField(
                        label: 'Phone number',
                        hintText: 'Enter your phone number',
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        onChanged: (value) {
                          context.read<AuthBloc>().add(PhoneChanged(value));
                        },
                      );
                    },
                  ),
                  SizedBox(height: SizeUtils.height(context) * 0.04),
                  // Create account button
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return CustomButton(
                        label: state.isLoading
                            ? 'Creating account...'
                            : 'Create account',
                        onPressed: state.isLoading
                            ? null
                            : () {
                                context.read<AuthBloc>().add(SignUpSubmitted());
                              },
                      );
                    },
                  ),
                  SizedBox(height: SizeUtils.height(context) * 0.03),
                  // Sign in link
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account? ',
                          style: AppTextStyles.body2.copyWith(
                            color: AppColors.grey,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignInPage(),
                              ),
                            );
                          },
                          child: Text(
                            'Sign in',
                            style: AppTextStyles.body2.copyWith(
                              color: AppColors.main,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: SizeUtils.height(context) * 0.04),
                ],
              ),
            ),
          ),
        ),
      ), // closes BlocListener
    );
  }
}
