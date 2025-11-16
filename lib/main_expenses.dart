import 'dart:ui';

import 'package:fintrack/features/expenses/presentation/bloc/expenses_bloc.dart';
import 'package:fintrack/features/expenses/presentation/pages/expenses_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';

void main() {
  runApp(const MyApp());

  // Setup cửa sổ khi app khởi động
  doWhenWindowReady(() {
    const initialSize = Size(412, 892); // Kích thước iPhone 12
    appWindow.minSize = initialSize;
    appWindow.size = initialSize;
    appWindow.alignment = Alignment.center; // Cửa sổ mở giữa màn hình
    appWindow.title = "Fintrack App";
    appWindow.show();
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: DesktopScrollBehavior(),
      home: BlocProvider(
        create: (context) => ExpensesBloc(),
        child: ExpensesPage(),
      ),
    );
  }
}

class DesktopScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.trackpad,
    PointerDeviceKind.stylus,
    PointerDeviceKind.unknown,
  };
}
