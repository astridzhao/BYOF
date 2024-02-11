import 'dart:math';

import 'package:astridzhao_s_food_app/Interface/homepage_screen/homepage-container.dart';
import 'package:astridzhao_s_food_app/Interface/onboarding/Signin/Signup/sign_in_email_screen.dart';
import 'package:astridzhao_s_food_app/widgets/custom_signin_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:astridzhao_s_food_app/bloc/authentication_bloc.dart';
import 'package:astridzhao_s_food_app/core/app_export.dart';
import 'package:astridzhao_s_food_app/widgets/app_bar/appbar_leading_image.dart';
import 'package:astridzhao_s_food_app/widgets/app_bar/custom_app_bar.dart';
import 'package:astridzhao_s_food_app/widgets/custom_icon_button.dart';
import 'package:astridzhao_s_food_app/widgets/custom_text_form_field.dart';

class SignUpScreen extends StatefulWidget {
  static String id = 'login_screen';
  const SignUpScreen({Key? key})
      : super(
          key: key,
        );

  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      checkEmailVerified();
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildEmailCreationSection(context),
          ],
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildEmailCreationSection(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.only(
          left: screenWidth * 0.1,
          right: screenWidth * 0.1,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: screenHeight * 0.3,
              child: CustomImageView(
                imagePath: ImageConstant.imgLogo2RemovebgPreview,
              ),
            ),
            Container(
              decoration: AppDecoration.outlineBlack900,
              child: Text(
                "Create Account",
                style: TextStyle(
                  color: appTheme.gray700,
                  fontSize: 28.fSize,
                  fontFamily: 'Outfit',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(height: 12.v),
            Text(
              "Start your saving journey!",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: appTheme.gray800,
                fontSize: 14.fSize,
                fontFamily: 'Outfit',
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 29.v),
            CustomTextFieldLogin(
              hintText: 'Enter your Email',
              isPasswordTextField: false,
              labelText: 'Email',
              icons: Icons.email,
              controller: emailController,
              decoration: InputDecoration(
                  // Use copyWith to allow overriding specific properties
                  // Other properties like border, fillColor, etc., can be predefined or customized here
                  ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                return null;
              },
            ),
            SizedBox(height: screenHeight * 0.02),
            CustomTextFieldLogin(
              hintText: 'Set your password',
              isPasswordTextField: true,
              labelText: 'Password',
              icons: Icons.password,
              controller: passwordController,
              decoration: InputDecoration(),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                return null;
              },
            ),
            SizedBox(height: screenHeight * 0.03),
            BlocConsumer<AuthenticationBloc, AuthenticationState>(
              listener: (context, state) {
                // if (state is SignUpSuccessState) {
                //   Navigator.pushNamedAndRemoveUntil(
                //     context,
                //     HomepageContainerScreen.id,
                //     (route) => false,
                //   );
                print(state.toString());
                if (state is SignUpNeedsVerificationState) {
                  print("Email verification needed");
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Bring Your Own Fridge"),
                          content: Text(
                              "Welcome to Bring Your Own Fridge!A verification email has been sent to ${state.email}. Please check your inbox and click the verification link to proceed. Hope you enjoy your saving journey with us!"),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Close the dialog
                                // Optionally, provide a way for the user to request another verification email here
                              },
                              child: Text(
                                'OK',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                // Call the checkEmailVerified method here
                                checkEmailVerified();
                              },
                              child: Text(
                                'I Verified My Email',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                        );
                      });
                } else if (state is SignUpSuccessState) {
                  print("wrong");
                } else if (state is SignUpFailureState) {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: Text(state.errorMessage,
                              style: theme.textTheme.bodyMedium),
                          actions: <Widget>[
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); // Dismiss the dialog
                                },
                                child: const Text(
                                  'OK',
                                  style: TextStyle(color: Colors.black),
                                )),
                          ], // 'const' is fine here since the text doesn't change
                        );
                      });
                }
              },
              builder: (context, state) {
                return SizedBox(
                  height: screenHeight * 0.05,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<AuthenticationBloc>(context).add(
                        SignUpUser(
                          emailController.text.trim(),
                          passwordController.text.trim(),
                          emailVerified: false,
                        ),
                      );
                    },
                    child: Text(
                      'Sign up',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Outfit',
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: screenHeight * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an account? ",
                  style: theme.textTheme.bodyMedium,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: ((context) => SignInTwoScreen())));
                  },
                  child: Text(
                    'Login',
                    style: CustomTextStyles.bodyMediumff5a7756.copyWith(
                      decoration: TextDecoration.underline,
                      color: Colors.black54,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> checkEmailVerified() async {
    User? user = FirebaseAuth.instance.currentUser;
    await user
        ?.reload(); // Refresh the user's state to get the latest email verification status
    user = FirebaseAuth.instance.currentUser;

    if (user != null && user.emailVerified) {
      // Email has been verified. Here, you can finalize creating the account,
      // or if it's already created, grant access to the app's features.
      Fluttertoast.showToast(msg: "Email successfully verified!");
      // Email has been verified, proceed with the application flow
      Navigator.pushNamedAndRemoveUntil(
        context,
        HomepageContainerScreen.id,
        (route) => false,
      );
    } else {
      // Email is not verified, prompt the user or offer to resend the verification email
      Fluttertoast.showToast(msg: "Please verify your email to continue.");
    }
  }
}




          // Row(
          //   children: [
          //     CustomCheckboxButton(
          //       value: rememberMe,
          //       onChanged: (value) {
          //         setState(() {
          //           rememberMe = value;
          //         });
          //       },
          //     ),
          //     SizedBox(width: 8.h),
          //     Text(
          //       "I agree to the ",
          //       style: TextStyle(
          //         color: appTheme.gray800,
          //         fontSize: 14.fSize,
          //         fontFamily: 'Outfit',
          //         fontWeight: FontWeight.w400,
          //       ),
          //     ),
          //     Text(
          //       "Terms of Service",
          //       style: TextStyle(
          //         color: appTheme.orange_primary,
          //         fontSize: 14.fSize,
          //         fontFamily: 'Outfit',
          //         fontWeight: FontWeight.w400,
          //       ),
          //     ),
          //   ],
          // ),
