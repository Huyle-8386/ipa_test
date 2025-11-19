import 'package:flutter/material.dart';

class IncomeEntity {
  final String icon;
  final Color color;
  final String name;
  final double value;
  final String amount;
  final String percentage;
  final bool isUp;

  const IncomeEntity({
    required this.icon,
    required this.color,
    required this.name,
    required this.value,
    required this.amount,
    required this.percentage,
    required this.isUp,
  });
}
