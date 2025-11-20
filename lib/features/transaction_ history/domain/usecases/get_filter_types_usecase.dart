import 'package:fintrack/features/transaction_%20history/domain/repositories/transaction_history_repository.dart';

class GetFilterTypesUsecase {
  final TransactionHistoryRepository repository;

  GetFilterTypesUsecase(this.repository);

  Future<List<String>> call() => repository.getFilterTypes();
}
