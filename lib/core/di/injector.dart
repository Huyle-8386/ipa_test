import 'package:fintrack/features/add_transaction/add_tx_injection.dart';
import 'package:fintrack/features/add_transaction/data/datasource/add_tx_local_ds.dart';
import 'package:fintrack/features/add_transaction/data/repository/add_tx_repository_impl.dart';
import 'package:fintrack/features/add_transaction/domain/repositories/add_tx_repository.dart';
import 'package:fintrack/features/add_transaction/domain/usecases/get_categories_usecase.dart';
import 'package:fintrack/features/add_transaction/domain/usecases/get_money_sources_usecase.dart';
import 'package:fintrack/features/add_transaction/domain/usecases/save_transaction_usecase.dart';
import 'package:fintrack/features/add_transaction/presentation/bloc/add_tx_bloc.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> init() async {
  await initAddTransaction();
  // await initBudget();
 
}