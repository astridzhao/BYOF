import 'package:astridzhao_s_food_app/core/app_export.dart';
import 'package:flutter/material.dart';


class AppbarSubtitle extends StatelessWidget {
  AppbarSubtitle({
    Key? key,
    required this.text,
    this.margin,
    this.onTap,
  }) : super(
          key: key,
        );

  String text;

  EdgeInsetsGeometry? margin;

  Function? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap!.call();
      },
      child: Padding(
        padding: margin ?? EdgeInsets.zero,
        child: Text(
          text,
          style: TextStyle(
            color: appTheme.gray800,
            fontSize: 12.fSize,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w400,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }
}
