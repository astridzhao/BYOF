import 'package:astridzhao_s_food_app/core/app_export.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class RecipelistItemWidget extends StatelessWidget {
  const RecipelistItemWidget({Key? key})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 27.h,
        vertical: 10.v,
      ),
      decoration: AppDecoration.fillGray.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder10,
      ),
      width: 128.h,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Reduced",
            style: TextStyle(
              color: theme.colorScheme.onError.withOpacity(1),
              fontSize: 12.fSize,
              fontFamily: 'Outfit',
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 20.v),
          CustomImageView(
            imagePath: ImageConstant.imgEllipse744,
            height: 72.adaptSize,
            width: 72.adaptSize,
            radius: BorderRadius.circular(
              36.h,
            ),
          ),
          SizedBox(height: 14.v),
          Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Container(
                  height: 13.v,
                  width: 33.h,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onError,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 11.h),
                  child: Text(
                    "KG",
                    style: TextStyle(
                      color: theme.colorScheme.onError.withOpacity(1),
                      fontSize: 14.fSize,
                      fontFamily: 'Outfit',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
