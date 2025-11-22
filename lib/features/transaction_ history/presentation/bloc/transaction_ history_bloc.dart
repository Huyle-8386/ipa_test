import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fintrack/features/transaction_%20history/presentation/bloc/transaction_%20history_event.dart';
import 'package:fintrack/features/transaction_%20history/presentation/bloc/transaction_%20history_state.dart';
import 'package:fintrack/features/transaction_%20history/domain/entities/transaction_entity.dart';
import 'package:fintrack/features/transaction_%20history/domain/usecases/get_transactions_usecase.dart';
import 'package:fintrack/features/transaction_%20history/domain/usecases/search_transactions_usecase.dart';
import 'package:fintrack/features/transaction_%20history/domain/usecases/get_filter_types_usecase.dart';

class TransactionHistoryBloc
    extends Bloc<TransactionHistoryEvent, TransactionHistoryState> {
  final GetTransactionsUsecase getTransactions;
  final SearchTransactionsUsecase searchTransactions;
  final GetFilterTypesUsecase getFilterTypes;

  TransactionHistoryBloc({
    required this.getTransactions,
    required this.searchTransactions,
    required this.getFilterTypes,
  }) : super(TransactionHistoryInitial()) {
    on<LoadTransactionHistory>(_onLoadTransactionHistory);
    on<FilterTransactionsByType>(_onFilterTransactionsByType);
    on<SearchTransactions>(_onSearchTransactions);
  }

  void _onLoadTransactionHistory(
    LoadTransactionHistory event,
    Emitter<TransactionHistoryState> emit,
  ) async {
    emit(TransactionHistoryLoading());

    try {
      // Giả lập tải dữ liệu
      await Future.delayed(const Duration(milliseconds: 500));

      final allTransactions = await getTransactions(type: TransactionType.all);
      final grouped = _groupTransactionsByDate(allTransactions);
      final income = _getTotalIncome(allTransactions);
      final spending = _getTotalSpending(allTransactions);
      final balance = _getBalance(allTransactions);

      emit(
        TransactionHistoryLoaded(
          transactions: allTransactions,
          groupedTransactions: grouped,
          activeFilter: TransactionType.all,
          totalIncome: income,
          totalSpending: spending,
          balance: balance,
        ),
      );
    } catch (e) {
      emit(TransactionHistoryError(e.toString()));
    }
  }

  void _onFilterTransactionsByType(
    FilterTransactionsByType event,
    Emitter<TransactionHistoryState> emit,
  ) async {
    if (state is TransactionHistoryLoaded) {
      emit(TransactionHistoryLoading());

      try {
        await Future.delayed(const Duration(milliseconds: 300));

        final filteredTransactions = await getTransactions(type: event.type);
        final grouped = _groupTransactionsByDate(filteredTransactions);
        final income = _getTotalIncome(filteredTransactions);
        final spending = _getTotalSpending(filteredTransactions);
        final balance = _getBalance(filteredTransactions);

        emit(
          TransactionHistoryLoaded(
            transactions: filteredTransactions,
            groupedTransactions: grouped,
            activeFilter: event.type,
            totalIncome: income,
            totalSpending: spending,
            balance: balance,
          ),
        );
      } catch (e) {
        emit(TransactionHistoryError(e.toString()));
      }
    }
  }

  void _onSearchTransactions(
    SearchTransactions event,
    Emitter<TransactionHistoryState> emit,
  ) async {
    if (state is TransactionHistoryLoaded) {
      final currentState = state as TransactionHistoryLoaded;

      if (event.query.isEmpty) {
        add(FilterTransactionsByType(currentState.activeFilter));
        return;
      }

      emit(TransactionHistoryLoading());

      try {
        await Future.delayed(const Duration(milliseconds: 300));

        final searchResults = await searchTransactions(
          event.query,
          type: currentState.activeFilter,
        );

        final grouped = _groupTransactionsByDate(searchResults);
        final income = _getTotalIncome(searchResults);
        final spending = _getTotalSpending(searchResults);
        final balance = _getBalance(searchResults);

        emit(
          TransactionHistoryLoaded(
            transactions: searchResults,
            groupedTransactions: grouped,
            activeFilter: currentState.activeFilter,
            totalIncome: income,
            totalSpending: spending,
            balance: balance,
          ),
        );
      } catch (e) {
        emit(TransactionHistoryError(e.toString()));
      }
    }
  }
}

Map<String, List<TransactionEntity>> _groupTransactionsByDate(
  List<TransactionEntity> transactions,
) {
  final Map<String, List<TransactionEntity>> grouped = {};

  for (var transaction in transactions) {
    final dateKey = _formatDate(transaction.date);
    grouped.putIfAbsent(dateKey, () => []);
    grouped[dateKey]!.add(transaction);
  }

  return grouped;
}

String _formatDate(DateTime date) {
  const months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  return '${date.day} ${months[date.month - 1]} ${date.year}';
}

double _getTotalIncome(List<TransactionEntity> transactions) {
  return transactions
      .where((t) => t.type == TransactionType.income)
      .fold(0.0, (sum, item) => sum + item.value);
}

double _getTotalSpending(List<TransactionEntity> transactions) {
  return transactions
      .where((t) => t.type == TransactionType.spending)
      .fold(0.0, (sum, item) => sum + item.value.abs());
}

double _getBalance(List<TransactionEntity> transactions) {
  return _getTotalIncome(transactions) - _getTotalSpending(transactions);
}
