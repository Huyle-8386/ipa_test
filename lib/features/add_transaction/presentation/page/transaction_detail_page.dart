import 'package:fintrack/core/theme/app_colors.dart';
import 'package:fintrack/core/theme/app_text_styles.dart';
import 'package:fintrack/core/utils/size_utils.dart';
import 'package:fintrack/features/add_transaction/add_tx_injection.dart';
import 'package:fintrack/features/add_transaction/domain/entities/transaction_entity.dart';
import 'package:fintrack/features/add_transaction/presentation/bloc/transaction_detail_bloc.dart';
import 'package:fintrack/features/add_transaction/presentation/bloc/transaction_detail_event.dart';
import 'package:fintrack/features/add_transaction/presentation/bloc/transaction_detail_state.dart';
import 'package:fintrack/features/home/bloc/home_bloc.dart';
import 'package:fintrack/features/home/pages/home_page.dart';
import 'package:fintrack/features/navigation/pages/bottombar_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fintrack/features/add_transaction/presentation/page/edit_transaction_page.dart';

class TransactionDetailPage extends StatefulWidget {
  final TransactionEntity transaction;

  const TransactionDetailPage({super.key, required this.transaction});

  @override
  State<TransactionDetailPage> createState() => _TransactionDetailPageState();
}

class _TransactionDetailPageState extends State<TransactionDetailPage> {
  late TransactionEntity transaction;

  @override
  void initState() {
    super.initState();
    transaction = widget.transaction;
  }

  String _two(int n) => n.toString().padLeft(2, '0');

  String get _dateString {
    final d = transaction.dateTime;
    return "${d.year}-${_two(d.month)}-${_two(d.day)} ${_two(d.hour)}:${_two(d.minute)}";
  }

  String get _amountText => transaction.amount.toStringAsFixed(2);

