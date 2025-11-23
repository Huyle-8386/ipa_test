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

    on<ResetAddBudgetForm>((event, emit) {
      final now = DateTime.now();
      final endOfMonth = DateTime(
        now.year,
        now.month + 1,
        0,
      ); // last day of current month

      emit(
        state.copyWith(
          addAmount: "",
          addName: "",
          addCategory: null,
          addSource: null,
          addSpent: "",
          addStartDate: now,
          addEndDate: endOfMonth,
          addIsActive: true,
          addSuccess: false,
          updateSuccess: false,
          error: null,
        ),
      );
    });

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

    on<AddIsActiveChanged>((e, emit) {
      emit(state.copyWith(addIsActive: e.isActive));
    });

    on<AddSpentChanged>((e, emit) {
      emit(state.copyWith(addSpent: e.spent));
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
      final updated = event.budget.copyWith(
        name: state.addName.isNotEmpty ? state.addName : event.budget.name,
        amount: state.addAmount.isNotEmpty
            ? double.tryParse(state.addAmount)
            : event.budget.amount,
        categoryId: state.addCategory ?? event.budget.categoryId,
        sourceId: state.addSource ?? event.budget.sourceId,
        startDate: state.addStartDate,
        endDate: state.addEndDate,
        isActive: state.addIsActive,
        spent: state.addSpent.isNotEmpty
            ? double.tryParse(state.addSpent) ?? event.budget.spent
            : event.budget.spent,
      );
      await updateBudgetUsecase(updated, event.uid);

      final items = await getBudgetsUsecase(event.uid);
      emit(state.copyWith(budgets: items, loading: false, updateSuccess: true));
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
