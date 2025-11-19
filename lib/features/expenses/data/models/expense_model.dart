import 'package:fintrack/features/expenses/domain/entities/expense_entity.dart';
import 'package:flutter/material.dart';

class ExpenseModel extends ExpenseEntity {
  const ExpenseModel({
    required super.icon,
    required super.color,
    required super.name,
    required super.value,
    required super.amount,
    required super.percentage,
    required super.isUp,
  });

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      icon: json['icon'] as String,
      color: Color(json['color'] as int),
      name: json['name'] as String,
      value: (json['value'] as num).toDouble(),
      amount: json['amount'] as String,
      percentage: json['percentage'] as String,
      isUp: json['isUp'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'icon': icon,
      'color': color.value,
      'name': name,
      'value': value,
      'amount': amount,
      'percentage': percentage,
      'isUp': isUp,
    };
  }
}
