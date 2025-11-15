import 'package:flutter_bloc/flutter_bloc.dart';

// Domain
import 'domain/usecases/get_budgets.dart';

// Data
import 'data/repositories/budget_repository_impl.dart';

// Presentation
import 'presentation/bloc/budget_bloc.dart';

class BudgetInjection {
  static BudgetBloc injectBloc() {
    // Repository không nhận tham số → khởi tạo trực tiếp
    final repository = BudgetRepositoryImpl();

    // Usecase
    final getBudgets = GetBudgets(repository);

    // Bloc
    return BudgetBloc(getBudgets: getBudgets);
  }
}
