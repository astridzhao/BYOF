import 'package:astridzhao_s_food_app/core/app_export.dart';
import 'package:astridzhao_s_food_app/widgets/app_bar/appbar_leading_image.dart';
import 'package:astridzhao_s_food_app/widgets/app_bar/custom_app_bar.dart';
import 'package:flutter/material.dart';

class FunctionChooseScreen extends StatelessWidget {
  const FunctionChooseScreen({Key? key})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: SizedBox(
          width: SizeUtils.width,
          child: SingleChildScrollView(
            padding: EdgeInsets.only(top: 78.v),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.only(left: 53.h),
                    decoration: AppDecoration.outlineBlack900,
                    child: Text(
                      "Choose your plan",
                      style: TextStyle(
                        color: appTheme.gray700,
                        fontSize: 24.fSize,
                        fontFamily: 'Outfit',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 23.v),
                Container(
                  height: 120.v,
                  width: 265.h,
                  decoration: BoxDecoration(
                    color: appTheme.gray700,
                    borderRadius: BorderRadius.circular(
                      8.h,
                    ),
                  ),
                ),
                SizedBox(height: 37.v),
                SizedBox(
                  height: 434.v,
                  width: double.maxFinite,
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: 380.v,
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment(0.5, 0),
                              end: Alignment(0.5, 1),
                              colors: [
                                appTheme.gray700.withOpacity(0),
                                appTheme.gray700.withOpacity(0.23),
                                appTheme.gray700,
                              ],
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          height: 129.v,
                          width: 265.h,
                          decoration: BoxDecoration(
                            color: appTheme.gray700,
                            borderRadius: BorderRadius.circular(
                              8.h,
                            ),
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
      ),
    );
  }

  /// Section Widget
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      leadingWidth: 374.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgIcon,
        margin: EdgeInsets.fromLTRB(36.h, 21.v, 318.h, 21.v),
      ),
    );
  }
}
