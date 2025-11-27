import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fintrack/features/transaction_history/data/models/transaction_model.dart';
import 'package:fintrack/features/transaction_history/domain/entities/transaction_entity.dart';

abstract class TransactionHistoryRemoteDataSource {
  Future<List<TransactionModel>> getTransactions();
  Future<List<TransactionModel>> getTransactionsByType(TransactionType type);
  Future<List<TransactionModel>> searchTransactions(
    String query, {
    TransactionType type = TransactionType.all,
  });
  Future<List<String>> getFilterTypes();
}

class TransactionHistoryRemoteDataSourceImpl
    implements TransactionHistoryRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  TransactionHistoryRemoteDataSourceImpl({
    required this.firestore,
    required this.auth,
  });

  @override
  Future<List<TransactionModel>> getTransactions() async {
    final user = auth.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }

    final snapshot = await firestore
        .collection('users')
        .doc(user.uid)
        .collection('transactions')
        .orderBy('dateTime', descending: true)
        .get();

    // JOIN với categories để lấy icon
    final transactions = <TransactionModel>[];

    for (var doc in snapshot.docs) {
      final data = doc.data();
      final categoryId = data['categoryId'] as String?;

      String? categoryIcon;
      if (categoryId != null && categoryId.isNotEmpty) {
        try {
          // Fetch category document để lấy icon
          final categoryDoc = await firestore
              .collection('categories')
              .doc(categoryId)
              .get();

          if (categoryDoc.exists) {
            categoryIcon = categoryDoc.data()?['icon'] as String?;
          }
        } catch (e) {
          print('Error fetching category icon: $e');
        }
      }

      // Tạo TransactionModel với categoryIcon
      transactions.add(
        TransactionModel.fromFirestoreWithIcon(doc, categoryIcon),
      );
    }

    return transactions;
  }

  @override
  Future<List<TransactionModel>> getTransactionsByType(
    TransactionType type,
  ) async {
    if (type == TransactionType.all) {
      return getTransactions();
    }

    // Lấy tất cả rồi filter ở client-side (tránh cần composite index)
    final allTransactions = await getTransactions();
    final isIncome = type == TransactionType.income;

    return allTransactions.where((t) => t.isIncome == isIncome).toList();
  }

  @override
  Future<List<TransactionModel>> searchTransactions(
    String query, {
    TransactionType type = TransactionType.all,
  }) async {
    final filtered = await getTransactionsByType(type);
    final q = query.toLowerCase();

    return filtered.where((t) {
      final category = t.categoryName.toLowerCase();
      final merchant = t.merchant.toLowerCase();
      final moneySource = t.moneySourceName.toLowerCase();
      return category.contains(q) ||
          merchant.contains(q) ||
          moneySource.contains(q);
    }).toList();
  }

  @override
  Future<List<String>> getFilterTypes() async {
    return const ['All', 'Spending', 'Income'];
  }
}
