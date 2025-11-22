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
      height: h * 0.15,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => SizedBox(width: w * 0.03),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = state.addCategory == category.id;

          return GestureDetector(
            behavior: HitTestBehavior.opaque, // <<<<<< BẮT BUỘC
            onTap: () {
              // print(">> TAP category.id=${category.id}, name=${category.name}");
              context.read<BudgetBloc>().add(AddCategoryChanged(category.id));
            },
            child: Container(
              width: w * 0.22, // <<<<<< BẮT BUỘC
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.widget,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? AppColors.main : AppColors.grey,
                  width: 1,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min, // <<<<<< BẮT BUỘC
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 36, // << fixed size icon
                    child: Image.asset(category.icon, fit: BoxFit.contain),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    category.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.body2.copyWith(
                      color: isSelected ? AppColors.main : AppColors.white,
                      fontSize: 14,
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
