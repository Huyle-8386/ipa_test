import '../entities/money_source_entity.dart';
import '../repositories/money_source_repository.dart';

class GetMoneySourcesUseCase {
  final MoneySourceRepository repository;

  GetMoneySourcesUseCase(this.repository);

  Future<List<MoneySourceEntity>> call() {
    return repository.getMoneySources();
  }
}
