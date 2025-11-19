import 'dart:ui';

import 'package:fintrack/core/di/injector.dart' as di;
import 'package:fintrack/features/add_transaction/presentation/page/add_transaction_page.dart';

import 'package:fintrack/features/chart/chart_injection.dart';

import 'package:fintrack/features/setting/presentation/bloc/setting_bloc.dart';
import 'package:fintrack/features/setting/presentation/pages/setting_page.dart';

import 'package:flutter/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  await di.init();
  runApp(const MyApp());

  // Setup cửa sổ khi app khởi động
  doWhenWindowReady(() {
    const initialSize = Size(412, 892);
    // const initialSize = Size(412, 592); // Kích thước iPhone 12
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
      debugShowCheckedModeBanner: false,
      home: Builder(
        builder: (context) {
          return BlocProvider(
            create: (_) => sl<SettingBloc>()..add(LoadSettingCardsEvent()),
            child: const SettingPage(),
          );
        },
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
