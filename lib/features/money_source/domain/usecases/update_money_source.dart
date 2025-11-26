import '../entities/money_source_entity.dart';
import '../repositories/money_source_repository.dart';

class UpdateMoneySource {
  final MoneySourceRepository repository;

  UpdateMoneySource(this.repository);

  Future<void> call(String uid, MoneySourceEntity entity) async {
    await repository.updateMoneySource(uid, entity);
  }
}
