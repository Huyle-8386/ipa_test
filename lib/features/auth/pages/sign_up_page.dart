import 'package:fintrack/core/theme/app_colors.dart';
import 'package:fintrack/core/theme/app_text_styles.dart';
import 'package:fintrack/core/utils/size_utils.dart';
import 'package:fintrack/features/auth/pages/sign_in_page.dart';
import 'package:fintrack/features/auth/widgets/auth_widgets.dart';
import 'package:fintrack/features/home/pages/home_page.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  String? _emailError;
  String? _passwordError;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
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
                CustomTextField(
                  label: 'Full name',
                  hintText: 'Enter your full name',
                  controller: _fullNameController,
                  onChanged: (value) => setState(() {}),
                ),
                SizedBox(height: SizeUtils.height(context) * 0.02),
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
                // Phone number field
                CustomTextField(
                  label: 'Phone number',
                  hintText: 'Enter your phone number',
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  onChanged: (value) => setState(() {}),
                ),
                SizedBox(height: SizeUtils.height(context) * 0.04),
                // Create account button
                CustomButton(
                  label: 'Create account',
                  onPressed: () {
                    // Navigate to home
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
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
    );
  }
}
