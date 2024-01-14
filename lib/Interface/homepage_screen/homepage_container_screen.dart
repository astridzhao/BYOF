import 'package:astridzhao_s_food_app/core/app_export.dart';
import 'package:astridzhao_s_food_app/Interface/Create_Recipe_screen/create_screen.dart';
import 'package:astridzhao_s_food_app/Interface/homepage_screen/homepage_page/homepage_page.dart';
import 'package:astridzhao_s_food_app/Interface/_favorites_screen.dart';
import 'package:astridzhao_s_food_app/Interface/myfridge_screen/_myfridge_screen.dart';
import 'package:astridzhao_s_food_app/Interface/onboarding_first_time_download_screen/onboarding_first_time_download_screen.dart';
import 'package:flutter/material.dart';
import 'package:botton_nav_bar/botton_nav_bar.dart';

// ignore_for_file: must_be_immutable
class HomepageContainerScreen extends StatelessWidget {
  HomepageContainerScreen({Key? key}) : super(key: key);

  GlobalKey<NavigatorState> navigatorKey = GlobalKey();

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
        bottomNavigationBar: BottomNavBar(
          fabChild: Text(
            'Create',
            style: TextStyle(color: Colors.black),
          ),
          notchedRadius: 30,
          centerNotched: false,
          fabIcon: GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => CreateScreen()));
            },
            child: Icon(Icons.create),
          ),
          fabBackGroundColor: Color(0xFF5A7756),
          bottomNavBarColor: Color(0xFFEDBA8E),
          bottomItems: <BottomBarItem>[
            BottomBarItem(
              bottomItemSelectedColor: Color(0xFF5A7756),
              label: 'Home',
              screen: HomepagePage(),
              selectedIcon: Icons.collections_bookmark_outlined,
            ),
            BottomBarItem(
              bottomItemSelectedColor: Color(0xFF5A7756),
              label: 'My Favorite',
              screen: FavoriteRecipePage(),
              selectedIcon: Icons.collections_bookmark_outlined,
            ),
            BottomBarItem(
              bottomItemSelectedColor: Color(0xFF5A7756),
              label: 'My Fridge',
              screen: MyfridgePage(),
              selectedIcon: Icons.notifications_active,
            ),
            BottomBarItem(
              bottomItemSelectedColor: Color(0xFF5A7756),
              label: 'Meal Plan',
              selectedIcon: Icons.dinner_dining_rounded,
              screen: OnboardingFirstTimeDownloadScreen(),
            ),
          ],
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
      default:
        return HomepagePage();
    }
  }
}
