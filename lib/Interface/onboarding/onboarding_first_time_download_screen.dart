import 'package:astridzhao_s_food_app/core/app_export.dart';
import 'package:astridzhao_s_food_app/Interface/onboarding/feature_pages/featureone_screen.dart';
import 'package:flutter/material.dart';

class OnboardingFirstTimeDownloadScreen extends StatelessWidget {
  const OnboardingFirstTimeDownloadScreen({Key? key})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SizedBox(
        width: double.maxFinite,
        child: Column(
          children: [
            Spacer(),
            CustomImageView(
              imagePath: ImageConstant.imgLogo2RemovebgPreview,
              height: MediaQuery.of(context).size.height * 0.4,
              width: MediaQuery.of(context).size.height * 0.4,
            ),
            _buildOnboardingFirstColumn(context),
          ],
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
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.2,
            child: Text(
              'With BYOF, \nSaving \n Becomes Easy!',
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
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
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
                  color: Colors.white,
                )),
          ),
          SizedBox(height: 43.v),
        ],
      ),
    );
  }
}
