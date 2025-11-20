import 'package:flutter/material.dart';

enum TransactionType { spending, income, all }

class TransactionEntity {
  final String icon;
  final Color color;
  final String category;
  final String note;
  final double value;
  final String amount;
  final DateTime date;
  final String time;
  final TransactionType type;

  const TransactionEntity({
    required this.icon,
    required this.color,
    required this.category,
    required this.note,
    required this.value,
    required this.amount,
    required this.date,
    required this.time,
    required this.type,
  });
}
