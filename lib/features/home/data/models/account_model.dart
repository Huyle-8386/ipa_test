import 'package:fintrack/features/home/domain/entities/account_entity.dart';

class AccountModel extends AccountEntity {
  const AccountModel({
    required super.imagePath,
    required super.balance,
    required super.sourceName,
  });

  AccountEntity toEntity() {
    return AccountEntity(
      imagePath: imagePath,
      balance: balance,
      sourceName: sourceName,
    );
  }
}
