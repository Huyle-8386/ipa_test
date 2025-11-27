import 'package:fintrack/features/transaction_history/domain/repositories/transaction_history_repository.dart';

class GetFilterTypesUsecase {
  final TransactionHistoryRepository repository;

  GetFilterTypesUsecase(this.repository);

  Future<List<String>> call() => repository.getFilterTypes();
}
