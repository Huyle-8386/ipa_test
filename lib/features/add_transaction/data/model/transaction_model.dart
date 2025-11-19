import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fintrack/features/add_transaction/domain/entities/category_entity.dart';
import 'package:fintrack/features/add_transaction/domain/entities/money_source_entity.dart';
import 'package:fintrack/features/add_transaction/domain/entities/transaction_entity.dart';

class TransactionModel extends TransactionEntity {
  const TransactionModel({
    String? id,
    required double amount,
    required DateTime dateTime,
    required String note,
    required CategoryEntity category,
    required MoneySourceEntity moneySource,
    required bool isIncome,
  }) : super(
          id: id,
          amount: amount,
          dateTime: dateTime,
          note: note,
          category: category,
          moneySource: moneySource,
          isIncome: isIncome,
        );

  /// map từ Entity => Map lưu Firestore
  Map<String, dynamic> toJson({String? uid}) {
    return {
      'amount': amount,
      'dateTime': Timestamp.fromDate(dateTime),
      'note': note,
      'isIncome': isIncome,
      'categoryId': category.id,
      'categoryName': category.name,
      'moneySourceId': moneySource.id,
      'moneySourceName': moneySource.name,
      if (uid != null) 'uid': uid, // nếu muốn multi-user
    };
  }

  /// nếu sau này cần đọc lại từ Firestore
  factory TransactionModel.fromJson(
    Map<String, dynamic> json,
    String docId,
  ) {
    final ts = json['dateTime'] as Timestamp;
    return TransactionModel(
      id: docId,
      amount: (json['amount'] as num).toDouble(),
      dateTime: ts.toDate(),
      note: json['note'] ?? '',
      isIncome: json['isIncome'] ?? false,
      category: CategoryEntity(
        id: json['categoryId'] ?? '',
        name: json['categoryName'] ?? '',
        icon: '', // nếu muốn có icon thì map thêm
        isIncome: json['isIncome'] ?? false,
      ),
      moneySource: MoneySourceEntity(
        id: json['moneySourceId'] ?? '',
        name: json['moneySourceName'] ?? '',
        icon: '',
      ),
    );
  }

  factory TransactionModel.fromEntity(TransactionEntity e) {
    return TransactionModel(
      id: e.id,
      amount: e.amount,
      dateTime: e.dateTime,
      note: e.note,
      category: e.category,
      moneySource: e.moneySource,
      isIncome: e.isIncome,
    );
  }
}
