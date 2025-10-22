import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/theme/app_theme.dart';
import 'routes/app_routes.dart';
import 'providers/timer_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  await Hive.openBox('userBox');

  runApp(const FocusBuddyApp());
}

class FocusBuddyApp extends StatelessWidget {
  const FocusBuddyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TimerProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'FocusBuddy',
        theme: buildAppTheme(),
        initialRoute: AppRoutes.splash,
        routes: AppRoutes.routes,
      ),
    );
  }
}
