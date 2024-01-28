import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/app_export.dart';
import 'package:astridzhao_s_food_app/Interface/provider.dart';
import 'package:provider/provider.dart';

var globalMessengerKey = GlobalKey<ScaffoldMessengerState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  final prefs = await SharedPreferences.getInstance();

  ///Please update theme as per your need if required.
  ThemeHelper().changeTheme('primary');
  runApp(
    ChangeNotifierProvider(
      create: (context) => SavingsModel(prefs: prefs),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          theme: theme,
          title: 'astridzhao_s_food_app',
          debugShowCheckedModeBanner: false,
          initialRoute: AppRoutes.homepageContainerScreen,
          routes: AppRoutes.routes,
        );
      },
    );
  }
}
