import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fintrack/features/transaction_%20history/domain/entities/transaction_entity.dart';

class TransactionModel extends TransactionEntity {
  const TransactionModel({
    super.id,
    required super.categoryId,
    required super.categoryName,
    super.categoryIcon,
    required super.moneySourceName,
    required super.note,
    required super.amount,
    required super.dateTime,
    required super.isIncome,
  });

  // Factory từ Firestore document
  factory TransactionModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return TransactionModel(
      id: doc.id,
      categoryId: data['categoryId'] as String? ?? '',
      categoryName: data['categoryName'] as String? ?? '',
      categoryIcon: data['categoryIcon'] as String?, // Có thể null
      moneySourceName: data['moneySourceName'] as String? ?? '',
      note: data['note'] as String? ?? '',
      amount: (data['amount'] as num?)?.toDouble() ?? 0.0,
      dateTime: (data['dateTime'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isIncome: data['isIncome'] as bool? ?? false,
    );
  }

  // Factory với categoryIcon từ JOIN
  factory TransactionModel.fromFirestoreWithIcon(
    DocumentSnapshot doc,
    String? categoryIcon,
  ) {
    final data = doc.data() as Map<String, dynamic>;

    return TransactionModel(
      id: doc.id,
      categoryId: data['categoryId'] as String? ?? '',
      categoryName: data['categoryName'] as String? ?? '',
      categoryIcon: categoryIcon, // Icon từ categories collection
      moneySourceName: data['moneySourceName'] as String? ?? '',
      note: data['note'] as String? ?? '',
      amount: (data['amount'] as num?)?.toDouble() ?? 0.0,
      dateTime: (data['dateTime'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isIncome: data['isIncome'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'categoryName': categoryName,
    'moneySourceName': moneySourceName,
    'note': note,
    'amount': amount,
    'dateTime': Timestamp.fromDate(dateTime),
    'isIncome': isIncome,
  };
}
