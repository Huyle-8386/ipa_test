import 'package:fintrack/features/add_transaction/add_tx_injection.dart';
import 'package:fintrack/features/auth/auth_injection.dart' as auth_injection;
import 'package:fintrack/features/budget/budget_injection.dart';
import 'package:fintrack/features/chart/chart_injection.dart';
import 'package:fintrack/features/expenses/expenses_injection.dart';
import 'package:fintrack/features/home/home_injection.dart';
import 'package:fintrack/features/income/income_injection.dart';
import 'package:fintrack/features/transaction_history/transaction_history_injection.dart';

import 'package:fintrack/features/setting/setting_injection.dart';
import 'package:get_it/get_it.dart';

import '../../features/chatbot/ai_chat_injection.dart';
import '../../features/money_source/money_source_injection.dart';

final sl = GetIt.instance;

Future<void> init() async {
  await auth_injection.initAuth();
  await initAddTransaction();
  await initHome();
  await injectBudgets();
  await initChartFeature();
  await initSettingFeature();
  await initExpenses();
  await initIncome();
  await initTransactionHistory();
  await initChatbotModule();
  await initMoneySource();
}
