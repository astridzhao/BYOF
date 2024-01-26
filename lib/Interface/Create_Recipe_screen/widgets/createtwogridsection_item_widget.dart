import 'package:astridzhao_s_food_app/core/app_export.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CreatetwogridsectionItemWidget extends StatelessWidget {
  const CreatetwogridsectionItemWidget({Key? key})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return CustomImageView(
      imagePath: ImageConstant.mushroom,
      height: 31.v,
      width: 257.h,
    );
  }
}
