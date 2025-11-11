import 'package:fintrack/core/theme/app_colors.dart';
import 'package:fintrack/core/theme/app_text_styles.dart';
import 'package:fintrack/core/utils/size_utils.dart';
import 'package:fintrack/features/add_transaction/data/datasource/category.dart';
import 'package:fintrack/features/add_transaction/presentation/widget/category_widget.dart';
import 'package:fintrack/features/add_transaction/presentation/widget/date_picker_field.dart';
import 'package:fintrack/features/add_transaction/presentation/widget/labeled_text_field.dart';
import 'package:fintrack/features/add_transaction/presentation/widget/money_source_field.dart';
import 'package:flutter/material.dart';

class AddTransactionPage extends StatefulWidget {
  const AddTransactionPage({super.key});

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _moneyController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  TransactionType _type = TransactionType.expense;
  List<Category> get _categories =>
      _type == TransactionType.expense ? expenseCategories : incomeCategories;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final h = SizeUtils.height(context);
    final w = SizeUtils.width(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          "Add transaction",
          style: AppTextStyles.body1.copyWith(color: AppColors.white),
          // style: AppTextStyles.body1.copyWith(color: AppColors.grey),
        ),
        backgroundColor: AppColors.background,
      ),
      body: Container(
        height: h,
        width: w,
        child: Column(
          children: [
            Container(
              height: h * 0.1,
              width: w,
              decoration: BoxDecoration(color: AppColors.widget),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: h * 0.02),
                          child: Column(
                            children: [
                              Image.asset("assets/icons/manual_entry.png"),
                              Text(
                                "Manual Entry",
                                style: AppTextStyles.body2.copyWith(
                                  color: AppColors.main,
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: h * 0.027),
                        Container(
                          width: w * 0.5,
                          height: h * 0.002,
                          decoration: BoxDecoration(color: AppColors.main),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/icons/image_entry.png"),
                        Text(
                          "Image Entry",
                          style: AppTextStyles.body2.copyWith(
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: h * 0.01),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: w * 0.05,
                vertical: h * 0.03,
              ),
              child: Container(
                height: h * 0.6,
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
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: () =>
                                setState(() => _type = TransactionType.expense),
                            child: Row(
                              children: [
                                Image.asset(
                                  "assets/icons/expenses_add_transaction.png",
                                  color: _type == TransactionType.expense
                                      ? AppColors.main
                                      : AppColors.white,
                                ),
                                SizedBox(width: w * 0.02),
                                Text(
                                  "Expenses",
                                  style: AppTextStyles.body1.copyWith(
                                    color: _type == TransactionType.expense
                                        ? AppColors.main
                                        : AppColors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () =>
                                setState(() => _type = TransactionType.income),
                            child: Row(
                              children: [
                                Image.asset(
                                  "assets/icons/income_add_transaction.png",
                                  color: _type == TransactionType.income
                                      ? AppColors.main
                                      : AppColors.white,
                                ),
                                SizedBox(width: w * 0.02),
                                Text(
                                  "Income ",
                                  style: AppTextStyles.body1.copyWith(
                                    color: _type == TransactionType.income
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
                      Row(
                        children: [
                          Expanded(
                            child: LabeledTextField(
                              controller: _amountController,
                              label: 'Amount',
                              hint: '0đ',
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: h * 0.02),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
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
                                    itemCount: _categories.length,
                                    itemBuilder: (context, index) {
                                      final item = _categories[index];
                                      return Padding(
                                        padding: EdgeInsets.only(
                                          right: w * 0.04,
                                        ), // tạo khoảng cách
                                        child: CategoryWidget(category: item),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: h * 0.02),

                      Row(
                        children: [
                          Expanded(
                            child: DatePickerField(
                              controller: _dateController,
                              label: 'Transaction date',
                              pickTime: true,
                              hint: 'Date',
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: h * 0.02),
                      Row(
                        children: [
                          Expanded(
                            child: MoneySourceField(
                              controller: _moneyController,
                              label: "Money Source",
                              hint: "Money Source",
                              onSelected: (value) {
                                print("User chọn: $value");
                              },
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: h * 0.02),
                      Row(
                        children: [
                          Expanded(
                            child: LabeledTextField(
                              controller: _noteController,
                              label: 'Note',
                              hint: 'Enter transaction description',
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: AppColors.widget,
        child: Container(
          height: h * 0.1,
          decoration: BoxDecoration(
            color: AppColors.main,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              _type == TransactionType.expense
                  ? "Add expense transaction"
                  : "Add income transaction",
              style: AppTextStyles.body2.copyWith(),
            ),
          ),
        ),
      ),
    );
  }
}
