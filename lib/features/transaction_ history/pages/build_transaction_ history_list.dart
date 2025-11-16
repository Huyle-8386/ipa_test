import 'package:fintrack/features/transaction_ history/datasources/transaction_ history_data.dart';
import 'package:flutter/material.dart';

Widget buildTransactionHistoryList(
  Map<String, List<TransactionData>> groupedTransactions,
) {
  return ListView.builder(
    itemCount: groupedTransactions.length,
    itemBuilder: (context, index) {
      final dateKey = groupedTransactions.keys.elementAt(index);
      final transactionsForDate = groupedTransactions[dateKey]!;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date header
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Text(
              dateKey,
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // Transactions for this date
          ...transactionsForDate
              .map((transaction) => _buildTransactionItem(transaction))
              .toList(),
        ],
      );
    },
  );
}

Widget _buildTransactionItem(TransactionData transaction) {
  final isIncome = transaction.type == TransactionType.income;

  return Padding(
    padding: const EdgeInsets.only(bottom: 12.0),
    child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2C),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: transaction.color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getIconData(transaction.name),
              color: transaction.color,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),

          // Name and category
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  transaction.category,
                  style: TextStyle(color: Colors.grey[400], fontSize: 14),
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
                  color: isIncome ? Colors.greenAccent : Colors.redAccent,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                transaction.time,
                style: TextStyle(color: Colors.grey[400], fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

IconData _getIconData(String name) {
  switch (name.toLowerCase()) {
    case 'taxi':
      return Icons.local_taxi;
    case 'transfer':
      return Icons.swap_horiz;
    case 'food':
      return Icons.restaurant;
    case 'shopping':
      return Icons.shopping_bag;
    default:
      return Icons.receipt;
  }
}