  @override
  Widget build(BuildContext context) {
    final h = SizeUtils.height(context);
    final w = SizeUtils.width(context);
    final isIncome = transaction.isIncome;

    return BlocProvider<TransactionDetailBloc>(
      create: (_) => TransactionDetailBloc(
        deleteTx: sl(),
        initialState: TransactionDetailState(transaction: transaction),
      ),
      child: BlocConsumer<TransactionDetailBloc, TransactionDetailState>(
        listener: (context, state) {
          if (state.error != null && state.error!.isNotEmpty) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.error!)));
          }
        },
        builder: (context, state) {
          final deleting = state.isDeleting;
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              title: Text(
                "Transaction detail",
                style: AppTextStyles.body1.copyWith(color: AppColors.white),
              ),
              backgroundColor: AppColors.background,
              iconTheme: const IconThemeData(color: AppColors.white),
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: w * 0.05,
                vertical: h * 0.02,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.widget,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: w * 0.05,
                        vertical: h * 0.03,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                isIncome ? "Income" : "Expense",
                                style: AppTextStyles.body1.copyWith(
                                  color: isIncome
                                      ? Colors.greenAccent
                                      : AppColors.main,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: w * 0.04,
                                  vertical: h * 0.008,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.background,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: AppColors.main),
                                ),
                                child: Text(
                                  "\$$_amountText",
                                  style: AppTextStyles.body1.copyWith(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: h * 0.02),
                          _infoRow(
                            context,
                            label: "Category",
                            value: transaction.category.name,
                            trailing: _iconOrPlaceholder(
                              transaction.category.icon,
                            ),
                          ),
                          SizedBox(height: h * 0.015),
                          _infoRow(
                            context,
                            label: "Money source",
                            value: transaction.moneySource.name,
                            trailing: _iconOrPlaceholder(
                              transaction.moneySource.icon,
                            ),
                          ),
                          SizedBox(height: h * 0.015),
                          _infoRow(
                            context,
                            label: "Date",
                            value: _dateString,
                            trailing: const Icon(
                              Icons.calendar_today,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: h * 0.015),
                          if (transaction.merchant.trim().isNotEmpty)
                            _infoRow(
                              context,
                              label: "Merchant",
                              value: transaction.merchant,
                              multiline: true,
                            ),
                          SizedBox(height: h * 0.03),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(color: AppColors.main),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: deleting
                                      ? null
                                      : () => _showDeleteDialog(context, state),
                                  child: deleting
                                      ? SizedBox(
                                          height: 18,
                                          width: 18,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: AppColors.main,
                                          ),
                                        )
                                      : Text(
                                          "Delete",
                                          style: AppTextStyles.body2.copyWith(
                                            color: AppColors.main,
                                          ),
                                        ),
                                ),
                              ),
                              SizedBox(width: w * 0.04),
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.main,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: () async {
                                    final updated = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => EditTransactionPage(
                                          transaction: transaction,
                                        ),
                                      ),
                                    );
                                    if (updated is TransactionEntity) {
                                      setState(() {
                                        transaction = updated;
                                      });
                                      context.read<TransactionDetailBloc>().add(
                                        TransactionDetailUpdated(updated),
                                      );
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text('Transaction updated'),
                                        ),
                                      );
                                    }
                                  },
                                  child: Text(
                                    "Edit",
                                    style: AppTextStyles.body2,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: Container(
              color: AppColors.widget,
              padding: EdgeInsets.symmetric(
                horizontal: w * 0.05,
                vertical: h * 0.02,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.main),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(
                          context,
                        ); // back to add transaction to create another
                      },
                      child: Text(
                        "Add another",
                        style: AppTextStyles.body2.copyWith(
                          color: AppColors.main,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: w * 0.04),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.main,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const BottombarPage(),
                          ),
                        ); // done
                      },
                      child: Text("Done", style: AppTextStyles.body2),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _infoRow(
    BuildContext context, {
    required String label,
    required String value,
    Widget? trailing,
    bool multiline = false,
  }) {
    final textStyle = AppTextStyles.body1.copyWith(color: Colors.white);
    return Row(
      crossAxisAlignment: multiline
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.grey,
                  fontSize: 10,
                ),
              ),
              SizedBox(height: 6),
              Text(
                value,
                style: textStyle,
                maxLines: multiline ? null : 1,
                overflow: multiline
                    ? TextOverflow.visible
                    : TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        if (trailing != null) ...[SizedBox(width: 8), trailing],
      ],
    );
  }

  Widget _iconOrPlaceholder(String? iconPath) {
    final path = (iconPath ?? '').trim();
    if (path.isEmpty) {
      return const Icon(Icons.folder, color: Colors.white);
    }
    return Image.asset(path, height: 32, width: 32);
  }

  Future<void> _showDeleteDialog(
    BuildContext pageContext,
    TransactionDetailState state,
  ) {
    return showDialog(
      context: pageContext,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: SizeUtils.width(dialogContext) * 0.85,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.widget,
                borderRadius: BorderRadius.circular(20),
              ),
              child: BlocProvider.value(
                value: BlocProvider.of<TransactionDetailBloc>(pageContext),
                child: BlocConsumer<TransactionDetailBloc, TransactionDetailState>(
                  listener: (context, s) {
                    if (s.deleted) {
                      Navigator.of(dialogContext).pop(); // close dialog
                      Navigator.of(pageContext).pop(true); // close detail
                      ScaffoldMessenger.of(pageContext).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Transaction deleted and balance updated',
                          ),
                        ),
                      );
                    } else if (s.error != null && s.error!.isNotEmpty) {
                      ScaffoldMessenger.of(
                        pageContext,
                      ).showSnackBar(SnackBar(content: Text(s.error!)));
                    }
                  },
                  builder: (context, s) {
                    final deleting = s.isDeleting;
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 160,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.delete_outline,
                            color: Colors.white,
                            size: 64,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Delete transaction',
                          style: AppTextStyles.body1.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'This transaction will be permanently deleted and cannot be restored.',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(color: AppColors.main),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: deleting
                                    ? null
                                    : () => Navigator.of(dialogContext).pop(),
                                child: Text(
                                  'Cancel',
                                  style: AppTextStyles.body2.copyWith(
                                    color: AppColors.main,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.main,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: deleting
                                    ? null
                                    : () {
                                        BlocProvider.of<TransactionDetailBloc>(
                                          pageContext,
                                        ).add(
                                          TransactionDeleteRequested(
                                            s.transaction,
                                          ),
                                        );
                                      },
                                child: deleting
                                    ? const SizedBox(
                                        height: 18,
                                        width: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : Text(
                                        'Delete',
                                        style: AppTextStyles.body2,
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
