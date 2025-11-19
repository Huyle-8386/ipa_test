import 'package:fintrack/features/income/domain/entities/income_entity.dart';
import 'package:fintrack/features/income/domain/repositories/income_repository.dart';

class GetIncomeUsecase {
  final IncomeRepository repository;
  GetIncomeUsecase(this.repository);

  Future<List<IncomeEntity>> call({required String category}) {
    return repository.getIncome(category: category);
  }
}
