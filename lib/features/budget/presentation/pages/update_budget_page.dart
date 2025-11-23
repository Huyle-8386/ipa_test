import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/size_utils.dart';
import '../../domain/entities/budget_entity.dart';
import '../bloc/budget_bloc.dart';
import '../bloc/budget_event.dart';
import '../bloc/budget_state.dart';
import '../bloc/category/category_bloc.dart';
import '../bloc/category/category_state.dart';
import '../bloc/money_sources/money_source_bloc.dart';
import '../bloc/money_sources/money_source_state.dart';
import 'widgets/add/amount_input_field.dart';
import 'widgets/add/budget_name_field.dart';
import 'widgets/add/category_selector.dart';
import 'widgets/add/date_input_field.dart';
import 'widgets/add/money_source_dropdown.dart';
import 'widgets/add/spent_input_field.dart';

class UpdateBudgetPage extends StatefulWidget {
  final BudgetEntity budget;

  const UpdateBudgetPage({super.key, required this.budget});

  @override
  State<UpdateBudgetPage> createState() => _UpdateBudgetPageState();
}

class _UpdateBudgetPageState extends State<UpdateBudgetPage> {
  @override
  void initState() {
    super.initState();

    final bloc = context.read<BudgetBloc>();

    // Đổ dữ liệu ban đầu vào form (CHỈ 1 LẦN)
    bloc.add(AddNameChanged(widget.budget.name));
    bloc.add(AddAmountChanged(widget.budget.amount.toString()));
    bloc.add(AddCategoryChanged(widget.budget.categoryId));
    bloc.add(AddSourceChanged(widget.budget.sourceId));
    bloc.add(AddStartDateChanged(widget.budget.startDate));
    bloc.add(AddEndDateChanged(widget.budget.endDate));
    bloc.add(AddIsActiveChanged(widget.budget.isActive));
    bloc.add(AddSpentChanged(widget.budget.spent.toString()));
  }

  @override
  Widget build(BuildContext context) {
    final h = SizeUtils.height(context);
    final w = SizeUtils.width(context);

    return BlocListener<BudgetBloc, BudgetState>(
      listenWhen: (_, curr) => curr.updateSuccess == true,
      listener: (_, state) {
        Navigator.pop(context);
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          leading: const BackButton(color: AppColors.white),
          title: Text(
            "Update Budget",
            style: AppTextStyles.body1.copyWith(color: AppColors.white),
          ),
        ),
        bottomNavigationBar: _updateButton(context, h),
        body: _body(context, h, w),
      ),
    );
  }

  Widget _body(BuildContext context, double h, double w) {
    final state = context.watch<BudgetBloc>().state;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: w * 0.05, vertical: h * 0.02),
      child: Card(
        color: AppColors.widget,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(width: 1),
        ),
        child: Padding(
          padding: EdgeInsets.all(w * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AmountInputField(),
              SizedBox(height: h * 0.02),

              const SpentInputField(),
              SizedBox(height: h * 0.02),

              const BudgetNameField(),
              SizedBox(height: h * 0.03),

              Text(
                "Category",
                style: AppTextStyles.body2.copyWith(color: AppColors.grey),
              ),
              SizedBox(height: h * 0.01),

              BlocBuilder<CategoryBloc, CategoryState>(
                builder: (_, st) => st.loading
                    ? const CircularProgressIndicator()
                    : CategorySelector(categories: st.categories),
              ),
              SizedBox(height: h * 0.03),

              Text(
                "Money Source",
                style: AppTextStyles.body2.copyWith(color: AppColors.grey),
              ),
              SizedBox(height: h * 0.01),

              BlocBuilder<MoneySourceBloc, MoneySourceState>(
                builder: (_, st) => st.loading
                    ? const CircularProgressIndicator()
                    : MoneySourceDropdown(items: st.items),
              ),
              SizedBox(height: h * 0.03),

              _dateFields(context, h),
              SizedBox(height: h * 0.03),

              // Switch Active
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Active",
                    style: AppTextStyles.body2.copyWith(color: AppColors.grey),
                  ),
                  Switch(
                    value: state.addIsActive,
                    onChanged: (v) {
                      context.read<BudgetBloc>().add(AddIsActiveChanged(v));
                    },
                  ),
                ],
              ),
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

  Widget _updateButton(BuildContext context, double h) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: AppColors.widget,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.main,
          minimumSize: Size(double.infinity, h * 0.06),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {
          final uid = FirebaseAuth.instance.currentUser!.uid;
          context.read<BudgetBloc>().add(
            UpdateBudgetRequested(widget.budget, uid),
          );
        },
        child: Text(
          "Update Budget",
          style: AppTextStyles.body2.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
