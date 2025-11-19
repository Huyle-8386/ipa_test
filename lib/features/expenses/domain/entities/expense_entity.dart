import 'package:flutter/material.dart';

class ExpenseEntity {
  final String icon;
  final Color color;
  final String name;
  final double value;
  final String amount;
  final String percentage;
  final bool isUp;

  const ExpenseEntity({
    required this.icon,
    required this.color,
    required this.name,
    required this.value,
    required this.amount,
    required this.percentage,
    required this.isUp,
  });
}
