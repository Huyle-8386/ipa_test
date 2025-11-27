import 'package:fintrack/features/home/data/datasource/home_datasource.dart';
import 'package:fintrack/features/home/data/models/account_model.dart';

class HomeDataSourceImpl implements HomeDataSource {
  @override
  Future<List<AccountModel>> getAccounts() async {
    // Hard-coded mock data to keep current UI behavior.
    return const [
      AccountModel(
        imagePath: 'assets/icons/pashabank_usd.png',
        balance: '\$425.35',
        sourceName: 'VIETTINBANK',
      ),
      AccountModel(
        imagePath: 'assets/icons/cash_usd.png',
        balance: '\$600',
        sourceName: 'Cash VND',
      ),
      AccountModel(
        imagePath: 'assets/icons/cash_usd.png',
        balance: '\$600',
        sourceName: 'Cash VND',
      ),
      AccountModel(
        imagePath: 'assets/icons/pashabank_usd.png',
        balance: '\$425.35',
        sourceName: 'MBBANK ',
      ),
    ];
  }
}
