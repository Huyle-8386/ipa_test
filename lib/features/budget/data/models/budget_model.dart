// // lib/features/budget/data/models/budget_model.dart
// import 'package:flutter/material.dart';
// import '../../domain/entities/budget_entity.dart';

// class BudgetModel {
//   final String name;
//   final double spent;
//   final double total;
//   final bool isActive;
//   final List<double> monthlySpending;
//   final List<double> monthlyBudgetLimit;
//   final List<BudgetExpenseModel> expenses;

//   BudgetModel({
//     required this.name,
//     required this.spent,
//     required this.total,
//     required this.isActive,
//     this.monthlySpending = const [],
//     this.monthlyBudgetLimit = const [],
//     this.expenses = const [],
//   });

//   factory BudgetModel.fromEntity(BudgetEntity e) {
//     return BudgetModel(
//       name: e.name,
//       spent: e.spent,
//       total: e.total,
//       isActive: e.isActive,
//       monthlySpending: e.monthlySpending,
//       monthlyBudgetLimit: e.monthlyBudgetLimit,
//       expenses: e.expenses
//           .map(
//             (ex) => BudgetExpenseModel(
//               category: ex.category,
//               amount: ex.amount,
//               colorValue: ex.colorValue,
//             ),
//           )
//           .toList(),
//     );
//   }

//   BudgetEntity toEntity() {
//     return BudgetEntity(
//       name: name,
//       spent: spent,
//       total: total,
//       isActive: isActive,
//       monthlySpending: monthlySpending,
//       monthlyBudgetLimit: monthlyBudgetLimit,
//       expenses: expenses
//           .map(
//             (e) => BudgetExpenseEntity(
//               category: e.category,
//               amount: e.amount,
//               colorValue: e.colorValue,
//             ),
//           )
//           .toList(),
//     );
//   }
// }

// class BudgetExpenseModel {
//   final String category;
//   final double amount;
//   final int colorValue;

//   BudgetExpenseModel({
//     required this.category,
//     required this.amount,
//     required this.colorValue,
//   });
// }

// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../../domain/entities/budget_entity.dart';

// class BudgetModel extends BudgetEntity {
//   BudgetModel({
//     required super.id,
//     required super.name,
//     required super.amount,
//     required super.spent,
//     required super.categoryId,
//     required super.sourceId,
//     required super.startDate,
//     required super.endDate,
//     required super.isActive,
//   });

//   factory BudgetModel.fromFirestore(DocumentSnapshot doc) {
//     final data = doc.data() as Map<String, dynamic>;
//     // handle Timestamp or ISO string
//     DateTime parseDate(dynamic v) {
//       if (v == null) return DateTime.now();
//       if (v is Timestamp) return v.toDate();
//       if (v is String) return DateTime.parse(v);
//       return DateTime.tryParse(v.toString()) ?? DateTime.now();
//     }

//     return BudgetModel(
//       id: doc.id,
//       name: data['name'] ?? '',
//       amount: (data['amount'] ?? 0).toDouble(),
//       spent: (data['spent'] ?? 0).toDouble(),
//       categoryId: data['categoryId'] ?? '',
//       sourceId: data['sourceId'] ?? '',
//       startDate: parseDate(data['startDate']),
//       endDate: parseDate(data['endDate']),
//       isActive: data['isActive'] ?? true,
//     );
//   }

//   Map<String, dynamic> toFirestore() {
//     return {
//       'name': name,
//       'amount': amount,
//       'spent': spent,
//       'categoryId': categoryId,
//       'sourceId': sourceId,
//       // store as Timestamp for robust queries
//       'startDate': Timestamp.fromDate(startDate),
//       'endDate': Timestamp.fromDate(endDate),
//       'isActive': isActive,
//     };
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/budget_entity.dart';

class BudgetModel extends BudgetEntity {
  BudgetModel({
    required super.id,
    required super.name,
    required super.amount,
    required super.spent,
    required super.categoryId,
    required super.sourceId,
    required super.startDate,
    required super.endDate,
    required super.isActive,
  });

  /// Convert Firestore DocumentSnapshot -> BudgetModel
  factory BudgetModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    Timestamp? sTs = data['startDate'] as Timestamp?;
    Timestamp? eTs = data['endDate'] as Timestamp?;

    return BudgetModel(
      id: doc.id,
      name: data['name'] ?? '',
      amount: (data['amount'] ?? 0).toDouble(),
      spent: (data['spent'] ?? 0).toDouble(),
      categoryId: data['categoryId'] ?? '',
      sourceId: data['sourceId'] ?? '',
      startDate: sTs != null ? sTs.toDate() : DateTime.now(),
      endDate: eTs != null ? eTs.toDate() : DateTime.now(),
      isActive: data['isActive'] ?? true,
    );
  }

  /// Convert BudgetModel -> Firestore map
  Map<String, dynamic> toFirestore({String? uid}) {
    return {
      'name': name,
      'amount': amount,
      'spent': spent,
      'categoryId': categoryId,
      'sourceId': sourceId,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'isActive': isActive,
      if (uid != null) 'uid': uid,
    };
  }

  /// IMPORTANT: Convert model -> domain entity
  BudgetEntity toEntity() {
    return BudgetEntity(
      id: id,
      name: name,
      amount: amount,
      spent: spent,
      categoryId: categoryId,
      sourceId: sourceId,
      startDate: startDate,
      endDate: endDate,
      isActive: isActive,
    );
  }

  /// helper to copy with new id (useful when creating doc to get id)
  BudgetModel copyWith({
    String? id,
    String? name,
    double? amount,
    double? spent,
    String? categoryId,
    String? sourceId,
    DateTime? startDate,
    DateTime? endDate,
    bool? isActive,
  }) {
    return BudgetModel(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      spent: spent ?? this.spent,
      categoryId: categoryId ?? this.categoryId,
      sourceId: sourceId ?? this.sourceId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isActive: isActive ?? this.isActive,
    );
  }
}
