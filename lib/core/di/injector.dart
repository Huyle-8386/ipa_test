import 'package:fintrack/features/add_transaction/add_tx_injection.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> init() async {
  await initAddTransaction();
  // await initBudget();
}
