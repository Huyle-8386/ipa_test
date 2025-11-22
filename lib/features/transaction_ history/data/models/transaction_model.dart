import 'package:fintrack/features/transaction_%20history/domain/entities/transaction_entity.dart';
import 'package:flutter/material.dart';

class TransactionModel extends TransactionEntity {
  const TransactionModel({
    required super.icon,
    required super.color,
    required super.category,
    required super.note,
    required super.value,
    required super.amount,
    required super.date,
    required super.time,
    required super.type,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      TransactionModel(
        icon: json['icon'] as String,
        color: Color(json['color'] as int),
        category: json['category'] as String,
        note: json['note'] as String,
        value: (json['value'] as num).toDouble(),
        amount: json['amount'] as String,
        date: DateTime.parse(json['date'] as String),
        time: json['time'] as String,
        type: TransactionType.values[json['type'] as int],
      );

  Map<String, dynamic> toJson() => {
    'icon': icon,
    'color': color.value,
    'category': category,
    'note': note,
    'value': value,
    'amount': amount,
    'date': date.toIso8601String(),
    'time': time,
    'type': type.index,
  };
}
