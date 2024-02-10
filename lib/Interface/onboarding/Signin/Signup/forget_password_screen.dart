import 'package:astridzhao_s_food_app/Interface/onboarding/Signin/Signup/sign_in_email_screen.dart';
import 'package:astridzhao_s_food_app/core/app_export.dart';
import 'package:astridzhao_s_food_app/widgets/app_bar/appbar_leading_image.dart';
import 'package:astridzhao_s_food_app/widgets/app_bar/custom_app_bar.dart';
import 'package:astridzhao_s_food_app/widgets/custom_elevated_button.dart';
import 'package:astridzhao_s_food_app/widgets/custom_signin_widget.dart';
import 'package:astridzhao_s_food_app/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';

class ForgetPasswordScreen extends StatefulWidget {
  ForgetPasswordScreen({Key? key})
      : super(
          key: key,
        );

  ForgetPasswordScreenState createState() => ForgetPasswordScreenState();
}

class ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: _buildAppBar(context),
        body: Padding(
          padding: EdgeInsets.only(top: screenHeight * 0.3),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.1,
              vertical: screenHeight * 0.1,
            ),
            decoration: AppDecoration.gradientGrayToGray,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    decoration: AppDecoration.outlineBlack900,
                    child: Text(
                      "Forget Password?",
                      style: TextStyle(
                        color: appTheme.gray700,
                        fontSize: 24.fSize,
                        fontFamily: 'Outfit',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Forget Password?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: appTheme.gray800,
                      fontSize: 14.fSize,
                      fontFamily: 'Outfit',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.05),
                CustomTextFieldLogin(
                  hintText: 'Enter your Email',
                  isPasswordTextField: false,
                  labelText: 'Email',
                  icons: Icons.email,
                  controller: emailController,
                  decoration: InputDecoration(),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: screenHeight * 0.02),
                CustomElevatedButton(
                  onPressed: () {},
                  text: 'Send',
                  buttonTextStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 16.fSize,
                    fontFamily: 'Outfit',
                    fontWeight: FontWeight.w700,
                  ),
                  buttonStyle: ElevatedButton.styleFrom(
                    elevation: 3,
                    backgroundColor: appTheme.green_primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
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
        color: Colors.black54,
        iconSize: 20.0,
        splashColor: appTheme.orange_primary,
        onPressed: () {
          Navigator.of(context)
              .pop(MaterialPageRoute(builder: (context) => SignInTwoScreen()));
        },
      ),
    );
  }
}
