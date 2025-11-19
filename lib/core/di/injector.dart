import 'package:fintrack/features/add_transaction/add_tx_injection.dart';

import 'package:fintrack/features/budget/budget_injection.dart';
import 'package:fintrack/features/chart/chart_injection.dart';
import 'package:fintrack/features/expenses/expenses_injection.dart';
import 'package:fintrack/features/income/income_injection.dart';
import 'package:fintrack/features/transaction_%20history/transaction_history_injection.dart';

import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> init() async {
  await initAddTransaction();
  await injectBudgets();
  await initChartFeature();
  // await injectChart();
  // await initBudget();
  await initExpenses();
  await initIncome();
  await initTransactionHistory();
}
