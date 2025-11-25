import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fintrack/features/add_transaction/domain/entities/category_entity.dart';
import 'package:fintrack/features/add_transaction/domain/entities/money_source_entity.dart';
import 'package:fintrack/features/add_transaction/domain/entities/transaction_entity.dart';
import 'package:intl/intl.dart';

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

  factory TransactionModel.fromN8nJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: (json['_id'] ?? json['id']) as String?,
      amount: (json['amount'] as num?)?.toDouble() ?? 0,
      dateTime: _parseN8nDateTime(json['dateTime'] as String?),
      merchant: json['merchant'] as String? ?? '',
      categoryId: json['categoryId'] as String? ?? '',
      categoryName: json['categoryName'] as String? ?? '',
      categoryIcon: json['categoryIcon'] as String? ?? '',
      moneySourceId: json['moneySourceId'] as String? ?? '',
      moneySourceName: json['moneySourceName'] as String? ?? '',
      isIncome: json['isIncome'] as bool? ?? false,
    );
  }

  static DateTime _parseN8nDateTime(String? raw) {
    if (raw == null || raw.isEmpty) return DateTime.now();

    // Expected: "October 11, 2025 at 07:05:00 PM UTC+7"
    // Strip the timezone portion since it's not ISO-8601 friendly, then parse.
    final withoutTz = raw.split('UTC').first.trim().replaceFirst(' at ', ' ');
    try {
      return DateFormat("MMMM d, yyyy hh:mm:ss a").parse(withoutTz);
    } catch (_) {
      return DateTime.tryParse(raw) ?? DateTime.now();
    }
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

  TransactionEntity toEntity() {
    return TransactionEntity(
      id: id,
      amount: amount,
      dateTime: dateTime,
      merchant: merchant,
      category: CategoryEntity(
        id: categoryId,
        name: categoryName,
        icon: categoryIcon,
        isIncome: isIncome,
      ),
      moneySource: MoneySourceEntity(
        id: moneySourceId,
        name: moneySourceName,
        icon: '',
        balance: 0.0,
      ),
      isIncome: isIncome,
    );
  }
}
