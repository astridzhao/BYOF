import 'package:astridzhao_s_food_app/core/app_export.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class RecipecontentrowItemWidget extends StatelessWidget {
  const RecipecontentrowItemWidget({Key? key})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64.adaptSize,
      width: 64.adaptSize,
      margin: EdgeInsets.only(
        left: 14.h,
        top: 2.v,
      ),
      padding: EdgeInsets.all(3.h),
      decoration: AppDecoration.outlineGray.copyWith(
        borderRadius: BorderRadiusStyle.circleBorder32,
      ),
      child: CustomImageView(
        imagePath: ImageConstant.imgAvatar58x58,
        height: 58.adaptSize,
        width: 58.adaptSize,
        radius: BorderRadius.circular(
          29.h,
        ),
        alignment: Alignment.center,
      ),
    );
  }
}
