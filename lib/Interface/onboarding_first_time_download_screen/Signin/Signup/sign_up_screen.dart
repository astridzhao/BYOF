import 'package:astridzhao_s_food_app/core/app_export.dart';
import 'package:astridzhao_s_food_app/widgets/app_bar/appbar_leading_image.dart';
import 'package:astridzhao_s_food_app/widgets/app_bar/custom_app_bar.dart';
import 'package:astridzhao_s_food_app/widgets/custom_checkbox_button.dart';
import 'package:astridzhao_s_food_app/widgets/custom_elevated_button.dart';
import 'package:astridzhao_s_food_app/widgets/custom_icon_button.dart';
import 'package:astridzhao_s_food_app/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({Key? key})
      : super(
          key: key,
        );

  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  TextEditingController emailController = TextEditingController();

  TextEditingController userNameController = TextEditingController();

  bool rememberMe = false;

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
            padding: EdgeInsets.only(top: 212.v),
            child: SizedBox(
              height: 511.v,
              width: double.maxFinite,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  _buildLoginSection(context),
                  _buildRegistrationSection(context),
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
    return CustomAppBar(
      leadingWidth: 374.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgIcon,
        margin: EdgeInsets.fromLTRB(31.h, 21.v, 323.h, 21.v),
      ),
    );
  }

  /// Section Widget
  Widget _buildLoginSection(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 38.h,
          vertical: 64.v,
        ),
        decoration: AppDecoration.gradientGrayToGray,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(height: 139.v),
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
                    child: Divider(),
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
                    child: Divider(),
                  ),
                ),
              ],
            ),
            SizedBox(height: 13.v),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconButton(
                  height: 55.v,
                  width: 57.h,
                  padding: EdgeInsets.all(14.h),
                  child: CustomImageView(
                    imagePath: ImageConstant.imgGoogle1,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20.h),
                  child: CustomIconButton(
                    height: 55.v,
                    width: 57.h,
                    padding: EdgeInsets.all(14.h),
                    child: CustomImageView(
                      imagePath: ImageConstant.imgApplelogo1,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 9.v),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Already have an account ? ",
                    style: theme.textTheme.bodyMedium,
                  ),
                  TextSpan(
                    text: "Sign in.",
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
  Widget _buildRegistrationSection(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.only(
          left: 36.h,
          right: 33.h,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: AppDecoration.outlineBlack900,
              child: Text(
                "Create a New Account",
                style: TextStyle(
                  color: appTheme.gray700,
                  fontSize: 24.fSize,
                  fontFamily: 'Outfit',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(height: 12.v),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(right: 10.h),
                child: Text(
                  "Let’s start create your own recipe together!",
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
            SizedBox(height: 29.v),
            CustomTextFormField(
              controller: emailController,
              hintText: "Email",
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
            SizedBox(height: 16.v),
            CustomTextFormField(
              controller: userNameController,
              hintText: "User Name",
              textInputAction: TextInputAction.done,
              prefix: Container(
                margin: EdgeInsets.fromLTRB(16.h, 9.v, 22.h, 10.v),
                child: CustomImageView(
                  imagePath: ImageConstant.imgLockOnsecondarycontainer,
                  height: 29.adaptSize,
                  width: 29.adaptSize,
                ),
              ),
              prefixConstraints: BoxConstraints(
                maxHeight: 48.v,
              ),
            ),
            SizedBox(height: 18.v),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 91.h),
                child: CustomCheckboxButton(
                  alignment: Alignment.centerLeft,
                  text: "Remember me",
                  value: rememberMe,
                  textStyle: TextStyle(
                    color: appTheme.gray800,
                    fontSize: 12.fSize,
                    fontFamily: 'Outfit',
                    fontWeight: FontWeight.w500,
                  ),
                  onChange: (value) {
                    rememberMe = value;
                  },
                ),
              ),
            ),
            SizedBox(height: 18.v),
            CustomElevatedButton(
              height: 40.v,
              width: 187.h,
              text: "Create an account",
              buttonStyle: CustomButtonStyles.fillGrayTL8,
            ),
          ],
        ),
      ),
    );
  }
}
