import 'dart:ui';

// <<<<<<< HEAD
// import 'package:fintrack/features/onboarding/pages/onboarding_page_1.dart';
// =======
// import 'package:fintrack/features/home/bloc/home_bloc.dart';
// import 'package:fintrack/features/home/pages/home_page.dart';
// import 'package:fintrack/features/navigation/pages/bottombar_page.dart';
// >>>>>>> a9063fc (feature: bottom_bar)
import 'package:fintrack/features/auth/pages/sign_in_page.dart';
import 'package:fintrack/features/navigation/pages/bottombar_page.dart';

import 'package:flutter/material.dart';
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

  // @override
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     scrollBehavior: DesktopScrollBehavior(),
  //     home: BlocProvider(create: (context) =>
  //     HomeBloc(), child: HomePage()),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: DesktopScrollBehavior(),
      debugShowCheckedModeBanner: false,
      home: SignInPage(),
      
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
