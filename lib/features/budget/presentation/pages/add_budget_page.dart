import 'package:fintrack/features/budget/presentation/bloc/budget_bloc.dart';
import 'package:fintrack/features/budget/presentation/bloc/category/category_bloc.dart';
import 'package:fintrack/features/budget/presentation/pages/widgets/add/amount_input_field.dart';
import 'package:fintrack/features/budget/presentation/pages/widgets/add/budget_name_field.dart';
import 'package:fintrack/features/budget/presentation/pages/widgets/add/category_selector.dart';
import 'package:fintrack/features/budget/presentation/pages/widgets/add/date_input_field.dart';
import 'package:fintrack/features/budget/presentation/pages/widgets/add/money_source_dropdown.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fintrack/core/theme/app_colors.dart';
import 'package:fintrack/core/theme/app_text_styles.dart';
import 'package:fintrack/core/utils/size_utils.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injector.dart';
import '../bloc/budget_event.dart';
import '../bloc/budget_state.dart';
import '../bloc/category/category_event.dart';
import '../bloc/category/category_state.dart';
import '../bloc/money_sources/money_source_bloc.dart';
import '../bloc/money_sources/money_source_event.dart';
import '../bloc/money_sources/money_source_state.dart';

class AddBudgetPage extends StatelessWidget {
  AddBudgetPage({super.key});

  // final categories = [
  //   "Groceries",
  //   "Food",
  //   "Shopping",
  //   "Health",
  //   "Transport",
  //   "Bills",
  //   "Entertainment",
  // ];

  @override
  Widget build(BuildContext context) {
    final h = SizeUtils.height(context);
    final w = SizeUtils.width(context);

    return BlocListener<BudgetBloc, BudgetState>(
      listenWhen: (_, curr) => curr.addSuccess == true,
      listener: (_, state) {
        Navigator.pop(context);
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          leading: const BackButton(color: AppColors.white),
          title: Text(
            "Budget",
            style: AppTextStyles.body1.copyWith(color: AppColors.white),
          ),
        ),
        bottomNavigationBar: _submitButton(context, h, w),
        body: _body(context, h, w),
      ),
    );
  }

  Widget _body(BuildContext context, double h, double w) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: w * 0.05, vertical: h * 0.02),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16), // bo góc
          side: BorderSide(
            width: 1, // độ dày viền
          ),
        ),
        color: AppColors.widget, // màu nền
        elevation: 4, // độ bóng
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: w * 0.05,
            vertical: h * 0.02,
          ),
          child: Column(
            children: [
              const AmountInputField(),
              SizedBox(height: h * 0.02),
              const BudgetNameField(),
              SizedBox(height: h * 0.03),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Category",
                  style: AppTextStyles.body2.copyWith(color: AppColors.grey),
                ),
              ),
              SizedBox(height: h * 0.01),
              // BlocProvider(
              //   create: (_) =>
              //       sl<CategoryBloc>()..add(const LoadCategories(false)),
              //   child: BlocBuilder<CategoryBloc, CategoryState>(
              //     builder: (context, state) {
              //       if (state.loading) return CircularProgressIndicator();

              //       return CategorySelector(categories: state.categories);
              //     },
              //   ),
              // ),
              BlocBuilder<CategoryBloc, CategoryState>(
                builder: (context, state) {
                  if (state.loading) return CircularProgressIndicator();
                  return CategorySelector(categories: state.categories);
                },
              ),

              SizedBox(height: h * 0.03),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Money Source",
                  style: AppTextStyles.body2.copyWith(color: AppColors.grey),
                ),
              ),
              SizedBox(height: h * 0.01),
              BlocBuilder<MoneySourceBloc, MoneySourceState>(
                builder: (context, state) {
                  if (state.loading) return CircularProgressIndicator();
                  return MoneySourceDropdown(items: state.items);
                },
              ),

              SizedBox(height: h * 0.03),
              _dateFields(context, h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dateFields(BuildContext context, double h) {
    final state = context.watch<BudgetBloc>().state;

    String fmt(DateTime d) =>
        "${d.day.toString().padLeft(2, '0')}/${d.month}/${d.year}";

    return Column(
      children: [
        DateInputField(label: "Start Date", value: fmt(state.addStartDate)),
        SizedBox(height: h * 0.02),
        DateInputField(label: "End Date", value: fmt(state.addEndDate)),
      ],
    );
  }

  Widget _submitButton(BuildContext context, double h, double w) {
    return Container(
      padding: EdgeInsets.all(16),
      color: AppColors.widget,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.main,
          minimumSize: Size(double.infinity, h * 0.06),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () async {
          //  Lấy UID
          final uid = FirebaseAuth.instance.currentUser!.uid;

          print("👉 ADD pressed");
          print("name: ${context.read<BudgetBloc>().state.addName}");
          print("amount: ${context.read<BudgetBloc>().state.addAmount}");
          print("category: ${context.read<BudgetBloc>().state.addCategory}");
          print("source: ${context.read<BudgetBloc>().state.addSource}");
          print("start: ${context.read<BudgetBloc>().state.addStartDate}");
          print("end: ${context.read<BudgetBloc>().state.addEndDate}");
          print("uid: $uid");

          //  Gửi event add
          context.read<BudgetBloc>().add(AddBudgetRequested(uid));

          // //  Đợi 1 chút để save xong rồi quay lại
          // await Future.delayed(const Duration(milliseconds: 400));

          // Navigator.pop(context); // quay về trang Budget
        },
        child: Text(
          "Add Budget",
          style: AppTextStyles.body2.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
