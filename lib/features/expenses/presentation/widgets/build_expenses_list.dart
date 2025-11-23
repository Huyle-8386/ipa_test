// Widget cho danh sách chi tiêu
import 'package:fintrack/features/expenses/domain/entities/expense_entity.dart';
import 'package:flutter/material.dart';
import 'package:fintrack/core/theme/app_colors.dart';

// Chấp nhận danh sách chi tiêu từ bên ngoài thay vì sử dụng danh sách tĩnh
Widget buildExpenseList(List<ExpenseEntity> expenseItems) {
  return Column(
    children: expenseItems
        .map((expense) => buildExpenseListItem(expense))
        .toList(),
  );
}

// Widget cho một mục trong danh sách
// Đổi thành public để có thể gọi từ bên ngoài
Widget buildExpenseListItem(ExpenseEntity expense) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12.0),
    child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF212121), // Màu nền của toàn bộ item
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
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
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
                    color: expense.isIncome ? AppColors.main : Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                // We no longer show percentage/isUp. If you want an indicator, derive from previous totals at the page level.
                const SizedBox.shrink(),
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
Widget buildEmptyExpenseList() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.search_off, color: Colors.grey, size: 50),
        const SizedBox(height: 16),
        Text(
          "Không tìm thấy khoản chi tiêu nào",
          style: TextStyle(color: Colors.grey[400], fontSize: 16),
        ),
      ],
    ),
  );
}
