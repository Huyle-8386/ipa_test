import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fintrack/core/theme/app_colors.dart';
import 'package:fintrack/core/utils/size_utils.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../domain/entities/category_entity.dart';
import '../../../bloc/budget_bloc.dart';
import '../../../bloc/budget_event.dart';

class CategorySelector extends StatelessWidget {
  final List<CategoryEntity> categories;

  const CategorySelector({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    final h = SizeUtils.height(context);
    final w = SizeUtils.width(context);
    final state = context.watch<BudgetBloc>().state;

    return SizedBox(
      height: h * 0.16, // tăng nhẹ để icon + text không bị chạm mép
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(), // 🔥 fix không kéo được
        padding: EdgeInsets.symmetric(horizontal: w * 0.02),
        itemCount: categories.length,
        separatorBuilder: (_, __) => SizedBox(width: w * 0.03),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = state.addCategory == category.id;

          return GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              context.read<BudgetBloc>().add(AddCategoryChanged(category.id));
            },
            child: Container(
              width: w * 0.24, // responsive width
              padding: EdgeInsets.symmetric(
                horizontal: w * 0.03,
                vertical: h * 0.015,
              ),
              decoration: BoxDecoration(
                color: AppColors.widget,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? AppColors.main : AppColors.grey,
                  width: 1.2,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: h * 0.05, // icon responsive
                    child: Image.asset(category.icon, fit: BoxFit.contain),
                  ),
                  SizedBox(height: h * 0.01),

                  // tên category
                  Text(
                    category.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.body2.copyWith(
                      fontSize: w * 0.035,
                      color: isSelected ? AppColors.main : AppColors.white,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
