import '../entities/money_source_entity.dart';
import '../repositories/money_source_repository.dart';

class GetMoneySources {
  final MoneySourceRepository repository;

  GetMoneySources(this.repository);

  Future<List<MoneySourceEntity>> call(String uid) async {
    return await repository.getMoneySources(uid);
  }
}
