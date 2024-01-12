import 'package:astridzhao_s_food_app/core/app_export.dart';
import 'package:astridzhao_s_food_app/Interface/onboarding_first_time_download_screen/feature_pages/featureone_screen.dart';
import 'package:flutter/material.dart';

class OnboardingFirstTimeDownloadScreen extends StatelessWidget {
  const OnboardingFirstTimeDownloadScreen({Key? key})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SizedBox(
          width: double.maxFinite,
          child: Column(
            children: [
              Spacer(),
              SizedBox(height: 8.v),
              CustomImageView(
                imagePath: ImageConstant.imgLogo2RemovebgPreview,
                height: 312.adaptSize,
                width: 312.adaptSize,
              ),
              _buildOnboardingFirstColumn(context),
            ],
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildOnboardingFirstColumn(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 30.h,
        vertical: 30.v,
      ),
      decoration: AppDecoration.gradientGrayToGray,
      child: Column(
        children: [
          SizedBox(
            width: 268.h,
            height: 115.h,
            child: Text(
              'With BYOF, \nEveryone \nCan be a chef!',
              textAlign: TextAlign.center,
              maxLines: 3,
              style: TextStyle(
                color: Colors.black,
                fontSize: 32,
                fontFamily: 'Outfit',
                fontWeight: FontWeight.w700,
                letterSpacing: 1.60,
              ),
            ),
          ),
          SizedBox(height: 20.v),
          Align(
            alignment: Alignment.center,
            child: Text(
              "Try Use AI to empower your cook!",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: appTheme.gray600,
                fontSize: 14.fSize,
                fontFamily: 'Outfit',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          SizedBox(height: 48.v),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: appTheme.orange_primary,
              fixedSize: Size(160, 40),
            ),
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => FeatureoneScreen()));
            },
            child: Text("Get Started",
                textAlign: TextAlign.center,
                softWrap: true,
                style: TextStyle(
                  fontFamily: "Outfit",
                  fontSize: 16.fSize,
                )),
          ),
          SizedBox(height: 43.v),
        ],
      ),
    );
  }
}
