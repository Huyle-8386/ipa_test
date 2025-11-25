// Widget cho danh sách thu nhập
import 'package:fintrack/core/theme/app_text_styles.dart';
import 'package:fintrack/features/income/domain/entities/income_entity.dart';
import 'package:flutter/material.dart';
import 'package:fintrack/core/theme/app_colors.dart';

// Chấp nhận danh sách từ bên ngoài cùng total và previousSums
Widget buildIncomeList(
  List<IncomeEntity> incomeItems,
  double totalValue,
  Map<String, double> previousSums,
) {
  return Column(
    children: incomeItems
        .map((income) => buildIncomeListItem(income, totalValue, previousSums))
        .toList(),
  );
}

// Widget cho một mục trong danh sách
Widget buildIncomeListItem(
  IncomeEntity income,
  double totalValue,
  Map<String, double> previousSums,
) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12.0),
    child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.widget,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              color: _getCategoryColor(income.categoryName).withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: income.categoryIcon != null
                ? Image.asset(
                    income.categoryIcon!,
                    fit: BoxFit.contain,
                    errorBuilder: (c, e, s) => Icon(
                      _getCategoryIcon(income.categoryName),
                      color: _getCategoryColor(income.categoryName),
                    ),
                  )
                : Icon(
                    _getCategoryIcon(income.categoryName),
                    color: _getCategoryColor(income.categoryName),
                  ),
          ),
          const SizedBox(width: 12),
          Expanded(
            // Sử dụng Expanded để tránh overflow text
            flex: 2,
            child: Text(
              income.categoryName,
              style: TextStyle(
                color: AppColors.white,
                fontSize: AppTextStyles.body1.fontSize,
                fontWeight: AppTextStyles.body1.fontWeight,
              ),
              overflow: TextOverflow.ellipsis, // Xử lý tràn text
            ),
          ),
          Expanded(
            // Sử dụng Expanded cho phần bên phải
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  income.formattedAmount,
                  style: TextStyle(
                    color: income.isIncome ? AppColors.white : AppColors.white,
                    fontSize: AppTextStyles.body1.fontSize,
                    fontWeight: AppTextStyles.body1.fontWeight,
                  ),
                ),
                const SizedBox(height: 4),
                // Show percentage change vs previous period
                Builder(
                  builder: (context) {
                    // previous amount for this category
                    final prevAmount = previousSums[income.categoryId] ?? 0.0;

                    // If previous missing or zero, display 100% and up arrow
                    if (prevAmount <= 0) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '100%',
                            style: TextStyle(
                              color: AppColors.main,
                              fontSize: AppTextStyles.body2.fontSize,
                            ),
                          ),
                          SizedBox(width: 6),
                          Icon(
                            Icons.arrow_upward,
                            color: AppColors.main,
                            size: AppTextStyles.body2.fontSize,
                          ),
                        ],
                      );
                    }

                    final changePercent =
                        ((income.amount - prevAmount) / prevAmount) * 100;
                    final isUp = changePercent >= 0;
                    final display = (changePercent.abs() >= 1)
                        ? '${changePercent.abs().toStringAsFixed(0)}%'
                        : '${changePercent.abs().toStringAsFixed(1)}%';

                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          display,
                          style: TextStyle(
                            color: isUp ? AppColors.white : AppColors.red,
                            fontSize: AppTextStyles.body2.fontSize,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Icon(
                          isUp ? Icons.arrow_upward : Icons.arrow_downward,
                          color: isUp ? Colors.greenAccent : Colors.redAccent,
                          size: 14,
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

// Icon mapping similar to transaction history
IconData _getCategoryIcon(String categoryName) {
  final category = categoryName.toLowerCase();
  if (category.contains('food')) return Icons.restaurant;
  if (category.contains('taxi') || category.contains('transport'))
    return Icons.local_taxi;
  if (category.contains('shopping')) return Icons.shopping_bag;
  if (category.contains('transfer')) return Icons.swap_horiz;
  if (category.contains('salary')) return Icons.attach_money;
  if (category.contains('entertainment')) return Icons.movie;
  if (category.contains('health')) return Icons.local_hospital;
  if (category.contains('education')) return Icons.school;
  return Icons.receipt;
}

Color _getCategoryColor(String categoryName) {
  final category = categoryName.toLowerCase();
  if (category.contains('food')) return Colors.red;
  if (category.contains('taxi') || category.contains('transport'))
    return Colors.blue;
  if (category.contains('shopping')) return Colors.orange;
  if (category.contains('transfer') || category.contains('salary'))
    return Colors.green;
  if (category.contains('entertainment')) return Colors.purple;
  if (category.contains('health')) return Colors.pink;
  if (category.contains('education')) return Colors.teal;
  return AppColors.grey;
}

// Thêm widget mới để hiển thị khi danh sách trống
Widget buildEmptyIncomeList() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.search_off, color: Colors.grey, size: 50),
        const SizedBox(height: 16),
        Text(
          "No income found",
          style: TextStyle(color: Colors.grey[400], fontSize: 16),
        ),
      ],
    ),
  );
}
