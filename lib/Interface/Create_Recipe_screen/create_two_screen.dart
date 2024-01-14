import 'package:astridzhao_s_food_app/Interface/Create_Recipe_screen/create_screen.dart';

import 'package:astridzhao_s_food_app/Interface/homepage_screen/homepage_page/homepage_page.dart';
import 'package:astridzhao_s_food_app/Interface/onboarding_first_time_download_screen/onboarding_first_time_download_screen.dart';

import 'package:astridzhao_s_food_app/core/app_export.dart';
import 'package:flutter/material.dart';
import 'package:botton_nav_bar/botton_nav_bar.dart';

/// Flutter code sample for [AppBar].

// ignore_for_file: must_be_immutable
class CreateTwoScreen extends StatelessWidget {
  CreateTwoScreen({Key? key}) : super(key: key);
  GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: appTheme.yellow5001,
      resizeToAvoidBottomInset: false,
      body: Container(child: CreateScreen()),
      // body: Navigator(
      //     key: navigatorKey,
      //     initialRoute: AppRoutes.createScreen,
      //     onGenerateRoute: (routeSetting) => PageRouteBuilder(
      //         pageBuilder: (ctx, ani, ani1) =>
      //             getCurrentPage(routeSetting.name!),
      //         transitionDuration: Duration(seconds: 0))),
      // body: Stack(children: [
      //   SingleChildScrollView(
      //       child: Container(
      //           height: 1108.v,
      //           width: double.maxFinite,
      //           margin: EdgeInsets.only(bottom: 6.v),
      //           child: Stack(alignment: Alignment.bottomCenter, children: [
      //             Align(
      //                 alignment: Alignment.topCenter,
      //                 child: Padding(
      //                     padding: EdgeInsets.only(left: 30.h, right: 30.h),
      //                     child:
      //                         Column(mainAxisSize: MainAxisSize.min, children: [
      //                       SizedBox(height: 40.v),
      //                       _buildIngredientInputSection(context),
      //                       SizedBox(height: 40.v),
      //                       _buildCreateTwoGridSection(context),
      //                       SizedBox(height: 40.v),
      //                     ]))),
      //           ]))),
      // ]),

      bottomNavigationBar: BottomNavBar(
        fabChild: Text(
          'Create',
          style: TextStyle(color: Colors.black),
        ),
        notchedRadius: 30,
        centerNotched: false,
        fabIcon: GestureDetector(
          onTap: () {},
          child: Icon(Icons.create),
        ),
        fabBackGroundColor: Color(0xFF5A7756),
        bottomNavBarColor: Color(0xFFEDBA8E),
        bottomItems: <BottomBarItem>[
          BottomBarItem(
            bottomItemSelectedColor: Color(0xFF5A7756),
            label: 'Screen 1',
            screen: HomepagePage(),
            selectedIcon: Icons.collections_bookmark_outlined,
          ),
          BottomBarItem(
            bottomItemSelectedColor: Color(0xFF5A7756),
            label: 'Screen 2',
            screen: CreateScreen(),
            selectedIcon: Icons.search_rounded,
          ),
          BottomBarItem(
            bottomItemSelectedColor: Color(0xFF5A7756),
            label: 'Screen 3',
            selectedIcon: Icons.menu_open_rounded,
            screen: OnboardingFirstTimeDownloadScreen(),
          ),
          BottomBarItem(
            bottomItemSelectedColor: Color(0xFF5A7756),
            label: 'Screen 4',
            screen: const Text('D'),
            selectedIcon: Icons.notifications_active,
          )
        ],
      ),
    ));
    // bottomNavigationBar: _buildBottomBar(context)));
  }

  Widget getCurrentPage(String currentRoute) {
    switch (currentRoute) {
      case AppRoutes.createScreen:
        return CreateScreen();
      default:
        return CreateScreen();
    }
  }
}
