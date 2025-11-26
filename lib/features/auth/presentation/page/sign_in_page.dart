import 'package:fintrack/core/theme/app_colors.dart';
import 'package:fintrack/core/theme/app_text_styles.dart';
import 'package:fintrack/core/utils/size_utils.dart';
import 'package:fintrack/core/di/injector.dart' as di;
import 'package:fintrack/features/auth/presentation/page/sign_up_page.dart';
import 'package:fintrack/features/auth/presentation/widget/auth_widgets.dart';
import 'package:fintrack/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:fintrack/features/auth/data/datasource/auth_remote_data_source.dart';
import 'package:fintrack/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:fintrack/features/auth/domain/usecases/sign_in.dart';
import 'package:fintrack/features/auth/domain/usecases/sign_up.dart';
import 'package:fintrack/features/auth/domain/usecases/sign_in_with_google.dart';
import 'package:fintrack/features/auth/domain/usecases/validate_email.dart';
import 'package:fintrack/features/auth/domain/usecases/validate_password.dart';
import 'package:fintrack/features/navigation/pages/bottombar_page.dart';
import 'package:fintrack/features/money_source/domain/usecases/check_user_has_money_source.dart';
import 'package:fintrack/features/money_source/presentation/pages/money_source_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

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
    final checkUserHasMoneySourceUseCase = di
        .sl<CheckUserHasMoneySourceUseCase>();

    return BlocProvider(
      create: (context) => AuthBloc(
        signIn: signInUseCase,
        signUp: signUpUseCase,
        signInWithGoogle: signInWithGoogleUseCase,
        validateEmail: validateEmailUseCase,
        validatePassword: validatePasswordUseCase,
        checkUserHasMoneySourceUseCase: checkUserHasMoneySourceUseCase,
      ),
      child: const _SignInView(),
    );
  }
}

class _SignInView extends StatefulWidget {
  const _SignInView();

  @override
  State<_SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<_SignInView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.redirect == AuthRedirect.home) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const BottombarPage()),
          );
          context.read<AuthBloc>().add(const AuthNavigationHandled());
        } else if (state.redirect == AuthRedirect.moneySource &&
            state.user != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MoneySourceRoute(uid: state.user!.id),
            ),
          );
          context.read<AuthBloc>().add(const AuthNavigationHandled());
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
                  // Welcome back title
                  Center(
                    child: Text(
                      'Welcome back!',
                      style: AppTextStyles.heading1.copyWith(
                        color: AppColors.white,
                        fontSize: 28,
                      ),
                    ),
                  ),
                  SizedBox(height: SizeUtils.height(context) * 0.04),
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
                  // Remember me & Forgot password
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: state.rememberMe,
                                onChanged: (value) {
                                  context.read<AuthBloc>().add(
                                    ToggleRememberMe(),
                                  );
                                },
                                fillColor: WidgetStateProperty.resolveWith((
                                  states,
                                ) {
                                  if (states.contains(WidgetState.selected)) {
                                    return AppColors.main;
                                  }
                                  return AppColors.widget;
                                }),
                                checkColor: Colors.black,
                              ),
                              Text(
                                'Remember Me',
                                style: AppTextStyles.body2.copyWith(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                          TextButton(
                            onPressed: () {
                              // TODO: Implement forgot password
                            },
                            child: Text(
                              'Forgot Password?',
                              style: AppTextStyles.body2.copyWith(
                                color: AppColors.main,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  SizedBox(height: SizeUtils.height(context) * 0.03),
                  // Sign in button
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return CustomButton(
                        label: 'Sign in',
                        onPressed: state.isLoading
                            ? null
                            : () {
                                context.read<AuthBloc>().add(SignInSubmitted());
                              },
                        isEnabled: !state.isLoading,
                      );
                    },
                  ),
                  SizedBox(height: SizeUtils.height(context) * 0.03),
                  // Or continue with
                  Row(
                    children: [
                      Expanded(
                        child: Divider(color: AppColors.grey.withOpacity(0.3)),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'or continue with',
                          style: AppTextStyles.body2.copyWith(
                            color: AppColors.grey,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(color: AppColors.grey.withOpacity(0.3)),
                      ),
                    ],
                  ),
                  SizedBox(height: SizeUtils.height(context) * 0.03),
                  // Social login buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SocialLoginButton(
                        iconPath: 'assets/icons/facebook_logo.png',
                        label: 'Facebook',
                        onPressed: () {
                          // TODO: Implement social login
                          // Chỗ này sẽ là chỗ làm thêm cho trang đăng nhập bằng fb
                        },
                      ),
                      const SizedBox(width: 16),
                      SocialLoginButton(
                        iconPath: 'assets/icons/google_logo.png',
                        label: 'Google',
                        onPressed: () {
                          context.read<AuthBloc>().add(GoogleSignInSubmitted());
                        },
                      ),
                      const SizedBox(width: 16),
                      SocialLoginButton(
                        iconPath: 'assets/icons/linkedin_logo.png',
                        label: 'LinkedIn',
                        onPressed: () {
                          // TODO: Implement social login
                          // Chỗ này sẽ là chỗ làm thêm cho trang đăng nhập bằng linked in
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: SizeUtils.height(context) * 0.03),
                  // Create account link
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'or ',
                          style: AppTextStyles.body2.copyWith(
                            color: AppColors.grey,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignUpPage(),
                              ),
                            );
                          },
                          child: Text(
                            'Create account',
                            style: AppTextStyles.body2.copyWith(
                              color: AppColors.main,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: SizeUtils.height(context) * 0.05),
                ],
              ),
            ),
          ),
        ),
      ), // closes BlocListener
    );
  }
}
