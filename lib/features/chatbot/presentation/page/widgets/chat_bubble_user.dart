import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';

class ChatBubbleUser extends StatelessWidget {
  final String message;
  final double h;
  final double w;

  const ChatBubbleUser({
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
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Text bubble
          Flexible(
            child: Container(
              padding: EdgeInsets.all(w * 0.04),
              decoration: BoxDecoration(
                color: AppColors.widget,
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

          SizedBox(width: w * 0.03),

          // Avatar user
          CircleAvatar(
            radius: w * 0.045,
            backgroundColor: AppColors.widget,
            child: ClipOval(
              child: Image.asset(
                'assets/icons/avatar_logo.png',
                width: w * 0.09,
                height: w * 0.09,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
