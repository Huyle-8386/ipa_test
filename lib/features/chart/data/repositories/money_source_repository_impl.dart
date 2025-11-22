import '../../domain/entities/money_source_entity.dart';
import '../datasources/money_source_remote_data_source.dart';
import '../../domain/repositories/money_source_repository.dart';

class MoneySourceRepositoryImpl implements MoneySourceRepository {
  final MoneySourceRemoteDataSource remote;

  MoneySourceRepositoryImpl({required this.remote});

  @override
  Future<List<MoneySourceEntity>> getMoneySources() {
    return remote.getMoneySources();
  }
}
