import 'package:fintrack/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class BottomNavItem extends StatelessWidget {
  final String iconName;
  // final String label;
  final bool isActive;
  final VoidCallback onTapItem;

  const BottomNavItem({
    super.key,
    required this.iconName,
    required this.isActive,
    required this.onTapItem,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapItem,
      child: Column(
        children: [
          Image.asset(
            iconName,
            color: isActive ? AppColors.main : AppColors.white,
          ),
        ],
      ),
    );
  }
}
