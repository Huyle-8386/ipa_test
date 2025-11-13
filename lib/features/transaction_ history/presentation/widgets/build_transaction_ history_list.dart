import 'package:fintrack/core/theme/app_colors.dart';
import 'package:fintrack/core/utils/size_utils.dart';
import 'package:fintrack/features/transaction_%20history/data/datasources/transaction_%20history_data.dart';
import 'package:flutter/material.dart';

Widget buildTransactionHistoryList(
  BuildContext context,

  Map<String, List<TransactionData>> groupedTransactions,
) {
  final h = SizeUtils.height(context);
  final w = SizeUtils.width(context);
  return ListView.builder(
    itemCount: groupedTransactions.length,
    itemBuilder: (context, index) {
      final dateKey = groupedTransactions.keys.elementAt(index);
      final transactionsForDate = groupedTransactions[dateKey]!;

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
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
  TransactionData transaction,
  double h,
  double w,
  bool isLast,
) {
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
          // Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(12.0),
            child: Image.asset(
              transaction.icon,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.receipt, color: Colors.grey, size: 24);
              },
            ),
          ),
          SizedBox(width: w * 0.03),

          // Name and category
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.name,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  transaction.category,
                  style: TextStyle(color: AppColors.grey, fontSize: 13),
                ),
              ],
            ),
          ),

          // Amount and time
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                transaction.amount,
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                transaction.time,
                style: TextStyle(color: AppColors.grey, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
