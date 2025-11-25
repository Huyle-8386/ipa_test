import 'package:fintrack/core/theme/app_colors.dart';
import 'package:fintrack/core/theme/app_text_styles.dart';
// import 'package:fintrack/features/add_transaction/data/datasource/category.dart';
import 'package:fintrack/features/add_transaction/presentation/bloc/add_tx_bloc.dart';
import 'package:fintrack/features/add_transaction/presentation/bloc/add_tx_event.dart';
import 'package:fintrack/features/add_transaction/presentation/bloc/add_tx_state.dart';
import 'package:fintrack/features/add_transaction/presentation/widget/category_widget.dart';
import 'package:fintrack/features/add_transaction/presentation/widget/date_picker_field.dart';
import 'package:fintrack/features/add_transaction/presentation/widget/labeled_text_field.dart';
import 'package:fintrack/features/add_transaction/presentation/widget/money_source_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ManualForm extends StatelessWidget {
  final double h, w;
  final AddTxLoaded state;
  final TextEditingController amountCtrl, dateCtrl, moneyCtrl, merchantCtrl;

  const ManualForm({
    super.key,
    required this.h,
    required this.w,
    required this.state,
    required this.amountCtrl,
    required this.dateCtrl,
    required this.moneyCtrl,
    required this.merchantCtrl,
  });

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<AddTxBloc>();
    // Keep controllers in sync with bloc state so rebuilds don't lose user input/selection.
    if (amountCtrl.text != state.amount) amountCtrl.text = state.amount;
    if (dateCtrl.text != state.date) dateCtrl.text = state.date;
    if (moneyCtrl.text != (state.moneySource ?? '')) {
      moneyCtrl.text = state.moneySource ?? '';
    }
    if (merchantCtrl.text != state.merchant) {
      merchantCtrl.text = state.merchant;
    }
    return Container(
      decoration: BoxDecoration(
        color: AppColors.widget,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: w * 0.05, vertical: h * 0.03),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () =>
                      bloc.add(AddTxTypeChangedEvent(TransactionType.expense)),
                  child: Row(
                    children: [
                      Image.asset(
                        "assets/icons/expenses_add_transaction.png",
                        color: state.type == TransactionType.expense
                            ? AppColors.main
                            : AppColors.white,
                      ),
                      SizedBox(width: w * 0.02),
                      Text(
                        "Expenses",
                        style: AppTextStyles.body1.copyWith(
                          color: state.type == TransactionType.expense
                              ? AppColors.main
                              : AppColors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () =>
                      bloc.add(AddTxTypeChangedEvent(TransactionType.income)),
                  child: Row(
                    children: [
                      Image.asset(
                        "assets/icons/income_add_transaction.png",
                        color: state.type == TransactionType.income
                            ? AppColors.main
                            : AppColors.white,
                      ),
                      SizedBox(width: w * 0.02),
                      Text(
                        "Income",
                        style: AppTextStyles.body1.copyWith(
                          color: state.type == TransactionType.income
                              ? AppColors.main
                              : AppColors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: h * 0.02),
            LabeledTextField(
              controller: amountCtrl,
              label: 'Amount',
              hint: '0đ',
              keyboardType: TextInputType.number,
              errorText: state.amountError,
              onChanged: (v) => bloc.add(AddTxAmountChangedEvent(v)),
            ),
            SizedBox(height: h * 0.02),
            _buildCategoryList(context),
            SizedBox(height: h * 0.02),
            DatePickerField(
              controller: dateCtrl,
              label: 'Transaction date',
              pickTime: true,
              hint: 'Date',
              errorText: state.dateError,
              onDatePicked: (v) => bloc.add(AddTxDateChangedEvent(v)),
            ),
            SizedBox(height: h * 0.02),
            MoneySourceField(
              controller: moneyCtrl,
              label: "Money Source",
              hint: "Money Source",
              errorText: state.moneySourceError,
              onSelected: (v) => bloc.add(AddTxMoneySourceChangedEvent(v)),
            ),
            SizedBox(height: h * 0.02),
            LabeledTextField(
              controller: merchantCtrl,
              label: 'Merchant',
              hint: 'Enter merchant name',
              required: true,
              errorText: state.merchantError,
              onChanged: (v) => bloc.add(AddTxMerchantChangedEvent(v)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryList(BuildContext context) {
    final bloc = context.read<AddTxBloc>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: w * 0.05),
          child: Text(
            "Category",
            style: AppTextStyles.caption.copyWith(
              color: AppColors.grey,
              fontSize: 10,
            ),
          ),
        ),
        SizedBox(height: h * 0.01),
        SizedBox(
          height: h * 0.1,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: state.categories.length,
            itemBuilder: (context, index) {
              final item = state.categories[index];
              final selected = state.selectedCategory?.id == item.id;
              return Padding(
                padding: EdgeInsets.only(right: w * 0.04),
                child: GestureDetector(
                  onTap: () => bloc.add(AddTxCategorySelectedEvent(item)),
                  child: CategoryWidget(
                    category: item,
                    selected: selected,
                    showError: state.categoryError != null && !selected,
                  ),
                ),
              );
            },
          ),
        ),
        if (state.categoryError != null) ...[
          SizedBox(height: h * 0.008),
          Padding(
            padding: EdgeInsets.only(left: w * 0.02),
            child: Text(
              state.categoryError!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
        ],
      ],
    );
  }
}
