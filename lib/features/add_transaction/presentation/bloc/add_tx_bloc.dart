import 'package:fintrack/features/add_transaction/domain/usecases/get_categories_usecase.dart';
import 'package:fintrack/features/add_transaction/domain/usecases/get_money_sources_usecase.dart';
import 'package:fintrack/features/add_transaction/domain/usecases/save_transaction_usecase.dart';
import 'package:fintrack/features/add_transaction/presentation/bloc/add_tx_event.dart';
import 'package:fintrack/features/add_transaction/presentation/bloc/add_tx_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddTxBloc extends Bloc<AddTxEvent, AddTxState> {
  final GetCategoriesUsecase getCategories;
  final GetMoneySourcesUsecase getMoneySources;
  final SaveTransactionUsecase saveTx;

  // AddTxBloc() : super(AddTxInitial()) {
  //   on<AddTxInitEvent>(_onInit);
  //   on<AddTxTabChangedEvent>(_onTabChanged);
  //   on<AddTxTypeChangedEvent>(_onTypeChanged);
  //   on<AddTxCategorySelectedEvent>(_onCategorySelected);
  //   on<AddTxAmountChangedEvent>(_onAmountChanged);
  //   on<AddTxDateChangedEvent>(_onDateChanged);
  //   on<AddTxMoneySourceChangedEvent>(_onMoneySourceChanged);
  //   on<AddTxNoteChangedEvent>(_onNoteChanged);
  // }

  AddTxBloc({
    required this.getCategories,
    required this.getMoneySources,
    required this.saveTx,
  }) : super(AddTxInitial()) {
    on<AddTxInitEvent>(_onInit);
    on<AddTxTabChangedEvent>(_onTabChanged);
    on<AddTxTypeChangedEvent>(_onTypeChanged);
    on<AddTxCategorySelectedEvent>(_onCategory);
    on<AddTxMoneySourceChangedEvent>(_onMoneySource);
    on<AddTxAmountChangedEvent>(_onAmount);
    on<AddTxNoteChangedEvent>(_onNote);
    on<AddTxDateChangedEvent>(_onDate);
    // on<AddTxSubmitEvent>(_onSubmit);
  }

  Future<void> _onInit(AddTxInitEvent event, Emitter<AddTxState> emit) async {
    emit(AddTxLoading());
    final cats = await getCategories(isIncome: false);
    final sources = await getMoneySources();

    emit(
      AddTxLoaded(
        tab: EntryTab.manual,
        type: TransactionType.expense,
        categories: cats,
        moneySources: sources,
        selectedCategoryIndex: null,
        moneySource: sources.isNotEmpty ? sources.first.name : null,
        amount: '',
        note: '',
        date: '',
      ),
    );
  }

  void _onTabChanged(AddTxTabChangedEvent event, Emitter<AddTxState> emit) {
    final s = state;
    if (s is AddTxLoaded) {
      emit(s.copyWith(tab: event.tab));
    }
  }

  Future<void> _onTypeChanged(
    AddTxTypeChangedEvent event,
    Emitter<AddTxState> emit,
  ) async {
    final s = state;
    if (s is AddTxLoaded) {
      emit(AddTxLoading());
      final cats = await getCategories(
        isIncome: event.type == TransactionType.income,
      );
      emit(
        s.copyWith(
          type: event.type,
          categories: cats,
          selectedCategoryIndex: null,
        ),
      );
    }
  }

  void _onCategory(AddTxCategorySelectedEvent e, Emitter<AddTxState> emit) {
    final s = state;
    if (s is AddTxLoaded) emit(s.copyWith(selectedCategoryIndex: e.index));
  }

  void _onMoneySource(
    AddTxMoneySourceChangedEvent e,
    Emitter<AddTxState> emit,
  ) {
    final s = state;
    if (s is AddTxLoaded) emit(s.copyWith(moneySource: e.moneySource));
  }

  void _onDate(AddTxDateChangedEvent e, Emitter<AddTxState> emit) {
    final s = state;
    if (s is AddTxLoaded) emit(s.copyWith(date: e.date));
  }

  void _onAmount(AddTxAmountChangedEvent event, Emitter<AddTxState> emit) {
    final s = state;
    if (s is AddTxLoaded) emit(s.copyWith(amount: event.amount));
  }

  void _onNote(AddTxNoteChangedEvent event, Emitter<AddTxState> emit) {
    final s = state;
    if (s is AddTxLoaded) emit(s.copyWith(note: event.note));
  }
}
