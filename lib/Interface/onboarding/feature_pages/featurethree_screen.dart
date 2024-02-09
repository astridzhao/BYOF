import 'package:astridzhao_s_food_app/Interface/onboarding/Signin/Signup/sign_in_options_screen.dart';
import 'package:astridzhao_s_food_app/core/app_export.dart';
import 'package:astridzhao_s_food_app/Interface/onboarding/Signin/Signup/sign_in_email_screen.dart';
import 'package:astridzhao_s_food_app/Interface/onboarding/feature_pages/featuretwo_screen.dart';
import 'package:astridzhao_s_food_app/widgets/app_bar/appbar_subtitle.dart';
import 'package:flutter/material.dart';

class FeaturethreeScreen extends StatelessWidget {
  const FeaturethreeScreen({Key? key})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                imagePath: ImageConstant.imgSlogan31,
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
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: 30.h,
                          right: 30.h,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.7,
                              decoration: AppDecoration.outlineBlack900,
                              child: Text(
                                "TRACK YOUR \n SAVING".toUpperCase(),
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
                                "Did you waste lots of money on food? \n Did you want to save our environment? \n BYOF will help you easily track your saving everyday!",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontFamily: 'Outfit',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.08),
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
              .pop(MaterialPageRoute(builder: (context) => FeaturetwoScreen()));
        },
      ),
      actions: [
        AppbarSubtitle(
          text: "Skip",
          onTap: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => SignInOneScreen())),
          margin: EdgeInsets.fromLTRB(21.h, 20.v, 21.h, 5.v),
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
                MaterialPageRoute(builder: (context) => SignInOneScreen()));
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
