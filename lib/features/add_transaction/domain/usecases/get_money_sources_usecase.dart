import 'package:fintrack/features/add_transaction/domain/entities/money_source_entity.dart';
import 'package:fintrack/features/add_transaction/domain/repositories/add_tx_repository.dart';

class GetMoneySourcesUsecase {
  final AddTxRepository repo;
  GetMoneySourcesUsecase(this.repo);

  Future<List<MoneySourceEntity>> call() => repo.getMoneySources();
}
