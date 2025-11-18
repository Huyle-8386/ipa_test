import 'package:fintrack/core/theme/app_colors.dart';
import 'package:fintrack/core/theme/app_text_styles.dart';
import 'package:fintrack/core/utils/size_utils.dart';
import 'package:fintrack/features/auth/presentation/page/sign_in_page.dart';
import 'package:flutter/material.dart';

class OnboardingPage3 extends StatelessWidget {
  const OnboardingPage3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: SizeUtils.width(context) * 0.06,
          ),
          child: Column(
            children: [
              SizedBox(height: SizeUtils.height(context) * 0.08),
              // Logo
              Text(
                'fintrack',
                style: AppTextStyles.heading1.copyWith(
                  color: AppColors.main,
                  fontSize: 36,
                ),
              ),
              SizedBox(height: SizeUtils.height(context) * 0.08),
              // Gradient Circle - Larger with blue/purple/pink gradient
              Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.blue.withOpacity(0.8),
                      AppColors.purple.withOpacity(0.7),
                      const Color(0xFFE73D1C).withOpacity(0.5),
                      AppColors.background.withOpacity(0.2),
                    ],
                    stops: const [0.2, 0.5, 0.7, 1.0],
                  ),
                ),
              ),
              SizedBox(height: SizeUtils.height(context) * 0.05),
              // Title
              Text(
                'Streamline Your Finances',
                style: AppTextStyles.heading1.copyWith(
                  color: AppColors.main,
                  fontSize: 32,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: SizeUtils.height(context) * 0.03),
              // Description
              Text(
                'Connect all your bank accounts and cards in one place. Get a complete view of your financial health and make informed decisions.',
                style: AppTextStyles.body1.copyWith(
                  color: AppColors.grey,
                  fontWeight: FontWeight.normal,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              // Get Started Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignInPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.main,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Get Started',
                    style: AppTextStyles.body1.copyWith(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              SizedBox(height: SizeUtils.height(context) * 0.02),
              // Skip Button
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const SignInPage()),
                  );
                },
                child: Text(
                  'Skip',
                  style: AppTextStyles.body1.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              SizedBox(height: SizeUtils.height(context) * 0.04),
            ],
          ),
        ),
      ),
    );
  }
}
