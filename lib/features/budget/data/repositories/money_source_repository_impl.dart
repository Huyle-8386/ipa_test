import '../../domain/entities/money_source_entity.dart';
import '../../domain/repositories/money_source_repository.dart';
import '../datasources/money_source_remote_data_source.dart';

class MoneySourceRepositoryImpl implements MoneySourceRepository {
  final MoneySourceRemoteDataSource remote;

  MoneySourceRepositoryImpl(this.remote);

  @override
  Future<List<MoneySourceEntity>> getMoneySources(String uid) async {
    final raw = await remote.getMoneySources(uid);
    return raw; // Model extends Entity
  }
}
