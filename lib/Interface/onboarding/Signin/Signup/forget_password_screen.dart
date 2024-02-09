import 'package:astridzhao_s_food_app/Interface/onboarding/Signin/Signup/sign_in_email_screen.dart';
import 'package:astridzhao_s_food_app/core/app_export.dart';
import 'package:astridzhao_s_food_app/widgets/app_bar/appbar_leading_image.dart';
import 'package:astridzhao_s_food_app/widgets/app_bar/custom_app_bar.dart';
import 'package:astridzhao_s_food_app/widgets/custom_elevated_button.dart';
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

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: _buildAppBar(context),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.only(top: 344.v),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 27.h,
                vertical: 93.v,
              ),
              decoration: AppDecoration.gradientGrayToGray,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 5.v),
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
                  SizedBox(height: 10.v),
                  Padding(
                    padding: EdgeInsets.only(right: 111.h),
                    child: Text(
                      "Don’t worry!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: appTheme.gray800,
                        fontSize: 14.fSize,
                        fontFamily: 'Outfit',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.v),
                  Padding(
                    padding: EdgeInsets.only(left: 15.h),
                    child: CustomTextFormField(
                      controller: emailController,
                      hintText: "Email",
                      textInputAction: TextInputAction.done,
                      textInputType: TextInputType.emailAddress,
                      prefix: Container(
                        margin: EdgeInsets.fromLTRB(16.h, 8.v, 22.h, 11.v),
                        child: CustomImageView(
                          imagePath: ImageConstant.imgLock,
                          height: 29.adaptSize,
                          width: 29.adaptSize,
                        ),
                      ),
                      prefixConstraints: BoxConstraints(
                        maxHeight: 48.v,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.v),
                  CustomElevatedButton(
                    height: 40.v,
                    width: 187.h,
                    text: "Find my password",
                    margin: EdgeInsets.only(right: 57.h),
                    buttonStyle: CustomButtonStyles.fillGrayTL8,
                  ),
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
