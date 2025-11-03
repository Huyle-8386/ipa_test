import 'package:fintrack/core/theme/app_colors.dart';
import 'package:fintrack/core/theme/app_text_styles.dart';
import 'package:fintrack/core/utils/size_utils.dart';
import 'package:fintrack/features/auth/pages/sign_up_page.dart';
import 'package:fintrack/features/auth/widgets/auth_widgets.dart';
import 'package:fintrack/features/navigation/pages/bottombar_page.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;
  String? _emailError;
  String? _passwordError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _validateEmailInput(String email) {
    setState(() {
      _emailError = AuthValidator.getEmailError(email);
    });
  }

  void _validatePasswordInput(String password) {
    setState(() {
      _passwordError = AuthValidator.getPasswordError(password);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                CustomTextField(
                  label: 'E-mail',
                  hintText: 'Enter your email',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  errorText: _emailError,
                  onChanged: (value) {
                    _validateEmailInput(value);
                  },
                ),
                SizedBox(height: SizeUtils.height(context) * 0.02),
                // Password field
                CustomTextField(
                  label: 'Password',
                  hintText: 'Enter your password',
                  controller: _passwordController,
                  isPassword: true,
                  errorText: _passwordError,
                  onChanged: (value) {
                    _validatePasswordInput(value);
                  },
                ),
                SizedBox(height: SizeUtils.height(context) * 0.02),
                // Remember me & Forgot password
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: _rememberMe,
                          onChanged: (value) {
                            setState(() {
                              _rememberMe = value ?? false;
                            });
                          },
                          fillColor: WidgetStateProperty.resolveWith((states) {
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
                        // Chỗ này sẽ là chỗ làm thêm cho trang quên mật khẩu nhé
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
                ),
                SizedBox(height: SizeUtils.height(context) * 0.03),
                // Sign in button
                CustomButton(
                  label: 'Sign in',
                  // onPressed: _isFormValid()
                  //     ? () {
                  //         // Navigate to home
                  //         Navigator.pushReplacement(
                  //           context,
                  //           MaterialPageRoute(
                  //             builder: (context) => BottombarPage(),
                  //           ),
                  //         );
                  //       }
                  //     : null,
                  // isEnabled: _isFormValid(),
                  onPressed: () {
                    // Navigate to home
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => BottombarPage()),
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
                        // TODO: Implement social login
                        // Chỗ này sẽ là chỗ làm thêm cho trang đăng nhập bằng gg
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
                SizedBox(height: SizeUtils.height(context) * 0.04),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
