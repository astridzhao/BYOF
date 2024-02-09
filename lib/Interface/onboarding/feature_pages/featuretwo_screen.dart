import 'package:astridzhao_s_food_app/core/app_export.dart';
import 'package:astridzhao_s_food_app/Interface/onboarding/feature_pages/featureone_screen.dart';
import 'package:astridzhao_s_food_app/Interface/onboarding/feature_pages/featurethree_screen.dart';
import 'package:astridzhao_s_food_app/widgets/app_bar/appbar_subtitle.dart';
import 'package:astridzhao_s_food_app/Interface/onboarding/Signin/Signup/sign_in_email_screen.dart';
import 'package:flutter/material.dart';

class FeaturetwoScreen extends StatelessWidget {
  const FeaturetwoScreen({Key? key})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: _buildAppBar(context),
        body: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 30.h,
            vertical: 30.v,
          ),
          decoration: AppDecoration.gradientGrayToGray,
          width: double.maxFinite,
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              CustomImageView(
                imagePath: ImageConstant.imgSlogan21,
                height: 240.v,
                width: 300.h,
                radius: BorderRadius.circular(
                  20.h,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              Container(
                child: Wrap(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: 30.h,
                          right: 30.h,
                        ),
                        child: Column(
                          mainAxisAlignment:MainAxisAlignment.spaceAround,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.7,
                              decoration: AppDecoration.outlineBlack900,
                              child: Text(
                                "POWERED BY \n AI".toUpperCase(),
                                maxLines: null,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: appTheme.gray700,
                                  fontSize: 28.fSize,
                                  fontFamily: 'Outfit',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.05,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.7,
                              height: MediaQuery.of(context).size.height * 0.1,
                              child: Text(
                                "Are you struggle to find a perfect recipe? \nGet ready to explore new AI technology \nto make a recipe with all your preferences! ",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontFamily: 'Outfit',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            SizedBox(height: MediaQuery.of(context).size.height * 0.08),
                            _buildNextColumn(context),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
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
              .pop(MaterialPageRoute(builder: (context) => FeatureoneScreen()));
        },
      ),
      actions: [
        AppbarSubtitle(
          text: "Skip",
          margin: EdgeInsets.fromLTRB(21.h, 20.v, 21.h, 5.v),
          onTap: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => SignInTwoScreen())),
        ),
      ],
    );
  }

  /// Section Widget
  Widget _buildNextColumn(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton(
          style:
              ElevatedButton.styleFrom(backgroundColor: appTheme.green_primary),
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => FeaturethreeScreen()));
          },
          child: Text("Next",
              textAlign: TextAlign.center,
              softWrap: true,
              style: TextStyle(
                fontFamily: "Outfit",
                fontSize: 16.fSize,
                color: Colors.white,
              )),
        ),
      ],
    );
    //   ),
    // );
  }
}
