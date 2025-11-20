import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fintrack/features/add_transaction/domain/entities/money_source_entity.dart';

class MoneySourceModel extends MoneySourceEntity {
  MoneySourceModel({
    required super.id,
    required super.name,
    required super.icon,
  });

  factory MoneySourceModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MoneySourceModel(id: doc.id, name: data['name'], icon: data['icon']);
  }
}
