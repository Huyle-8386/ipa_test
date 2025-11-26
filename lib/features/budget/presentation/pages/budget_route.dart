import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injector.dart' as di;
import '../bloc/budget_bloc.dart';
import '../bloc/budget_event.dart';
import '../bloc/category/category_bloc.dart';
import '../bloc/category/category_event.dart';
import '../bloc/money_sources/money_source_bloc.dart';
import '../bloc/money_sources/money_source_event.dart';
import 'add_budget_page.dart';
import 'budget_page.dart';
import 'update_budget_page.dart';
import '../../domain/entities/budget_entity.dart';

class BudgetRoute extends StatelessWidget {
  final String uid;
  const BudgetRoute({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<BudgetBloc>()..add(LoadBudgets(uid)),
      child: const BudgetPage(),
    );
  }
}

class AddBudgetRoute extends StatelessWidget {
  final BudgetBloc budgetBloc;
  const AddBudgetRoute({super.key, required this.budgetBloc});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: budgetBloc),
        BlocProvider(
          create: (_) =>
              di.sl<CategoryBloc>()..add(const LoadCategories(false)),
        ),
        BlocProvider(
          create: (_) => di.sl<MoneySourceBloc>()..add(LoadMoneySources(uid)),
        ),
      ],
      child: AddBudgetPage(),
    );
  }
}

class UpdateBudgetRoute extends StatelessWidget {
  final BudgetBloc budgetBloc;
  final BudgetEntity budget;
  const UpdateBudgetRoute({
    super.key,
    required this.budgetBloc,
    required this.budget,
  });

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: budgetBloc),
        BlocProvider(
          create: (_) =>
              di.sl<CategoryBloc>()..add(const LoadCategories(false)),
        ),
        BlocProvider(
          create: (_) => di.sl<MoneySourceBloc>()..add(LoadMoneySources(uid)),
        ),
      ],
      child: UpdateBudgetPage(budget: budget),
    );
  }
}
