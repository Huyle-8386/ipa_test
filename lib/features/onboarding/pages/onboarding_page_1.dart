import 'package:fintrack/core/theme/app_colors.dart';
import 'package:fintrack/core/theme/app_text_styles.dart';
import 'package:fintrack/core/utils/size_utils.dart';
import 'package:fintrack/features/onboarding/pages/onboarding_page_2.dart';
import 'package:fintrack/features/auth/pages/sign_in_page.dart';
import 'package:flutter/material.dart';

class OnboardingPage1 extends StatelessWidget {
  const OnboardingPage1({super.key});

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
              SizedBox(height: SizeUtils.height(context) * 0.15),
              // Title
              Text(
                'Take Control of Your Finances',
                style: AppTextStyles.heading1.copyWith(
                  color: AppColors.main,
                  fontSize: 32,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: SizeUtils.height(context) * 0.03),
              // Description
              Text(
                'Track your spending, set budgets, and achieve your financial goals with our intuitive and powerful finance management app.',
                style: AppTextStyles.body1.copyWith(
                  color: AppColors.grey,
                  fontWeight: FontWeight.normal,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              // Next Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const OnboardingPage2(),
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
                    'Next',
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
