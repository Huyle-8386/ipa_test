// Widget cho danh sách chi tiêu
import 'package:fintrack/core/theme/app_text_styles.dart';
import 'package:fintrack/features/expenses/domain/entities/expense_entity.dart';
import 'package:flutter/material.dart';
import 'package:fintrack/core/theme/app_colors.dart';

// Chấp nhận danh sách chi tiêu từ bên ngoài thay vì sử dụng danh sách tĩnh
Widget buildExpenseList(
  List<ExpenseEntity> expenseItems,
  double totalValue,
  Map<String, double> previousSums,
) {
  return Column(
    children: expenseItems
        .map(
          (expense) => buildExpenseListItem(expense, totalValue, previousSums),
        )
        .toList(),
  );
}

// Widget cho một mục trong danh sách
// Đổi thành public để có thể gọi từ bên ngoài
Widget buildExpenseListItem(
  ExpenseEntity expense,
  double totalValue,
  Map<String, double> previousSums,
) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12.0),
    child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.widget, // Màu nền của toàn bộ item
        borderRadius: BorderRadius.circular(10),
        // Thêm đổ bóng nhẹ để nổi bật item hơn
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
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
              color: _getCategoryColor(expense.categoryName).withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: expense.categoryIcon != null
                ? Image.asset(
                    expense.categoryIcon!,
                    fit: BoxFit.contain,
                    errorBuilder: (c, e, s) => Icon(
                      _getCategoryIcon(expense.categoryName),
                      color: _getCategoryColor(expense.categoryName),
                    ),
                  )
                : Icon(
                    _getCategoryIcon(expense.categoryName),
                    color: _getCategoryColor(expense.categoryName),
                  ),
          ),
          const SizedBox(width: 12),
          Expanded(
            // Sử dụng Expanded để tránh overflow text
            flex: 2,
            child: Text(
              expense.categoryName,
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
                  expense.formattedAmount,
                  style: TextStyle(
                    color: expense.isIncome ? AppColors.main : AppColors.white,
                    fontSize: AppTextStyles.body1.fontSize,
                    fontWeight: AppTextStyles.body1.fontWeight,
                  ),
                ),
                const SizedBox(height: 4),
                // Show only percentage change vs previous period
                Builder(
                  builder: (context) {
                    // previous amount for this category
                    final prevAmount = previousSums[expense.categoryId] ?? 0.0;

                    // If previous missing or zero, display 100% and up arrow
                    if (prevAmount <= 0) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '100%',
                            style: TextStyle(
                              color: AppColors.main,
                              fontSize: AppTextStyles.caption.fontSize,
                            ),
                          ),
                          SizedBox(width: 6),
                          Icon(
                            Icons.arrow_upward,
                            color: AppColors.main,
                            size: AppTextStyles.caption.fontSize,
                          ),
                        ],
                      );
                    }

                    final changePercent =
                        ((expense.amount - prevAmount) / prevAmount) * 100;
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
                            color: isUp
                                ? AppColors.main
                                : AppColors.brightOrange,
                            fontSize: AppTextStyles.caption.fontSize,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Icon(
                          isUp ? Icons.arrow_upward : Icons.arrow_downward,
                          color: isUp ? AppColors.main : AppColors.brightOrange,
                          size: AppTextStyles.caption.fontSize,
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
  if (category.contains('food')) return AppColors.red;
  if (category.contains('taxi') || category.contains('transport'))
    return AppColors.blue;
  if (category.contains('shopping')) return AppColors.orange;
  if (category.contains('transfer') || category.contains('salary'))
    return AppColors.green;
  if (category.contains('entertainment')) return AppColors.purple;
  if (category.contains('health')) return Colors.pink;
  if (category.contains('education')) return Colors.teal;
  return AppColors.grey;
}

// Thêm widget mới để hiển thị khi danh sách trống
Widget buildEmptyExpenseList() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.search_off, color: AppColors.grey, size: 50),
        const SizedBox(height: 16),
        Text(
          "Không tìm thấy khoản chi tiêu nào",
          style: TextStyle(
            color: AppColors.grey,
            fontSize: AppTextStyles.body1.fontSize,
          ),
        ),
      ],
    ),
  );
}
