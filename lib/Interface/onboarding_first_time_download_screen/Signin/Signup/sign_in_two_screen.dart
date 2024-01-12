import 'package:astridzhao_s_food_app/core/app_export.dart';
import 'package:astridzhao_s_food_app/Interface/onboarding_first_time_download_screen/Signin/Signup/forget_password_screen.dart';
import 'package:astridzhao_s_food_app/Interface/onboarding_first_time_download_screen/Signin/Signup/sign_in_one_screen.dart';
import 'package:astridzhao_s_food_app/Interface/onboarding_first_time_download_screen/Signin/Signup/sign_up_screen.dart';
import 'package:astridzhao_s_food_app/Interface/loading_screen.dart';
import 'package:astridzhao_s_food_app/widgets/custom_icon_button.dart';
import 'package:astridzhao_s_food_app/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class SignInTwoScreen extends StatefulWidget {
  SignInTwoScreen({Key? key})
      : super(
          key: key,
        );
  SignInTwoScreenState createState() => SignInTwoScreenState();
}

class SignInTwoScreenState extends State<SignInTwoScreen> {
  TextEditingController emailController = TextEditingController();

  TextEditingController userNameController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: _buildAppBar(context),
        body: Container(
          key: _formKey,
          decoration: AppDecoration.gradientGrayToGray,
          child: SingleChildScrollView(
            padding: EdgeInsets.only(top: 209.v),
            child: SizedBox(
              height: 514.v,
              width: double.maxFinite,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  _buildSignInSection(context),
                  _otherOptionSignInSection(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Section Widget
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.keyboard_backspace),
        tooltip: 'Back to last page',
        color: Colors.black54,
        iconSize: 20.0,
        splashColor: appTheme.orange_primary,
        onPressed: () {
          Navigator.of(context)
              .pop(MaterialPageRoute(builder: (context) => SignInOneScreen()));
        },
      ),
    );
  }

  /// Section Widget
  Widget _otherOptionSignInSection(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 38.h,
          vertical: 60.v,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: 8.v,
                    bottom: 7.v,
                  ),
                  child: SizedBox(
                    width: 130.h,
                    child: Divider(
                      color: appTheme.black900,
                    ),
                  ),
                ),
                Text(
                  "or",
                  style: TextStyle(
                    color: appTheme.black900,
                    fontSize: 12.fSize,
                    fontFamily: 'Outfit',
                    fontWeight: FontWeight.w100,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 8.v,
                    bottom: 7.v,
                  ),
                  child: SizedBox(
                    width: 130.h,
                    child: Divider(
                      color: appTheme.black900,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.v),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconButton(
                  height: 52.v,
                  width: 52.h,
                  padding: EdgeInsets.all(14.h),
                  child: CustomImageView(
                    imagePath: ImageConstant.imgGoogle1,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20.h),
                  child: CustomIconButton(
                    height: 52.v,
                    width: 52.h,
                    padding: EdgeInsets.all(14.h),
                    child: CustomImageView(
                      imagePath: ImageConstant.imgApplelogo1,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.v),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Create a new account? ",
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
          ],
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildSignInSection(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.only(
          left: 40.h,
          right: 40.h,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: AppDecoration.outlineBlack900,
              child: Text(
                "Welcome Back",
                style: TextStyle(
                  color: appTheme.gray700,
                  fontSize: 28.fSize,
                  fontFamily: 'Outfit',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(height: 10.v),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(right: 58.h),
                child: Text(
                  "Let’s start to save together!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: appTheme.gray800,
                    fontSize: 14.fSize,
                    fontFamily: 'Outfit',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            SizedBox(height: 31.v),
            CustomTextFormField(
              controller: emailController,
              hintText: "Email",
              textInputType: TextInputType.emailAddress,
              prefix: Container(
                margin: EdgeInsets.fromLTRB(16.h, 11.v, 22.h, 11.v),
                child: const Icon(Icons.email_outlined),
              ),
              prefixConstraints: BoxConstraints(
                maxHeight: 48.v,
              ),
            ),
            SizedBox(height: 16.v),
            CustomTextFormField(
              controller: userNameController,
              hintText: "Password",
              textStyle: TextStyle(fontSize: 14.fSize),
              textInputAction: TextInputAction.done,
              textInputType: TextInputType.visiblePassword,
              prefix: Container(
                margin: EdgeInsets.fromLTRB(16.h, 11.v, 22.h, 11.v),
                child: const Icon(Icons.password_outlined),
              ),
              prefixConstraints: BoxConstraints(
                maxHeight: 48.v,
              ),
              obscureText: true,
            ),
            TextButton(
              child: SizedBox(
                  child: Text(
                "Forget Password?",
                style: TextStyle(
                    color: appTheme.gray800,
                    fontFamily: "Outfit",
                    fontWeight: FontWeight.w400),
              )),
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ForgetPasswordScreen())),
            ),
            SizedBox(height: 35.v),
            SizedBox(
            height: 48, //height of button
            width: 150, //width of button
            child: ElevatedButton(
              child: Text("Sign in", style: TextStyle(fontFamily: "Outfit", fontSize: 15.fSize),),
              style: ElevatedButton.styleFrom(
                elevation: 3,
                padding: EdgeInsets.symmetric(vertical: 8.v, horizontal: 10.h),
                backgroundColor: appTheme.green_primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: ((context) => LoadingScreen())));
              },
            ),
          ),
          ],
        ),
      ),
    );
  }
}
