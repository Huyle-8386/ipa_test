import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fintrack/features/transaction_%20history/presentation/bloc/transaction_%20history_event.dart';
import 'package:fintrack/features/transaction_%20history/presentation/bloc/transaction_%20history_state.dart';
import 'package:fintrack/features/transaction_%20history/data/datasources/transaction_%20history_data.dart';

class TransactionHistoryBloc
    extends Bloc<TransactionHistoryEvent, TransactionHistoryState> {
  TransactionHistoryBloc() : super(TransactionHistoryInitial()) {
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

      final allTransactions = transactions;
      final grouped = groupTransactionsByDate(allTransactions);
      final income = getTotalIncome(allTransactions);
      final spending = getTotalSpending(allTransactions);
      final balance = getBalance(allTransactions);

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

        final filteredTransactions = filterTransactionsByType(
          transactions,
          event.type,
        );
        final grouped = groupTransactionsByDate(filteredTransactions);
        final income = getTotalIncome(filteredTransactions);
        final spending = getTotalSpending(filteredTransactions);
        final balance = getBalance(filteredTransactions);

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

        final searchResults = transactions.where((transaction) {
          final name = transaction.category.toLowerCase();
          final category = transaction.note.toLowerCase();
          final query = event.query.toLowerCase();
          return name.contains(query) || category.contains(query);
        }).toList();

        final grouped = groupTransactionsByDate(searchResults);
        final income = getTotalIncome(searchResults);
        final spending = getTotalSpending(searchResults);
        final balance = getBalance(searchResults);

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
