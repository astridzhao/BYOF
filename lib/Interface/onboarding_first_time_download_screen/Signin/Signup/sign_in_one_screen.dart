import 'package:astridzhao_s_food_app/core/app_export.dart';
import 'package:astridzhao_s_food_app/Interface/onboarding_first_time_download_screen/Signin/Signup/sign_in_two_screen.dart';
import 'package:astridzhao_s_food_app/Interface/onboarding_first_time_download_screen/Signin/Signup/sign_up_screen.dart';
import 'package:astridzhao_s_food_app/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class SignInOneScreen extends StatelessWidget {
  const SignInOneScreen({Key? key})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: AppDecoration.gradientGrayToGray,
          width: double.maxFinite,
          child: Column(
            children: [
              SizedBox(height: 120.v),
              Expanded(
                child: Column(
                  children: [
                    CustomImageView(
                      imagePath: ImageConstant.imgLogo2RemovebgPreview,
                      height: 270.v,
                      width: 288.h,
                      alignment: Alignment.center,
                    ),
                    Container(
                      decoration: AppDecoration.outlineBlack900,
                      child: Text(
                        "BRING YOUR OWN FRIDGE",
                        style: TextStyle(
                          color: appTheme.black900,
                          fontSize: 20.fSize,
                          fontFamily: 'Outfit',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // SizedBox(height: 40.v),
              _buildSignInButtonRow(context),
            ],
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildSignInButtonRow(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 36.h,
        vertical: 40.v,
      ),
      // decoration: AppDecoration.gradientGrayToGray,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomElevatedButton(
            height: 49.v,
            text: "Continue with Google",
            margin: EdgeInsets.only(
              left: 20.h,
              right: 20.h,
            ),
            leftIcon: Container(
              margin: EdgeInsets.only(right: 15.h),
              child: CustomImageView(
                imagePath: ImageConstant.imgGoogle1,
                height: 29.v,
                width: 30.h,
              ),
            ),
            buttonStyle: CustomButtonStyles.fillYellow,
          ),
          SizedBox(height: 16.v),
          CustomElevatedButton(
            height: 49.v,
            text: "Continue with Apple",
            margin: EdgeInsets.only(
              left: 20.h,
              right: 20.h,
            ),
            leftIcon: Container(
              margin: EdgeInsets.only(right: 15.h),
              child: CustomImageView(
                imagePath: ImageConstant.imgApplelogo1,
                height: 29.v,
                width: 30.h,
              ),
            ),
            buttonStyle: CustomButtonStyles.fillYellow,
          ),
          SizedBox(height: 16.v),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: 7.v,
                  bottom: 7.v,
                ),
                child: SizedBox(
                  width: 130.h,
                  child: Divider(color: appTheme.black900),
                ),
              ),
              Text(
                "or",
                style: TextStyle(
                  color: appTheme.black900,
                  fontSize: 12.fSize,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 8.v,
                  bottom: 7.v,
                ),
                child: SizedBox(
                  width: 130.h,
                  child: Divider(color: appTheme.black900),
                ),
              ),
            ],
          ),
          SizedBox(height: 13.v),
          SizedBox(
            height: 50, //height of button
            width: 270, //width of button
            child: ElevatedButton(
              child: Text("Sign in with email"),
              style: ElevatedButton.styleFrom(
                elevation: 3,
                backgroundColor: appTheme.green_primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: ((context) => SignInTwoScreen())));
              },
            ),
          ),
          SizedBox(height: 8.v),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Create a new account ? ",
                  style: theme.textTheme.bodyMedium,
                ),
                TextSpan(
                  text: "Sign up.",
                  recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: ((context) => SignUpScreen())));
                      },
                  style: CustomTextStyles.bodyMediumff5a7756.copyWith(
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.left,
          ),
          SizedBox(height: 4.v),
        ],
      ),
    );
  }
}
