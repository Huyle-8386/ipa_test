import 'package:fintrack/features/add_transaction/domain/entities/money_source_entity.dart';

class MoneySourceModel extends MoneySourceEntity {
  const MoneySourceModel({
    required super.id,
    required super.name,
    required super.icon,
  });

  factory MoneySourceModel.fromJson(Map<String, dynamic> j) =>
      MoneySourceModel(id: j['id'], name: j['name'], icon: j['icon']);

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'icon': icon};
}
