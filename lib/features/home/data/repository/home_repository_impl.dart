import 'package:fintrack/features/home/data/datasource/home_datasource.dart';
import 'package:fintrack/features/home/domain/entities/account_entity.dart';
import 'package:fintrack/features/home/domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeDataSource dataSource;

  HomeRepositoryImpl(this.dataSource);

  @override
  Future<List<AccountEntity>> getAccounts() async {
    final accounts = await dataSource.getAccounts();
    return accounts.map((account) => account.toEntity()).toList();
  }
}
