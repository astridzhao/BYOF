import 'package:astridzhao_s_food_app/core/app_export.dart';
import 'package:astridzhao_s_food_app/Interface/onboarding/Signin/Signup/sign_in_email_screen.dart';
import 'package:astridzhao_s_food_app/Interface/onboarding/Signin/Signup/sign_up_screen.dart';
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
    return Scaffold(
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
          // CustomElevatedButton(
          //   height: MediaQuery.of(context).size.height * 0.06,
          //   text: "Continue with Google",
          //   margin: EdgeInsets.only(
          //     left: 20.h,
          //     right: 20.h,
          //   ),
          //   leftIcon: Container(
          //     margin: EdgeInsets.only(right: 15.h),
          //     child: CustomImageView(
          //       imagePath: ImageConstant.imgGoogle1,
          //       height: 29.v,
          //       width: 30.h,
          //     ),
          //   ),
          //   buttonStyle: CustomButtonStyles.fillYellow,
          // ),
          // SizedBox(height: 16.v),
          // CustomElevatedButton(
          //   height: MediaQuery.of(context).size.height * 0.06,
          //   text: "Continue with Apple",
          //   margin: EdgeInsets.only(
          //     left: 20.h,
          //     right: 20.h,
          //   ),
          //   leftIcon: Container(
          //     margin: EdgeInsets.only(right: 15.h),
          //     child: CustomImageView(
          //       imagePath: ImageConstant.imgApplelogo1,
          //       height: 29.v,
          //       width: 30.h,
          //     ),
          //   ),
          //   buttonStyle: CustomButtonStyles.fillYellow,
          // ),
          // SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Padding(
          //       padding: EdgeInsets.only(
          //         top: 7.v,
          //         bottom: 7.v,
          //       ),
          //       child: SizedBox(
          //         width: 130.h,
          //         child: Divider(color: appTheme.black900),
          //       ),
          //     ),
          //     Text(
          //       "or",
          //       style: TextStyle(
          //         color: appTheme.black900,
          //         fontSize: 12.fSize,
          //         fontFamily: 'Poppins',
          //         fontWeight: FontWeight.w600,
          //       ),
          //     ),
          //     Padding(
          //       padding: EdgeInsets.only(
          //         top: 8.v,
          //         bottom: 7.v,
          //       ),
          //       child: SizedBox(
          //         width: 130.h,
          //         child: Divider(color: appTheme.black900),
          //       ),
          //     ),
          //   ],
          // ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          SizedBox(
            height:
                MediaQuery.of(context).size.height * 0.06, //height of button
            width: MediaQuery.of(context).size.width * 0.7, //width of button
            child: CustomElevatedButton(
              text: "Sign in with email",
              buttonStyle: CustomButtonStyles.fillGreen,
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: ((context) => SignInTwoScreen())));
              },
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Create a new account? ",
                style: theme.textTheme.bodyMedium,
              ),
              TextButton(
                child: Text(
                  "Sign up.",
                  style: CustomTextStyles.bodyMediumff5a7756.copyWith(
                    decoration: TextDecoration.underline,
                    color: Colors.black54,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => SignUpScreen())));
                },
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        ],
      ),
    );
  }
}
