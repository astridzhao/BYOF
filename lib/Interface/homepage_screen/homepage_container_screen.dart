import 'package:astridzhao_s_food_app/core/app_export.dart';
import 'package:astridzhao_s_food_app/Interface/Create_Recipe_screen/create_screen.dart';
import 'package:astridzhao_s_food_app/Interface/homepage_screen/homepage_page/homepage_page.dart';
import 'package:astridzhao_s_food_app/Interface/_favorites_screen.dart';
import 'package:astridzhao_s_food_app/Interface/myfridge_screen/_myfridge_screen.dart';
import 'package:flutter/material.dart';
// import 'package:botton_nav_bar/botton_nav_bar.dart';
import 'package:astridzhao_s_food_app/Interface/homepage_screen/bottom_bar.dart';

// ignore_for_file: must_be_immutable
class HomepageContainerScreen extends StatefulWidget {
  HomepageContainerScreen({Key? key}) : super(key: key);

  _HomepageContainerScreenState createState() =>
      _HomepageContainerScreenState();
}

class _HomepageContainerScreenState extends State<HomepageContainerScreen> {
  GlobalKey<NavigatorState> navigatorKey = GlobalKey();
  // Function to navigate to CreateScreen
  void navigateToCreateScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => CreateScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: appTheme.yellow5001,
        body: Navigator(
            key: navigatorKey,
            initialRoute: AppRoutes.homepagePage,
            onGenerateRoute: (routeSetting) => PageRouteBuilder(
                pageBuilder: (ctx, ani, ani1) =>
                    getCurrentPage(routeSetting.name!),
                transitionDuration: Duration(seconds: 0))),
        bottomNavigationBar: Container(
          child: BottomNavBar(
            notchedRadius: 20,
            centerNotched: false,
            fabIcon: Icon(Icons.emoji_events),
            fabBackGroundColor:appTheme.yellow_secondary,
            bottomItems: <BottomBarItem>[
              BottomBarItem(
                bottomItemSelectedColor: appTheme.yellow_secondary,
                label: 'Home',
                screen: HomepagePage(),
                selectedIcon: Icons.home,
              ),
              BottomBarItem(
                bottomItemSelectedColor: appTheme.yellow_secondary,
                label: 'My Favorite',
                screen: FavoriteRecipePage(),
                selectedIcon: Icons.collections_bookmark_outlined,
              ),
              BottomBarItem(
                bottomItemSelectedColor: appTheme.yellow_secondary,
                label: 'Create',
                selectedIcon: Icons.dinner_dining_rounded,
                screen: CreateScreen(),
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
      ),
    );
  }

  /// Section Widget
//   Widget _buildBottomBar(BuildContext context) {
//     return CustomBottomBar(onChanged: (BottomBarEnum type) {
//       Navigator.pushNamed(navigatorKey.currentContext!, getCurrentRoute(type));
//     });
//   }

//   ///Handling route based on bottom click actions
//   String getCurrentRoute(BottomBarEnum type) {
//     switch (type) {
//       case BottomBarEnum.Iconbutton:
//         return AppRoutes.homepagePage;
//       default:
//         return "/";
//     }
//   }
//     Widget _buildCreateRecipeButton(BuildContext context) {
//     return Positioned(
//       child: CustomElevatedButton(
//         alignment: Alignment.bottomCenter,
//         height: 48.v,
//         width: 160.h, // This ensures the button stretches across the width
//         text: "Create Recipe",
//         buttonTextStyle: TextStyle(
//           fontSize: 16, // Example size
//           fontWeight: FontWeight.bold, // Example weight
//           color: Colors.white, // Example color
//         ),
//         buttonStyle: CustomButtonStyles.fillYellow,
//         onPressed: () {
//           _navigateToNextScreen(context);
//         },
//       ),
//     );
//   }

  ///Handling page based on route
  Widget getCurrentPage(String currentRoute) {
    switch (currentRoute) {
      case AppRoutes.homepagePage:
        return HomepagePage();
      case AppRoutes.createScreen:
        return CreateScreen();
      case AppRoutes.myFavoriteScreen:
        return FavoriteRecipePage();
      case AppRoutes.myFridgeScreen:
        return MyfridgePage();
      default:
        return HomepagePage();
    }
  }
}
