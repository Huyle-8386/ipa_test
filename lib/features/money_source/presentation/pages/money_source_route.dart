import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fintrack/core/di/injector.dart' as di;
import '../bloc/money_source_bloc.dart';
import '../bloc/money_source_event.dart';
import 'money_source_page.dart';

class MoneySourceRoute extends StatelessWidget {
  final String uid;
  const MoneySourceRoute({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<MoneySourceBloc>()..add(LoadMoneySources(uid: uid)),
      child: MoneySourcePage(uid: uid),
    );
  }
}
