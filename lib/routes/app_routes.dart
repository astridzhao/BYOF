import 'package:flutter/material.dart';
import 'package:astridzhao_s_food_app/Interface/loading_screen.dart';
import 'package:astridzhao_s_food_app/Interface/onboarding_first_time_download_screen/onboarding_first_time_download_screen.dart';
import 'package:astridzhao_s_food_app/Interface/onboarding_first_time_download_screen/feature_pages/featureone_screen.dart';
import 'package:astridzhao_s_food_app/Interface/onboarding_first_time_download_screen/feature_pages/featuretwo_screen.dart';
import 'package:astridzhao_s_food_app/Interface/onboarding_first_time_download_screen/feature_pages/featurethree_screen.dart';
import 'package:astridzhao_s_food_app/Interface/onboarding_first_time_download_screen/Signin/Signup/create_account_page_screen.dart';
import 'package:astridzhao_s_food_app/Interface/onboarding_first_time_download_screen/Signin/Signup/sign_in_one_screen.dart';
import 'package:astridzhao_s_food_app/Interface/onboarding_first_time_download_screen/Signin/Signup/sign_up_screen.dart';
import 'package:astridzhao_s_food_app/Interface/onboarding_first_time_download_screen/Signin/Signup/sign_in_two_screen.dart';
import 'package:astridzhao_s_food_app/Interface/onboarding_first_time_download_screen/Signin/Signup/forget_password_screen.dart';
import 'package:astridzhao_s_food_app/Interface/onboarding_first_time_download_screen/function_choose_screen.dart';
import 'package:astridzhao_s_food_app/Interface/homepage_screen/homepage-container.dart';
import 'package:astridzhao_s_food_app/Interface/backup_screens/old-create_screen.dart';
import 'package:astridzhao_s_food_app/Interface/myfridge_screen/_myfridge_screen.dart';
import 'package:astridzhao_s_food_app/Interface/backup_screens/old-favorites_screen.dart';
import 'package:astridzhao_s_food_app/Interface/app_navigation_screen/app_navigation_screen.dart';

class AppRoutes {
  static const String loadingScreen = '/loading_screen';

  static const String onboardingFirstTimeDownloadScreen =
      '/onboarding_first_time_download_screen';

  static const String featureoneScreen = '/featureone_screen';

  static const String featuretwoScreen = '/featuretwo_screen';

  static const String featurethreeScreen = '/featurethree_screen';

  static const String createAccountPageScreen = '/create_account_page_screen';

  static const String signInOneScreen = '/sign_in_one_screen';

  static const String signUpScreen = '/sign_up_screen';

  static const String signInTwoScreen = '/sign_in_two_screen';

  static const String forgetPasswordScreen = '/forget_password_screen';

  static const String functionChooseScreen = '/function_choose_screen';

  static const String homepagePage = '/homepage_page';

  static const String homepageContainerScreen = '/homepage_container_screen';

  static const String createScreen = '/create_screen';

  static const String createTwoScreen = '/create_two_screen';

  static const String myFridgeScreen = '/_myfridge_screen';

  static const String myFavoriteScreen = '/_favorites_screen';

  static const String generationScreen = '/generation_screen';

  static const String appNavigationScreen = '/app_navigation_screen';

  static Map<String, WidgetBuilder> routes = {
    loadingScreen: (context) => LoadingScreen(),
    onboardingFirstTimeDownloadScreen: (context) =>
        OnboardingFirstTimeDownloadScreen(),
    featureoneScreen: (context) => FeatureoneScreen(),
    featuretwoScreen: (context) => FeaturetwoScreen(),
    featurethreeScreen: (context) => FeaturethreeScreen(),
    createAccountPageScreen: (context) => CreateAccountPageScreen(),
    signInOneScreen: (context) => SignInOneScreen(),
    signUpScreen: (context) => SignUpScreen(),
    signInTwoScreen: (context) => SignInTwoScreen(),
    forgetPasswordScreen: (context) => ForgetPasswordScreen(),
    functionChooseScreen: (context) => FunctionChooseScreen(),
    homepageContainerScreen: (context) => HomepageContainerScreen(),
    createScreen: (context) => CreateScreen(),
    myFridgeScreen: (context) => MyfridgePage(),
    myFavoriteScreen: (context) => FavoriteRecipePage(),
    appNavigationScreen: (context) => AppNavigationScreen()
  };
}
