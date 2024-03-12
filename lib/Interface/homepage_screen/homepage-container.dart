import 'package:astridzhao_s_food_app/Interface/homepage_screen/homepage_page/homepage_screen.dart';
import 'package:astridzhao_s_food_app/Interface/meal_plan_screen/mealplan_main.dart';
import 'package:astridzhao_s_food_app/core/app_export.dart';
import 'package:astridzhao_s_food_app/Interface/backup_screens/old-create_screen.dart';
import 'package:astridzhao_s_food_app/Interface/backup_screens/NoAccount-home-screen.dart';
import 'package:astridzhao_s_food_app/Interface/favorite_page/myfavorite-screen.dart';
import 'package:astridzhao_s_food_app/Interface/myfridge_screen/_myfridge_screen.dart';
import 'package:astridzhao_s_food_app/Interface/create_recipe_screen/creation-screen.dart';
import 'package:flutter/material.dart';
// import 'package:botton_nav_bar/botton_nav_bar.dart';
import 'package:astridzhao_s_food_app/Interface/homepage_screen/bottom_bar.dart';

// ignore_for_file: must_be_immutable
class HomepageContainerScreen extends StatefulWidget {
  static String id = 'home_screen';
  // const HomeScreen({super.key});
  const HomepageContainerScreen({Key? key}) : super(key: key);

  _HomepageContainerScreenState createState() =>
      _HomepageContainerScreenState();
}

class _HomepageContainerScreenState extends State<HomepageContainerScreen> {
  GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    // Get the screen width and height
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Define responsive sizes based on screen dimensions
    double navBarHeight = screenHeight * 0.08; // 8% of the screen height
    double navBarWidth = screenWidth * 0.9;

    return SafeArea(
      // bottom: false,
      // top: false,
      child: Scaffold(
        // backgroundColor: appTheme.yellow5001,
        body: Navigator(
            key: navigatorKey,
            initialRoute: AppRoutes.homepagePage,
            onGenerateRoute: (routeSetting) => PageRouteBuilder(
                pageBuilder: (ctx, ani, ani1) =>
                    getCurrentPage(routeSetting.name!),
                transitionDuration: Duration(seconds: 0))),
        bottomNavigationBar: BottomNavBar(
          // height: navBarHeight,
          notchedRadius: 20,
          centerNotched: false,
          fabIcon: Icon(Icons.create),
          fabIconPress: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => Azure_CreateScreen()));
          },
          fabBackGroundColor: appTheme.yellow_secondary,
          bottomItems: <BottomBarItem>[
            BottomBarItem(
              bottomItemSelectedColor: appTheme.yellow_secondary,
              label: 'Home',
              screen: HomePage(),
              selectedIcon: Icons.home,
            ),
            BottomBarItem(
              bottomItemSelectedColor: appTheme.yellow_secondary,
              label: 'My Fav',
              screen: FavoriteRecipePage2(),
              selectedIcon: Icons.collections_bookmark_outlined,
            ),
            BottomBarItem(
              bottomItemSelectedColor: appTheme.yellow_secondary,
              label: 'Meal Plan',
              selectedIcon: Icons.dinner_dining_rounded,
              screen: MealPlan_mainScreen(),
              // screen: GenerationScreen(resultCompletion: resultCompletion),
            ),
            BottomBarItem(
              bottomItemSelectedColor: appTheme.yellow_secondary,
              label: 'My Fridge',
              screen: MyfridgePage(),
              selectedIcon: Icons.notifications_active,
            ),
          ],
        ),
      ),
    );
  }

  ///Handling page based on route
  Widget getCurrentPage(String currentRoute) {
    switch (currentRoute) {
      case AppRoutes.homepagePage:
        return HomePage();
      case AppRoutes.createScreen:
        return CreateScreen();
      case AppRoutes.myFavoriteScreen:
        return FavoriteRecipePage2();
      case AppRoutes.myFridgeScreen:
        return MyfridgePage();
      default:
        return HomePage();
    }
  }
}
