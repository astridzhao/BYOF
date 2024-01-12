import 'package:astridzhao_s_food_app/core/app_export.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AppbarTitle extends StatelessWidget {
  AppbarTitle({
    Key? key,
    required this.text,
    required this.textStyle,
    this.margin,
    this.onTap,
  }) : super(
          key: key,
        );

  String text;

  TextStyle textStyle;

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
          style: textStyle,
        ),
      ),
    );
  }
}
