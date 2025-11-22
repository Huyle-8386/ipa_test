// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../domain/repositories/budget_repository.dart';
// import '../../domain/usecases/get_budgets.dart';
// import '../../domain/entities/budget_entity.dart';
// import '../../domain/usecases/get_categories.dart';
// import 'budget_event.dart';
// import 'budget_state.dart';

// class BudgetBloc extends Bloc<BudgetEvent, BudgetState> {
//   final GetBudgets getBudgets;
//   // final GetBudgetCategories getBudgetCategories;

//   BudgetBloc({required this.getBudgets}) : super(BudgetState.initial()) {
//     on<LoadBudgets>(_onLoadBudgets);
//     on<BudgetTabChanged>(_onTabChanged);
//     on<SelectBudgetEvent>(_onSelectBudget);

//     // on<LoadCategories>((event, emit) async {
//     //   final list = await getBudgetCategories(event.isIncome);
//     //   emit(state.copyWith(categories: list));
//     // });

//     on<AddAmountChanged>(
//       (e, emit) => emit(state.copyWith(addAmount: e.amount)),
//     );

//     on<AddNameChanged>((e, emit) => emit(state.copyWith(addName: e.name)));

//     on<AddCategoryChanged>(
//       (e, emit) => emit(state.copyWith(addCategory: e.category)),
//     );

//     on<AddSourceChanged>(
//       (e, emit) => emit(state.copyWith(addSource: e.source)),
//     );

//     on<AddStartDateChanged>(
//       (e, emit) => emit(state.copyWith(addStartDate: e.date)),
//     );

//     on<AddEndDateChanged>(
//       (e, emit) => emit(state.copyWith(addEndDate: e.date)),
//     );
//   }

//   Future<void> _onLoadBudgets(
//     LoadBudgets event,
//     Emitter<BudgetState> emit,
//   ) async {
//     emit(state.copyWith(isLoading: true));
//     final all = await getBudgets();
//     final filtered = _filterByTab(all, state.selectedTab);
//     emit(state.copyWith(budgets: filtered, isLoading: false));
//   }

//   void _onTabChanged(BudgetTabChanged event, Emitter<BudgetState> emit) {
//     final filtered = _filterByTab(
//       state.budgets.isEmpty ? [] : state.budgets,
//       event.selectedTab,
//     );
//     // If budgets not loaded yet, try to load all then filter (we'll be conservative)
//     emit(
//       state.copyWith(
//         selectedTab: event.selectedTab,
//         budgets: state.budgets.isEmpty ? [] : filtered,
//       ),
//     );
//   }

//   void _onSelectBudget(SelectBudgetEvent event, Emitter<BudgetState> emit) {
//     emit(state.copyWith(selectedBudget: event.budget));
//   }

//   List<BudgetEntity> _filterByTab(List<BudgetEntity> items, String tab) {
//     if (items.isEmpty) return items;
//     if (tab == "Active") {
//       return items.where((b) => b.isActive).toList();
//     } else {
//       return items.where((b) => !b.isActive).toList();
//     }
//   }
// }

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/budget_entity.dart';
import '../../domain/usecases/add_budget.dart';
import '../../domain/usecases/get_budgets.dart';
import '../../domain/usecases/update_budget.dart';
import '../../domain/usecases/delete_budget.dart';
import 'budget_event.dart';
import 'budget_state.dart';

class BudgetBloc extends Bloc<BudgetEvent, BudgetState> {
  final AddBudget addBudgetUsecase;
  final GetBudgets getBudgetsUsecase;
  final UpdateBudget updateBudgetUsecase;
  final DeleteBudget deleteBudgetUsecase;

  BudgetBloc({
    required this.addBudgetUsecase,
    required this.getBudgetsUsecase,
    required this.updateBudgetUsecase,
    required this.deleteBudgetUsecase,
  }) : super(BudgetState.initial()) {
    // CRUD
    on<LoadBudgets>(_onLoadBudgets);
    on<AddBudgetRequested>(_onAddBudget);
    on<UpdateBudgetRequested>(_onUpdateBudget);
    on<DeleteBudgetRequested>(_onDeleteBudget);

    // UI Form handlers
    on<AddAmountChanged>((e, emit) {
      emit(state.copyWith(addAmount: e.amount));
    });

    on<AddNameChanged>((e, emit) {
      emit(state.copyWith(addName: e.name));
    });

    on<AddCategoryChanged>((e, emit) {
      emit(state.copyWith(addCategory: e.categoryId));
    });

    on<AddSourceChanged>((e, emit) {
      emit(state.copyWith(addSource: e.sourceId));
    });

    on<AddStartDateChanged>((e, emit) {
      emit(state.copyWith(addStartDate: e.date));
    });

    on<AddEndDateChanged>((e, emit) {
      emit(state.copyWith(addEndDate: e.date));
    });

    // Tab
    on<BudgetTabChanged>((e, emit) {
      emit(state.copyWith(selectedTab: e.tab));
    });
  }

  // ------------------------
  // LOAD
  // ------------------------
  Future<void> _onLoadBudgets(
    LoadBudgets event,
    Emitter<BudgetState> emit,
  ) async {
    emit(state.copyWith(loading: true, error: null));
    try {
      final items = await getBudgetsUsecase(event.uid);
      emit(state.copyWith(budgets: items, loading: false));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  // ------------------------
  // ADD
  // ------------------------
  Future<void> _onAddBudget(
    AddBudgetRequested event,
    Emitter<BudgetState> emit,
  ) async {
    emit(state.copyWith(addSuccess: false, loading: true, error: null));

    try {
      final budget = BudgetEntity(
        id: '',
        name: state.addName,
        amount: double.tryParse(state.addAmount) ?? 0,
        spent: 0,
        categoryId: state.addCategory ?? '',
        sourceId: state.addSource ?? "",
        startDate: state.addStartDate,
        endDate: state.addEndDate,
        isActive: true,
      );

      await addBudgetUsecase(budget, event.uid);

      // reload
      final items = await getBudgetsUsecase(event.uid);
      emit(state.copyWith(budgets: items, loading: false, addSuccess: true));
    } catch (e) {
      emit(
        state.copyWith(loading: false, addSuccess: false, error: e.toString()),
      );
    }
  }

  // ------------------------
  // UPDATE
  // ------------------------
  Future<void> _onUpdateBudget(
    UpdateBudgetRequested event,
    Emitter<BudgetState> emit,
  ) async {
    emit(state.copyWith(loading: true, error: null));

    try {
      await updateBudgetUsecase(event.budget, event.uid);

      final items = await getBudgetsUsecase(event.uid);
      emit(state.copyWith(budgets: items, loading: false));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  // ------------------------
  // DELETE
  // ------------------------
  Future<void> _onDeleteBudget(
    DeleteBudgetRequested event,
    Emitter<BudgetState> emit,
  ) async {
    emit(state.copyWith(loading: true, error: null));

    try {
      await deleteBudgetUsecase(event.budgetId, event.uid);

      final items = await getBudgetsUsecase(event.uid);
      emit(state.copyWith(budgets: items, loading: false));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }
}
