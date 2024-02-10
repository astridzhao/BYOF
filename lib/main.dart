import 'package:astridzhao_s_food_app/Interface/homepage_screen/homepage-container.dart';
import 'package:astridzhao_s_food_app/Interface/loading_screen.dart';
import 'package:astridzhao_s_food_app/Interface/onboarding/Signin/Signup/authentication_page.dart';
import 'package:astridzhao_s_food_app/bloc/authentication_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/app_export.dart';
import 'package:astridzhao_s_food_app/Interface/provider_SavingsModel.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

var globalMessengerKey = GlobalKey<ScaffoldMessengerState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  final prefs = await SharedPreferences.getInstance();

  ///Please update theme as per your need if required.
  ThemeHelper().changeTheme('primary');

  await Firebase.initializeApp();
  runApp(
    ChangeNotifierProvider(
      create: (context) => SavingsModel(prefs: prefs),
      child: MyApp(prefs: prefs),
    ),
  );
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;

  MyApp({required this.prefs});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SavingsModel(prefs: prefs)),
        BlocProvider(create: (context) => AuthenticationBloc()),
      ],
      child: Sizer(
        builder: (context, orientation, deviceType) {
          return MaterialApp(
            theme: theme,
            title: 'astridzhao_s_food_app',
            debugShowCheckedModeBanner: false,
            home: const AuthenticationFlowScreen(),
            routes: {
              AuthenticationFlowScreen.id: (context) =>
                  const AuthenticationFlowScreen(),
              // Define other static routes here
            },
            onGenerateRoute: (settings) {
              if (settings.name == HomepageContainerScreen.id) {
                return MaterialPageRoute(
                    builder: (context) => HomepageContainerScreen());
              }
            },
            onUnknownRoute: (settings) {
              print("called onUnknownRoute");
              return MaterialPageRoute(
                  builder: (context) => HomepageContainerScreen());
              // builder: (context) => UndefinedRouteScreen(name: settings.name));
            },
          );
        },
      ),
    );
  }
}
