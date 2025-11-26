import '../repositories/money_source_repository.dart';

class DeleteMoneySource {
  final MoneySourceRepository repository;

  DeleteMoneySource(this.repository);

  Future<void> call(String uid, String id) async {
    await repository.deleteMoneySource(uid, id);
  }
}
