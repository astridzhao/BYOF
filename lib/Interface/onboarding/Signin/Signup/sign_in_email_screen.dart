import 'package:astridzhao_s_food_app/Interface/homepage_screen/homepage-container.dart';
import 'package:astridzhao_s_food_app/bloc/authentication_bloc.dart';
import 'package:astridzhao_s_food_app/core/app_export.dart';
import 'package:astridzhao_s_food_app/Interface/onboarding/Signin/Signup/forget_password_screen.dart';
import 'package:astridzhao_s_food_app/Interface/onboarding/Signin/Signup/sign_in_options_screen.dart';
import 'package:astridzhao_s_food_app/Interface/onboarding/Signin/Signup/sign_up_screen.dart';
import 'package:astridzhao_s_food_app/widgets/custom_signin_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInTwoScreen extends StatefulWidget {
  SignInTwoScreen({Key? key})
      : super(
          key: key,
        );
  SignInTwoScreenState createState() => SignInTwoScreenState();
}

class SignInTwoScreenState extends State<SignInTwoScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _buildAppBar(context),
      body: Container(
        key: _formKey,
        decoration: AppDecoration.gradientGrayToGray,
        child: Padding(
          padding:
              EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.2),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.8,
            width: double.maxFinite,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                _buildSignInEmailSection(context),
                _otherOptionSignInSection(context),
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
  Widget _buildSignInEmailSection(BuildContext context) {
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
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: AppDecoration.outlineBlack900,
              child: Text(
                "Login",
                style: TextStyle(
                  color: appTheme.gray700,
                  fontSize: 28.fSize,
                  fontFamily: 'Outfit',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            Align(
              alignment: Alignment.center,
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
            SizedBox(height: screenHeight * 0.02),
            BlocConsumer<AuthenticationBloc, AuthenticationState>(
              listener: (context, state) {
                if (state is SignInSuccessState) {
                  print("sign in success");
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              HomepageContainerScreen()),
                      (Route<dynamic> route) =>
                          route is HomepageContainerScreen);
                } else if (state is SignInFailureState) {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Authentication Error'),
                          // Display the error message from the state
                          content: Text(state.errorMessage),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .pop(); // Dismiss the dialog
                              },
                              child: const Text(
                                'OK',
                                style: TextStyle(color: Colors.black),
                              ), // 'const' is fine here since the text doesn't change
                            ),
                          ],
                        );
                      });
                }
              },
              builder: (context, state) {
                if (state is SignInLoadingState && state.isLoading) {
                  // Optionally show a loading indicator while the sign-in is in progress
                  return CircularProgressIndicator();
                }

                return SizedBox(
                  height: screenHeight * 0.05,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 3,
                      backgroundColor: appTheme.green_primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      BlocProvider.of<AuthenticationBloc>(context).add(
                        SignInUser(
                          emailController.text.trim(),
                          passwordController.text.trim(),
                        ),
                      );
                    },
                    child: Text(
                      'Sign in',
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Outfit',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Section Widget
  Widget _otherOptionSignInSection(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: EdgeInsets.only(
          left: screenWidth * 0.1,
          right: screenWidth * 0.1,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: screenHeight * 0.2),
            Text(
              "Create a new account? ",
              style: theme.textTheme.bodyMedium,
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: ((context) => SignUpScreen())));
              },
              child: Text(
                "Sign up.",
                style: CustomTextStyles.bodyMediumff5a7756.copyWith(
                  decoration: TextDecoration.underline,
                  color: Colors.black54,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
