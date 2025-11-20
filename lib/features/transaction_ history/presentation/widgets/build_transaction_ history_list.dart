import 'package:fintrack/core/theme/app_colors.dart';
import 'package:fintrack/core/theme/app_text_styles.dart';
import 'package:fintrack/core/utils/size_utils.dart';
import 'package:fintrack/features/transaction_%20history/domain/entities/transaction_entity.dart';
import 'package:flutter/material.dart';

Widget buildTransactionHistoryList(
  BuildContext context,

  Map<String, List<TransactionEntity>> groupedTransactions,
) {
  final h = SizeUtils.height(context);
  final w = SizeUtils.width(context);
  return ListView.builder(
    itemCount: groupedTransactions.length,
    itemBuilder: (context, index) {
      final dateKey = groupedTransactions.keys.elementAt(index);
      final transactionsForDate = groupedTransactions[dateKey]!;

      return Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          color: AppColors.widget,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Text(
                    dateKey,
                    style: TextStyle(
                      color: AppColors.grey,
                      fontSize: AppTextStyles.caption.fontSize,
                      fontWeight: AppTextStyles.body2.fontWeight,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      height: 1,
                      color: AppColors.grey.withOpacity(0.3),
                    ),
                  ),
                ],
              ),
            ),

            // Transactions for this date
            ...transactionsForDate.asMap().entries.map((entry) {
              final idx = entry.key;
              final transaction = entry.value;
              final isLast = idx == transactionsForDate.length - 1;
              return _buildTransactionItem(transaction, h, w, isLast);
            }).toList(),
          ],
        ),
      );
    },
  );
}

Widget _buildTransactionItem(
  TransactionEntity transaction,
  double h,
  double w,
  bool isLast,
) {
  // Lấy icon và màu dựa vào categoryName (fallback nếu không có categoryIcon)
  final categoryIcon = _getCategoryIcon(transaction.categoryIcon ?? '');
  final categoryColor = _getCategoryColor(transaction.categoryName);

  return Container(
    decoration: BoxDecoration(
      border: !isLast
          ? Border(
              bottom: BorderSide(
                color: AppColors.grey.withOpacity(0.3),
                width: 1,
              ),
            )
          : null,
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        children: [
          // Icon with dynamic color
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              // color: categoryColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: transaction.categoryIcon != null
                ? Image.asset(
                    transaction.categoryIcon!,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(categoryIcon, color: categoryColor, size: 28);
                    },
                  )
                : Icon(categoryIcon, color: categoryColor, size: 28),
          ),
          SizedBox(width: w * 0.03),

          // Name and category
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.categoryName,
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: AppTextStyles.body2.fontSize,
                    fontWeight: AppTextStyles.body2.fontWeight,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  transaction.note,
                  style: TextStyle(
                    color: AppColors.grey,
                    fontSize: AppTextStyles.caption.fontSize,
                  ),
                ),
              ],
            ),
          ),

          // Amount and time
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                transaction.formattedAmount,
                style: TextStyle(
                  color: transaction.isIncome ? AppColors.green : AppColors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                transaction.formattedTime,
                style: TextStyle(color: AppColors.grey, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

// Helper để lấy icon dựa vào category
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
  return Icons.receipt; // default
}

// Helper để lấy màu dựa vào category
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
  return AppColors.grey; // default
}
