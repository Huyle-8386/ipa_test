import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';

class ChatBubbleBot extends StatelessWidget {
  final String message;
  final double h;
  final double w;

  const ChatBubbleBot({
    super.key,
    required this.message,
    required this.h,
    required this.w,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: h * 0.025),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar AI
          CircleAvatar(
            radius: w * 0.045,
            backgroundColor: AppColors.widget,
            child: Padding(
              padding: EdgeInsets.all(w * 0.015),
              child: Image.asset('assets/icons/AI_logo.png'),
            ),
          ),

          SizedBox(width: w * 0.03),

          Flexible(
            child: Container(
              padding: EdgeInsets.all(w * 0.04),
              decoration: BoxDecoration(
                color: const Color(0xFF0A0A0A),
                borderRadius: BorderRadius.circular(w * 0.03),
              ),
              child: Text(
                message,
                style: AppTextStyles.body2.copyWith(
                  color: AppColors.white,
                  fontSize: w * 0.035,
                  height: 1.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
