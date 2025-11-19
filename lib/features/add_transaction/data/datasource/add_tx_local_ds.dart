// import 'package:fintrack/features/add_transaction/data/model/category_model.dart';
// import 'package:fintrack/features/add_transaction/data/model/money_source_model.dart';
// import 'package:fintrack/features/add_transaction/data/model/transaction_model.dart';

// abstract class AddTxLocalDataSource {
//   Future<List<CategoryModel>> getCategories({required bool isIncome});
//   Future<List<MoneySourceModel>> getMoneySources();
//   Future<void> saveTransaction(TransactionModel tx);
// }

// class AddTxLocalDataSourceImpl implements AddTxLocalDataSource {
//   static const List<CategoryModel> _expenseCategories = [
//     CategoryModel(
//       id: 'exp_groceries',
//       name: 'Groceries',
//       icon: 'assets/images/groeries.png',
//       isIncome: false,
//     ),
//     CategoryModel(
//       id: 'exp_shopping',
//       name: 'Shopping',
//       icon: 'assets/images/shopping.png',
//       isIncome: false,
//     ),
//     CategoryModel(
//       id: 'exp_food',
//       name: 'Food',
//       icon: 'assets/images/food.png',
//       isIncome: false,
//     ),
//     CategoryModel(
//       id: 'exp_health',
//       name: 'Health',
//       icon: 'assets/images/health.png',
//       isIncome: false,
//     ),
//     CategoryModel(
//       id: 'exp_travel',
//       name: 'Travel',
//       icon: 'assets/images/travel.png',
//       isIncome: false,
//     ),
//     CategoryModel(
//       id: 'exp_taxi',
//       name: 'Taxi',
//       icon: 'assets/images/taxi.png',
//       isIncome: false,
//     ),
//   ];

//   static const List<CategoryModel> _incomeCategories = [
//     CategoryModel(
//       id: 'inc_business',
//       name: 'Business',
//       icon: 'assets/images/business.png',
//       isIncome: true,
//     ),
//     CategoryModel(
//       id: 'inc_salary',
//       name: 'Salary',
//       icon: 'assets/images/salary.png',
//       isIncome: true,
//     ),
//     CategoryModel(
//       id: 'inc_profit',
//       name: 'Profit',
//       icon: 'assets/images/profit.png',
//       isIncome: true,
//     ),
//     CategoryModel(
//       id: 'inc_reward',
//       name: 'Reward',
//       icon: 'assets/images/reward.png',
//       isIncome: true,
//     ),
//     CategoryModel(
//       id: 'inc_collections',
//       name: 'Collections',
//       icon: 'assets/images/collections.png',
//       isIncome: true,
//     ),
//     CategoryModel(
//       id: 'inc_allowance',
//       name: 'Allowance',
//       icon: 'assets/images/allowance.png',
//       isIncome: true,
//     ),
//   ];
//   // Gộp lại một list chung nếu muốn filter theo isIncome
//   static const List<CategoryModel> _allCategories = [
//     ..._expenseCategories,
//     ..._incomeCategories,
//   ];

//   static const List<MoneySourceModel> _moneySources = [
//     MoneySourceModel(
//       id: 'ms_viettinbank',
//       name: 'VIETTINBANK',
//       icon: 'assets/icons/pashabank_usd.png',
//     ),
//     MoneySourceModel(
//       id: 'ms_cash_vnd_1',
//       name: 'Cash VND',
//       icon: 'assets/icons/cash_usd.png',
//     ),
//     MoneySourceModel(
//       id: 'ms_cash_vnd_2',
//       name: 'Cash VND',
//       icon: 'assets/icons/cash_usd.png',
//     ),
//     MoneySourceModel(
//       id: 'ms_mbbank',
//       name: 'MBBANK',
//       icon: 'assets/icons/pashabank_usd.png',
//     ),
//   ];

//   @override
//   Future<List<CategoryModel>> getCategories({required bool isIncome}) async {
//     // giả lập delay cho giống call DB/API
//     await Future.delayed(const Duration(milliseconds: 150));

//     // Lọc theo isIncome (expense = false, income = true)
//     return _allCategories.where((c) => c.isIncome == isIncome).toList();
//   }

//   @override
//   Future<List<MoneySourceModel>> getMoneySources() async {
//     await Future.delayed(const Duration(milliseconds: 150));
//     return _moneySources;
//   }

//   @override
//   Future<void> saveTransaction(TransactionModel tx) async {
//     // Tạm thời chỉ log / giả lập lưu.
//     // Sau này bạn thay bằng lưu Firebase, SQLite, ...
//     await Future.delayed(const Duration(milliseconds: 150));
//     // print('Saved transaction: ${tx.toJson()}');
//   }
// }
