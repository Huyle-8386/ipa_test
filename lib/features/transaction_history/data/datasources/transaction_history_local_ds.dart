// import 'package:fintrack/features/transaction_%20history/data/models/transaction_model.dart';
// import 'package:fintrack/features/transaction_%20history/domain/entities/transaction_entity.dart';
// import 'package:flutter/material.dart';

// abstract class TransactionHistoryLocalDataSource {
//   Future<List<TransactionModel>> getTransactions();
//   Future<List<TransactionModel>> getTransactionsByType(TransactionType type);
//   Future<List<TransactionModel>> searchTransactions(
//     String query, {
//     TransactionType type = TransactionType.all,
//   });
//   Future<List<String>> getFilterTypes();
// }

// class TransactionHistoryLocalDataSourceImpl
//     implements TransactionHistoryLocalDataSource {
//   final List<TransactionModel> _transactions = [
//     // 2 July 2025
//     TransactionModel(
//       icon: 'assets/icons/taxi.png',
//       color: Colors.blue,
//       category: 'Taxi',
//       note: 'Uber',
//       value: -15.00,
//       amount: '-\$15',
//       date: DateTime(2025, 7, 2),
//       time: '8:25 pm',
//       type: TransactionType.spending,
//     ),
//     TransactionModel(
//       icon: 'assets/icons/transfer.png',
//       color: Colors.green,
//       category: 'Transfer',
//       note: 'Agribank',
//       value: 550.00,
//       amount: '+\$550',
//       date: DateTime(2025, 7, 2),
//       time: '9:45 pm',
//       type: TransactionType.income,
//     ),
//     TransactionModel(
//       icon: 'assets/icons/food.png',
//       color: Colors.red,
//       category: 'Food',
//       note: 'Starbucks',
//       value: -17.00,
//       amount: '-\$17',
//       date: DateTime(2025, 7, 2),
//       time: '9:50 pm',
//       type: TransactionType.spending,
//     ),
//     TransactionModel(
//       icon: 'assets/icons/food.png',
//       color: Colors.red,
//       category: 'Food',
//       note: 'Highland',
//       value: -15.00,
//       amount: '-\$15',
//       date: DateTime(2025, 7, 2),
//       time: '8:50 pm',
//       type: TransactionType.spending,
//     ),
//     // 1 July 2025
//     TransactionModel(
//       icon: 'assets/icons/shopping.png',
//       color: Colors.orange,
//       category: 'Shopping',
//       note: 'Bravo',
//       value: -46.00,
//       amount: '-\$46',
//       date: DateTime(2025, 7, 1),
//       time: '8:25 pm',
//       type: TransactionType.spending,
//     ),
//     // 14 June 2025
//     TransactionModel(
//       icon: 'assets/icons/taxi.png',
//       color: Colors.blue,
//       category: 'Taxi',
//       note: 'Uber',
//       value: -12.00,
//       amount: '-\$12',
//       date: DateTime(2025, 6, 14),
//       time: '9:45 pm',
//       type: TransactionType.spending,
//     ),
//   ];

//   @override
//   Future<List<TransactionModel>> getTransactions() async {
//     await Future.delayed(const Duration(milliseconds: 200));
//     return List.unmodifiable(_transactions);
//   }

//   @override
//   Future<List<TransactionModel>> getTransactionsByType(
//     TransactionType type,
//   ) async {
//     final all = await getTransactions();
//     if (type == TransactionType.all) return all;
//     return all.where((t) => t.type == type).toList();
//   }

//   @override
//   Future<List<TransactionModel>> searchTransactions(
//     String query, {
//     TransactionType type = TransactionType.all,
//   }) async {
//     final filtered = await getTransactionsByType(type);
//     final q = query.toLowerCase();
//     return filtered.where((t) {
//       final category = t.category.toLowerCase();
//       final note = t.note.toLowerCase();
//       return category.contains(q) || note.contains(q);
//     }).toList();
//   }

//   @override
//   Future<List<String>> getFilterTypes() async {
//     return const ['All', 'Spending', 'Income'];
//   }
// }
