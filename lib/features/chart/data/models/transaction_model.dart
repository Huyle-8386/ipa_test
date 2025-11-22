import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/transaction_entity.dart';

class TransactionModel extends TransactionEntity {
  TransactionModel({
    required super.id,
    required super.amount,
    required super.categoryId,
    required super.categoryName,
    required super.moneySourceId,
    required super.moneySourceName,
    required super.note,
    required super.dateTime,
    required super.isIncome,
  });

  factory TransactionModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return TransactionModel(
      id: doc.id,
      amount: (data['amount'] ?? 0).toDouble(),
      categoryId: data['categoryId'] ?? '',
      categoryName: data['categoryName'] ?? '',
      moneySourceId: data['moneySourceId'] ?? '',
      moneySourceName: data['moneySourceName'] ?? '',
      note: data['note'] ?? '',
      isIncome: data['isIncome'] ?? false,
      dateTime: (data['dateTime'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() => {
    'amount': amount,
    'categoryId': categoryId,
    'categoryName': categoryName,
    'moneySourceId': moneySourceId,
    'moneySourceName': moneySourceName,
    'note': note,
    'isIncome': isIncome,
    'dateTime': dateTime,
  };
}
