import '../entities/money_source_entity.dart';
import '../repositories/money_source_repository.dart';

class AddMoneySource {
  final MoneySourceRepository repository;

  AddMoneySource(this.repository);

  Future<void> call(String uid, MoneySourceEntity entity) async {
    await repository.addMoneySource(uid, entity);
  }
}
