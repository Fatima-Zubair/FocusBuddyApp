import 'package:flutter/material.dart';
import '../screens/splash_screen.dart';
// import '../screens/home_screen.dart';
import '../screens/timer_screen.dart';
// import '../screens/break_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String home = '/home';
  static const String focusTimer = '/focusTimer';
  static const String breakScreen = '/break';

  static Map<String, WidgetBuilder> routes = {
    splash: (context) => const SplashScreen(),
    // home: (context) => const HomeScreen(),
    focusTimer: (context) => const FocusTimerScreen(),
    // breakScreen: (context) => const BreakScreen(),
  };
}
