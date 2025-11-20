import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fintrack/features/add_transaction/domain/entities/transaction_entity.dart';

class TransactionModel {
  final String? id;
  final double amount;
  final DateTime dateTime;
  final String note;
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
    required this.note,
    required this.categoryId,
    required this.categoryName,
    required this.categoryIcon,
    required this.moneySourceId,
    required this.moneySourceName,
    required this.isIncome,
  });

  factory TransactionModel.fromEntity(TransactionEntity e) {
    return TransactionModel(
      amount: e.amount,
      dateTime: e.dateTime,
      note: e.note,
      categoryId: e.category.id,
      categoryName: e.category.name,
      categoryIcon: e.category.icon, // ← Lấy icon từ category
      moneySourceId: e.moneySource.id,
      moneySourceName: e.moneySource.name,
      isIncome: e.isIncome,
    );
  }

  Map<String, dynamic> toJson({String? uid}) {
    return {
      'amount': amount,
      'dateTime': Timestamp.fromDate(dateTime),
      'note': note,
      'isIncome': isIncome,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'categoryIcon': categoryIcon, // ← Lưu icon vào Firestore
      'moneySourceId': moneySourceId,
      'moneySourceName': moneySourceName,
      if (uid != null) 'uid': uid,
    };
  }
}
