import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fintrack/features/add_transaction/domain/entities/transaction_entity.dart';

class TransactionModel {
  final String? id;
  final double amount;
  final DateTime dateTime;
  final String merchant;
  final String categoryId;
  final String categoryName;
  final String categoryIcon;
  final String moneySourceId;
  final String moneySourceName;
  final bool isIncome;

  TransactionModel({
    this.id,
    required this.amount,
    required this.dateTime,
    required this.merchant,
    required this.categoryId,
    required this.categoryName,
    required this.categoryIcon,
    required this.moneySourceId,
    required this.moneySourceName,
    required this.isIncome,
  });

  factory TransactionModel.fromEntity(TransactionEntity e) {
    return TransactionModel(
      id: e.id,
      amount: e.amount,
      dateTime: e.dateTime,
      merchant: e.merchant,
      categoryId: e.category.id,
      categoryName: e.category.name,
      categoryIcon: e.category.icon, // ← Lấy icon từ category
      moneySourceId: e.moneySource.id,
      moneySourceName: e.moneySource.name,
      isIncome: e.isIncome,
    );
  }

  factory TransactionModel.fromFirestore(DocumentSnapshot doc) {
    final data = (doc.data() as Map<String, dynamic>?) ?? <String, dynamic>{};
    return TransactionModel(
      id: doc.id,
      amount: (data['amount'] as num?)?.toDouble() ?? 0,
      dateTime: (data['dateTime'] as Timestamp?)?.toDate() ?? DateTime.now(),
      merchant: (data['merchant'] as String?) ?? '',
      categoryId: data['categoryId'] as String? ?? '',
      categoryName: data['categoryName'] as String? ?? '',
      categoryIcon: data['categoryIcon'] as String? ?? '',
      moneySourceId: data['moneySourceId'] as String? ?? '',
      moneySourceName: data['moneySourceName'] as String? ?? '',
      isIncome: data['isIncome'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson({String? uid}) {
    return {
      'amount': amount,
      'dateTime': Timestamp.fromDate(dateTime),
      'merchant': merchant,
      'isIncome': isIncome,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'categoryIcon': categoryIcon, // ← Lưu icon vào Firestore
      'moneySourceId': moneySourceId,
      'moneySourceName': moneySourceName,
      // if (uid != null) 'uid': uid,
    };
  }
}
