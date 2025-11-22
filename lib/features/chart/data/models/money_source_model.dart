import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/money_source_entity.dart';

class MoneySourceModel extends MoneySourceEntity {
  MoneySourceModel({
    required super.id,
    required super.name,
    required super.icon,
    required super.balance,
  });

  factory MoneySourceModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MoneySourceModel(
      id: doc.id,
      name: data['name'] ?? '',
      icon: data['icon'] ?? '',
      balance: (data['balance'] is num)
          ? (data['balance'] as num).toDouble()
          : double.tryParse(data['balance'].toString()) ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'icon': icon,
    'balance': balance,
  };
}
