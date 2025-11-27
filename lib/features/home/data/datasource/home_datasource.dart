import 'package:fintrack/features/home/data/models/account_model.dart';

abstract class HomeDataSource {
  Future<List<AccountModel>> getAccounts();
}
