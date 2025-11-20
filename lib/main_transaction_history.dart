import 'dart:ui';

import 'package:fintrack/features/home/bloc/home_bloc.dart';
import 'package:fintrack/features/home/pages/home_page.dart';
import 'package:fintrack/features/transaction_%20history/presentation/pages/transaction_%20history_page.dart';
import 'package:flutter/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di/injector.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependency injection
  await init();

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
      home: BlocProvider(create: (context) => HomeBloc(), child: HomePage()),
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
