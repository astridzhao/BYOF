import 'package:astridzhao_s_food_app/Interface/homepage_screen/homepage-container.dart';
import 'package:astridzhao_s_food_app/Interface/onboarding/Signin/Signup/sign_in_email_screen.dart';
import 'package:astridzhao_s_food_app/Interface/onboarding/Signin/Signup/sign_up_screen.dart';
import 'package:astridzhao_s_food_app/Interface/onboarding/onboarding_first_time_download_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthenticationFlowScreen extends StatelessWidget {
  const AuthenticationFlowScreen({super.key});
  static String id = 'main screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //StreamBuilder as a judge to check if the user is logged in or not
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return HomepageContainerScreen();
          } else {
            return OnboardingFirstTimeDownloadScreen();
          }
        },
      ),
    );
  }
}
