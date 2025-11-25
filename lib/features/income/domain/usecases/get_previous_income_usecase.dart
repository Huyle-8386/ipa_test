import 'package:fintrack/features/income/domain/repositories/income_repository.dart';

class GetPreviousIncomeUsecase {
  final IncomeRepository repository;

  GetPreviousIncomeUsecase(this.repository);

  Future<List> call({required String category}) {
    return repository.getPreviousIncome(category: category);
  }
}
