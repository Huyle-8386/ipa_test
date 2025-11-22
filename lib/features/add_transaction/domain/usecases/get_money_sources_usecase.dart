import 'package:fintrack/features/add_transaction/domain/entities/money_source_entity.dart';
import 'package:fintrack/features/add_transaction/domain/repositories/%20moneysource_repository.dart';
import 'package:fintrack/features/add_transaction/domain/repositories/add_tx_repository.dart';

class GetMoneySourcesUsecase {
  final MoneySourceRepository repo;

  GetMoneySourcesUsecase(this.repo);

  Future<List<MoneySourceEntity>> call() async {
    return repo.getMoneySources();
  }
}
