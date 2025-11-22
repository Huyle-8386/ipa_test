import 'package:fintrack/features/add_transaction/domain/entities/money_source_entity.dart';
import 'package:fintrack/features/add_transaction/domain/entities/transaction_entity.dart';
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
    on<AddTxSubmitEvent>(_onSubmit);
  }

  Future<void> _onInit(AddTxInitEvent event, Emitter<AddTxState> emit) async {
    emit(AddTxLoading());
    final cats = await getCategories(isIncome: false);
    final sources = await getMoneySources();
    // Copy to force an actual List<MoneySourceEntity> instead of a List<MoneySourceModel>
    final normalizedSources = List<MoneySourceEntity>.from(sources);

    emit(
      AddTxLoaded(
        tab: EntryTab.manual,
        type: TransactionType.expense,
        categories: cats,
        moneySources: normalizedSources,
        selectedCategoryIndex: cats.isNotEmpty ? 0 : null,
        moneySource: normalizedSources.isNotEmpty
            ? normalizedSources.first.name
            : null,
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
          selectedCategoryIndex: cats.isNotEmpty ? 0 : null,
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

  Future<void> _onSubmit(
    AddTxSubmitEvent event,
    Emitter<AddTxState> emit,
  ) async {
    final s = state;
    if (s is! AddTxLoaded) return;

    try {
      emit(AddTxLoading());

      // 1. Lấy category được chọn
      if (s.selectedCategoryIndex == null) {
        throw Exception('Please select category');
      }
      final category = s.categories[s.selectedCategoryIndex!];

      // 2. Lấy moneySource được chọn (giả sử state.moneySource = name)
      final MoneySourceEntity ms = s.moneySources.firstWhere(
        (m) => m.name == s.moneySource,
        orElse: () => s.moneySources.first,
      );

      // 3. Parse amount
      final amount = double.tryParse(s.amount) ?? 0;

      // 4. Parse date
      DateTime dateTime;
      if (s.date.isEmpty) {
        dateTime = DateTime.now();
      } else {
        dateTime = DateTime.parse(
          s.date,
        ); // vì DatePickerField format yyyy-MM-dd HH:mm
      }

      // 5. Tạo TransactionEntity
      final tx = TransactionEntity(
        amount: amount,
        dateTime: dateTime,
        note: s.note,
        category: category,
        moneySource: ms,
        isIncome: s.type == TransactionType.income,
      );

      // 6. Gọi usecase lưu Firestore
      await saveTx(tx);

      // 7. Emit success while keeping the latest loaded data for the UI
      emit(
        AddTxSubmitSuccess(
          tab: s.tab,
          type: s.type,
          categories: s.categories,
          moneySources: s.moneySources,
          selectedCategoryIndex: s.selectedCategoryIndex,
          amount: s.amount,
          date: s.date,
          moneySource: s.moneySource,
          note: s.note,
        ),
      );
    } catch (e, st) {
      // In log để debug
      print('AddTxBloc _onSubmit error: $e');
      print(st);

      emit(AddTxError(e.toString()));
    }
  }
}
