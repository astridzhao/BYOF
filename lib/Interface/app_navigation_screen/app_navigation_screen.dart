import 'package:astridzhao_s_food_app/core/app_export.dart';
import 'package:flutter/material.dart';

class AppNavigationScreen extends StatelessWidget {
  const AppNavigationScreen({Key? key})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0XFFFFFFFF),
        body: SizedBox(
          width: double.maxFinite,
          child: Column(
            children: [
              _buildAppNavigation(context),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0XFFFFFFFF),
                    ),
                    child: Column(
                      children: [
                        _buildScreenTitle(
                          context,
                          screenTitle: "Loading",
                          onTapScreenTitle: () => onTapScreenTitle(
                              context, AppRoutes.loadingScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Onboarding-first time download",
                          onTapScreenTitle: () => onTapScreenTitle(context,
                              AppRoutes.onboardingFirstTimeDownloadScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "FeatureOne",
                          onTapScreenTitle: () => onTapScreenTitle(
                              context, AppRoutes.featureoneScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "FeatureTwo",
                          onTapScreenTitle: () => onTapScreenTitle(
                              context, AppRoutes.featuretwoScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "FeatureThree",
                          onTapScreenTitle: () => onTapScreenTitle(
                              context, AppRoutes.featurethreeScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Create account page",
                          onTapScreenTitle: () => onTapScreenTitle(
                              context, AppRoutes.createAccountPageScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Sign in-One",
                          onTapScreenTitle: () => onTapScreenTitle(
                              context, AppRoutes.signInOneScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Sign up",
                          onTapScreenTitle: () =>
                              onTapScreenTitle(context, AppRoutes.signUpScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Sign in -Two",
                          onTapScreenTitle: () => onTapScreenTitle(
                              context, AppRoutes.signInTwoScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Forget password",
                          onTapScreenTitle: () => onTapScreenTitle(
                              context, AppRoutes.forgetPasswordScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Function choose",
                          onTapScreenTitle: () => onTapScreenTitle(
                              context, AppRoutes.functionChooseScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Homepage - Container",
                          onTapScreenTitle: () => onTapScreenTitle(
                              context, AppRoutes.homepageContainerScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Create",
                          onTapScreenTitle: () =>
                              onTapScreenTitle(context, AppRoutes.createScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Create-Container",
                          onTapScreenTitle: () => onTapScreenTitle(
                              context, AppRoutes.createTwoScreen),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildAppNavigation(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0XFFFFFFFF),
      ),
      child: Column(
        children: [
          SizedBox(height: 10.v),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.h),
              child: Text(
                "App Navigation",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0XFF000000),
                  fontSize: 20.fSize,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          SizedBox(height: 10.v),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 20.h),
              child: Text(
                "Check your app's UI from the below demo screens of your app.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0XFF888888),
                  fontSize: 16.fSize,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          SizedBox(height: 5.v),
          Divider(
            height: 1.v,
            thickness: 1.v,
            color: Color(0XFF000000),
          ),
        ],
      ),
    );
  }

  /// Common widget
  Widget _buildScreenTitle(
    BuildContext context, {
    required String screenTitle,
    Function? onTapScreenTitle,
  }) {
    return GestureDetector(
      onTap: () {
        onTapScreenTitle!.call();
      },
      child: Container(
        decoration: BoxDecoration(
          color: Color(0XFFFFFFFF),
        ),
        child: Column(
          children: [
            SizedBox(height: 10.v),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.h),
                child: Text(
                  screenTitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0XFF000000),
                    fontSize: 20.fSize,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.v),
            SizedBox(height: 5.v),
            Divider(
              height: 1.v,
              thickness: 1.v,
              color: Color(0XFF888888),
            ),
          ],
        ),
      ),
    );
  }

  /// Common click event
  void onTapScreenTitle(
    BuildContext context,
    String routeName,
  ) {
    Navigator.pushNamed(context, routeName);
  }
}
