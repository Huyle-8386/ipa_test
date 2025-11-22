// // lib/features/budget/data/datasources/budget_datasource.dart
// import 'package:flutter/material.dart';
// import '../../data/models/budget_model.dart';

// class BudgetDataSource {
//   // Static in-memory data (kept from original)
//   static List<BudgetModel> budgets = [
//     BudgetModel(
//       name: "Monthly Budget",
//       spent: 3050,
//       total: 5000,
//       isActive: true,
//       monthlySpending: [
//         300,
//         450,
//         500,
//         600,
//         400,
//         700,
//         800,
//         750,
//         650,
//         600,
//         500,
//         550,
//       ],
//       monthlyBudgetLimit: [
//         400,
//         500,
//         600,
//         600,
//         600,
//         700,
//         700,
//         700,
//         700,
//         700,
//         700,
//         700,
//       ],
//       expenses: [
//         BudgetExpenseModel(
//           category: "Shopping",
//           amount: 1200,
//           colorValue: Colors.orange.value,
//         ),
//         BudgetExpenseModel(
//           category: "Food",
//           amount: 800,
//           colorValue: Colors.red.value,
//         ),
//         BudgetExpenseModel(
//           category: "Groceries",
//           amount: 600,
//           colorValue: Colors.green.value,
//         ),
//         BudgetExpenseModel(
//           category: "Health",
//           amount: 450,
//           colorValue: Colors.blue.value,
//         ),
//       ],
//     ),
//     BudgetModel(
//       name: "Shopping Budget",
//       spent: 1024,
//       total: 1000,
//       isActive: true,
//       monthlySpending: [100, 200, 300, 250, 150, 24],
//       monthlyBudgetLimit: [150, 250, 350, 300, 200, 100],
//       expenses: [
//         BudgetExpenseModel(
//           category: "Clothes",
//           amount: 600,
//           colorValue: Colors.deepOrange.value,
//         ),
//         BudgetExpenseModel(
//           category: "Accessories",
//           amount: 424,
//           colorValue: Colors.brown.value,
//         ),
//       ],
//     ),
//     BudgetModel(
//       name: "Travel Budget",
//       spent: 5500,
//       total: 5000,
//       isActive: false,
//       monthlySpending: [400, 500, 700, 800, 900, 1200, 1000],
//       monthlyBudgetLimit: [600, 600, 700, 800, 800, 900, 900],
//       expenses: [
//         BudgetExpenseModel(
//           category: "Flights",
//           amount: 2000,
//           colorValue: Colors.purple.value,
//         ),
//         BudgetExpenseModel(
//           category: "Hotels",
//           amount: 2000,
//           colorValue: Colors.teal.value,
//         ),
//         BudgetExpenseModel(
//           category: "Food",
//           amount: 1500,
//           colorValue: Colors.red.value,
//         ),
//       ],
//     ),
//   ];

//   // static List<BudgetModel> budgets = [];
// }
