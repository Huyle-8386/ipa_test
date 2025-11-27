import '../../domain/entities/money_source_entity.dart';

class MoneySourceModel extends MoneySourceEntity {
  MoneySourceModel({
    required super.id,
    required super.name,
    required super.icon,
    required super.balance,
  });

  factory MoneySourceModel.fromJson(Map<String, dynamic> json) {
    return MoneySourceModel(
      id: json['id'] ?? '',
      name: json['name'],
      icon: json['icon'],
      balance: (json['balance'] as num).toDouble(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'icon': icon, 'balance': balance};
  }
}
