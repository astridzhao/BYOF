import 'package:astridzhao_s_food_app/core/app_export.dart';
import 'package:astridzhao_s_food_app/Interface/onboarding_first_time_download_screen/Signin/Signup/sign_in_one_screen.dart';
import 'package:astridzhao_s_food_app/Interface/onboarding_first_time_download_screen/feature_pages/featurethree_screen.dart';
import 'package:flutter/material.dart';

class CreateAccountPageScreen extends StatelessWidget {
  const CreateAccountPageScreen({Key? key})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(30.0), // here the desired height
          child: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent, 
          leading: IconButton(
            icon: const Icon(Icons.keyboard_backspace),
            tooltip: 'Back to home page',
            color: Colors.black54,
            iconSize: 20.0,
            splashColor: appTheme.orange_primary,
            onPressed: () {
              Navigator.of(context).pop(MaterialPageRoute(
                  builder: (context) => FeaturethreeScreen()));
            },
          ),
        ),),
        body: Container(
          width: double.maxFinite,
          decoration: AppDecoration.gradientGrayToGray,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 30.h,
                    top: 40.v,
                    right: 30.h,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomImageView(
                        imagePath: ImageConstant.create_account_page,
                        height: 370.v,
                        width: 256.h,
                        radius: BorderRadius.circular(
                          20.h,
                        ),
                      ),
                      SizedBox(height: 28.v),
                      Container(
                        width: 250.h,
                        decoration: AppDecoration.outlineBlack900,
                        child: Text(
                          "With BYOF, \nKickstart \na new cooking way",
                          maxLines: 3,
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: appTheme.black900,
                            fontSize: 28.fSize,
                            fontFamily: 'Outfit',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      SizedBox(height: 70.v),
                      _buildSigninButton(context),
                    ],
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
  Widget _buildSigninButton(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          height: 40, //height of button
          width: 100, //width of button
          child: ElevatedButton(
            child: Text("Sign in"),
            style: ElevatedButton.styleFrom(
              elevation: 3,
              backgroundColor: appTheme.green_primary,
            ),
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: ((context) => SignInOneScreen())));
            },
          ),
        ),
        SizedBox(height: 8.v),
        Align(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Create a new account? ",
                    style: TextStyle(
                        fontFamily: "Outfit",
                        fontSize: 13.fSize,
                        color: Color(0xFF424242)),
                  ),
                  TextSpan(
                    text: "Sign up.",
                    style: TextStyle(
                        fontFamily: "Outfit",
                        decoration: TextDecoration.underline,
                        fontSize: 13.fSize,
                        color: Color(0xFF424242)),
                  ),
                ],
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ),
      ],
    );
  }
}
