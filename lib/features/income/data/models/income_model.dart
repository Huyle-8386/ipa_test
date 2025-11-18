import 'package:fintrack/features/income/domain/entities/income_entity.dart';
import 'package:flutter/material.dart';

class IncomeModel extends IncomeEntity {
  const IncomeModel({
    required super.icon,
    required super.color,
    required super.name,
    required super.value,
    required super.amount,
    required super.percentage,
    required super.isUp,
  });

  factory IncomeModel.fromJson(Map<String, dynamic> json) => IncomeModel(
    icon: json['icon'] as String,
    color: Color(json['color'] as int),
    name: json['name'] as String,
    value: (json['value'] as num).toDouble(),
    amount: json['amount'] as String,
    percentage: json['percentage'] as String,
    isUp: json['isUp'] as bool,
  );

  Map<String, dynamic> toJson() => {
    'icon': icon,
    'color': color.value,
    'name': name,
    'value': value,
    'amount': amount,
    'percentage': percentage,
    'isUp': isUp,
  };
}
