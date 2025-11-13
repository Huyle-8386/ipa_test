import 'package:flutter/material.dart';

class TransactionData {
  final String icon;
  final Color color;
  final String name;
  final String category; // Ví dụ: Uber, Starbucks, Highland, etc.
  final double value;
  final String amount;
  final DateTime date;
  final String time;
  final TransactionType type; // Income hoặc Spending

  TransactionData({
    required this.icon,
    required this.color,
    required this.name,
    required this.category,
    required this.value,
    required this.amount,
    required this.date,
    required this.time,
    required this.type,
  });
}

enum TransactionType { spending, income, all }

final List<TransactionData> transactions = [
  // 2 July 2025
  TransactionData(
    icon: 'assets/icons/taxi.png',
    color: Colors.blue,
    name: "Taxi",
    category: "Uber",
    value: -15.00,
    amount: "-\$15",
    date: DateTime(2025, 7, 2),
    time: "8:25 pm",
    type: TransactionType.spending,
  ),
  TransactionData(
    icon: 'assets/icons/transfer.png',
    color: Colors.green,
    name: "Transfer",
    category: "Agribank",
    value: 550.00,
    amount: "+\$550",
    date: DateTime(2025, 7, 2),
    time: "9:45 pm",
    type: TransactionType.income,
  ),
  TransactionData(
    icon: 'assets/icons/food.png',
    color: Colors.red,
    name: "Food",
    category: "Starbucks",
    value: -17.00,
    amount: "-\$17",
    date: DateTime(2025, 7, 2),
    time: "9:50 pm",
    type: TransactionType.spending,
  ),
  TransactionData(
    icon: 'assets/icons/food.png',
    color: Colors.red,
    name: "Food",
    category: "Highland",
    value: -15.00,
    amount: "-\$15",
    date: DateTime(2025, 7, 2),
    time: "8:50 pm",
    type: TransactionType.spending,
  ),

  // 1 July 2025
  TransactionData(
    icon: 'assets/icons/shopping.png',
    color: Colors.orange,
    name: "Shopping",
    category: "Bravo",
    value: -46.00,
    amount: "-\$46",
    date: DateTime(2025, 7, 1),
    time: "8:25 pm",
    type: TransactionType.spending,
  ),

  // 14 June 2025
  TransactionData(
    icon: 'assets/icons/taxi.png',
    color: Colors.blue,
    name: "Taxi",
    category: "Uber",
    value: -12.00,
    amount: "-\$12",
    date: DateTime(2025, 6, 14),
    time: "9:45 pm",
    type: TransactionType.spending,
  ),
];

// Hàm nhóm giao dịch theo ngày
Map<String, List<TransactionData>> groupTransactionsByDate(
  List<TransactionData> transactions,
) {
  Map<String, List<TransactionData>> grouped = {};

  for (var transaction in transactions) {
    String dateKey = _formatDate(transaction.date);
    if (!grouped.containsKey(dateKey)) {
      grouped[dateKey] = [];
    }
    grouped[dateKey]!.add(transaction);
  }

  return grouped;
}

// Hàm format ngày
String _formatDate(DateTime date) {
  const months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  return '${date.day} ${months[date.month - 1]} ${date.year}';
}

// Hàm lọc giao dịch theo loại
List<TransactionData> filterTransactionsByType(
  List<TransactionData> transactions,
  TransactionType type,
) {
  if (type == TransactionType.all) {
    return transactions;
  }
  return transactions.where((t) => t.type == type).toList();
}

// Danh sách các loại filter
final List<String> filterTypes = ['All', 'Spending', 'Income'];

// Tính tổng thu nhập
double getTotalIncome(List<TransactionData> transactions) {
  return transactions
      .where((t) => t.type == TransactionType.income)
      .fold(0.0, (sum, item) => sum + item.value);
}

// Tính tổng chi tiêu
double getTotalSpending(List<TransactionData> transactions) {
  return transactions
      .where((t) => t.type == TransactionType.spending)
      .fold(0.0, (sum, item) => sum + item.value.abs());
}

// Tính số dư
double getBalance(List<TransactionData> transactions) {
  return getTotalIncome(transactions) - getTotalSpending(transactions);
}
