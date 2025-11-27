import 'package:fintrack/features/home/domain/entities/account_entity.dart';

abstract class HomeRepository {
  Future<List<AccountEntity>> getAccounts();
}
