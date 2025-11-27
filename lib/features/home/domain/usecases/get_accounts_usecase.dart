import 'package:fintrack/features/home/domain/entities/account_entity.dart';
import 'package:fintrack/features/home/domain/repositories/home_repository.dart';

class GetAccountsUsecase {
  final HomeRepository repository;

  GetAccountsUsecase(this.repository);

  Future<List<AccountEntity>> call() async {
    return repository.getAccounts();
  }
}
