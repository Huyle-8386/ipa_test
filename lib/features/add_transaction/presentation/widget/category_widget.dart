import 'package:fintrack/core/theme/app_colors.dart';
import 'package:fintrack/core/theme/app_text_styles.dart';
import 'package:fintrack/core/utils/size_utils.dart';
import 'package:fintrack/features/add_transaction/data/datasource/category.dart';
import 'package:fintrack/features/add_transaction/domain/entities/category_entity.dart';
import 'package:flutter/material.dart';

class CategoryWidget extends StatelessWidget {
  final CategoryEntity category;
  final bool selected;

  const CategoryWidget({super.key, required this.category,this.selected = false,});

  @override
  Widget build(BuildContext context) {
    
    
    final h = SizeUtils.height(context);
    final w = SizeUtils.width(context);
    return Container(
      height: h * 0.08,
      width: w * 0.25,
      decoration: BoxDecoration(
        // color: AppColors.main,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: selected ? AppColors.main : AppColors.grey,
          width: 1
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(category.icon),
          Text(
            category.name,
            style: AppTextStyles.caption.copyWith(color: AppColors.white),
          ),
        ],
      ),
    );
  }
}
