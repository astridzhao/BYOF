import 'package:astridzhao_s_food_app/core/app_export.dart';
import 'package:astridzhao_s_food_app/widgets/custom_icon_button.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CarbslistItemWidget extends StatelessWidget {
  const CarbslistItemWidget({Key? key})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.h),
      decoration: AppDecoration.fillDeepOrange.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder10,
      ),
      width: 72.h,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 18.v),
          Text(
            "Pasta",
            style: TextStyle(
              color: appTheme.black900,
              fontSize: 10.fSize,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 4.v),
          CustomIconButton(
            height: 12.adaptSize,
            width: 12.adaptSize,
            alignment: Alignment.centerRight,
            child: CustomImageView(
              imagePath: ImageConstant.imgPlus,
            ),
          ),
        ],
      ),
    );
  }
}
