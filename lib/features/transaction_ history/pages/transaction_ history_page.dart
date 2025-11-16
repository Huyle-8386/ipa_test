import 'package:fintrack/features/transaction_ history/datasources/transaction_ history_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fintrack/core/theme/app_colors.dart';
import 'package:fintrack/core/utils/size_utils.dart';
import 'package:fintrack/features/transaction_ history/bloc/transaction_ history_bloc.dart';
import 'package:fintrack/features/transaction_ history/bloc/transaction_ history_event.dart';
import 'package:fintrack/features/transaction_ history/bloc/transaction_ history_state.dart';
import 'package:fintrack/features/transaction_ history/pages/build_transaction_ history_list.dart';

class TransactionHistoryPage extends StatefulWidget {
  const TransactionHistoryPage({super.key});

  @override
  State<TransactionHistoryPage> createState() => _TransactionHistoryPageState();
}

class _TransactionHistoryPageState extends State<TransactionHistoryPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<TransactionHistoryBloc>().add(LoadTransactionHistory());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final h = SizeUtils.height(context);
    final w = SizeUtils.width(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: w * 0.05, vertical: h * 0.01),
        child: BlocConsumer<TransactionHistoryBloc, TransactionHistoryState>(
          listener: (context, state) {
            if (state is TransactionHistoryError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Lỗi: ${state.message}'),
                  backgroundColor: AppColors.red,
                ),
              );
            }

            if (state is TransactionHistoryLoaded &&
                state.transactions.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Không tìm thấy giao dịch nào'),
                  backgroundColor: AppColors.orange,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is TransactionHistoryInitial ||
                state is TransactionHistoryLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is TransactionHistoryLoaded) {
              return _buildContent(context, state, h, w);
            } else if (state is TransactionHistoryError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: AppColors.red,
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Đã xảy ra lỗi: ${state.message}',
                      style: const TextStyle(color: AppColors.red),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<TransactionHistoryBloc>().add(
                          LoadTransactionHistory(),
                        );
                      },
                      child: const Text('Thử lại'),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    TransactionHistoryLoaded state,
    double h,
    double w,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header
        Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(
                Icons.arrow_back,
                color: AppColors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            const Text(
              "Transaction History",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.white,
                fontSize: 20,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Search bar
        TextField(
          controller: _searchController,
          style: const TextStyle(color: AppColors.white),
          cursorColor: AppColors.white,
          onSubmitted: (value) {
            context.read<TransactionHistoryBloc>().add(
              SearchTransactions(value),
            );
          },
          decoration: InputDecoration(
            suffixIcon: IconButton(
              icon: const Icon(Icons.send, color: AppColors.white),
              onPressed: () {
                context.read<TransactionHistoryBloc>().add(
                  SearchTransactions(_searchController.text),
                );
              },
            ),
            hintText: "Search",
            hintStyle: const TextStyle(color: AppColors.grey),
            filled: true,
            fillColor: AppColors.widget,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Filter tabs
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildFilterTab(
              context,
              'All',
              TransactionType.all,
              state.activeFilter == TransactionType.all,
            ),
            _buildFilterTab(
              context,
              'Spending',
              TransactionType.spending,
              state.activeFilter == TransactionType.spending,
            ),
            _buildFilterTab(
              context,
              'Income',
              TransactionType.income,
              state.activeFilter == TransactionType.income,
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Transaction list
        Expanded(
          child: state.transactions.isEmpty
              ? _buildEmptyState()
              : buildTransactionHistoryList(state.groupedTransactions),
        ),
      ],
    );
  }

  Widget _buildFilterTab(
    BuildContext context,
    String title,
    TransactionType type,
    bool isActive,
  ) {
    return GestureDetector(
      onTap: () {
        context.read<TransactionHistoryBloc>().add(
          FilterTransactionsByType(type),
        );
      },
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              color: isActive ? AppColors.main : AppColors.grey,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            height: 2,
            width: 50,
            color: isActive ? AppColors.main : AppColors.background,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long_outlined, color: AppColors.grey, size: 64),
          const SizedBox(height: 16),
          Text(
            'Không có giao dịch nào',
            style: TextStyle(color: AppColors.grey, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
