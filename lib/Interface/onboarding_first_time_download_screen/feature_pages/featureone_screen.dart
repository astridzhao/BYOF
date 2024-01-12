import 'package:astridzhao_s_food_app/core/app_export.dart';
import 'package:astridzhao_s_food_app/Interface/onboarding_first_time_download_screen/feature_pages/featuretwo_screen.dart';
import 'package:astridzhao_s_food_app/Interface/onboarding_first_time_download_screen/onboarding_first_time_download_screen.dart';
import 'package:astridzhao_s_food_app/widgets/app_bar/appbar_subtitle.dart';
import 'package:astridzhao_s_food_app/Interface/onboarding_first_time_download_screen/Signin/Signup/create_account_page_screen.dart';
import 'package:flutter/material.dart';

class FeatureoneScreen extends StatelessWidget {
  const FeatureoneScreen({Key? key})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
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
              SizedBox(height: 40.v),
              CustomImageView(
                imagePath: ImageConstant.imgSlogan11,
                height: 240.v,
                width: 300.h,
                radius: BorderRadius.circular(
                  20.h,
                ),
              ),
              SizedBox(height: 41.v),
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
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 260.h,
                              decoration: AppDecoration.outlineBlack900,
                              child: Text(
                                "PERSONALIZED \nRECIPES".toUpperCase(),
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
                            SizedBox(height: 52.v),
                            SizedBox(
                              width: 320,
                              child: Text(
                                'Always do not know what to eat? \nStart with grab ingredients in your fridge \nand create a new dish with BYOF! ',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontFamily: 'Outfit',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            SizedBox(height: 60.v),
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
          Navigator.of(context).pop(MaterialPageRoute(
              builder: (context) => OnboardingFirstTimeDownloadScreen()));
        },
      ),
      actions: [
        AppbarSubtitle(
          text: "Skip",
          margin: EdgeInsets.fromLTRB(21.h, 20.v, 21.h, 5.v),
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => CreateAccountPageScreen())),
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
                MaterialPageRoute(builder: (context) => FeaturetwoScreen()));
          },
          child: Text("Next",
              textAlign: TextAlign.center,
              softWrap: true,
              style: TextStyle(
                fontFamily: "Outfit",
              )),
        ),
      ],
    );
  }
}
