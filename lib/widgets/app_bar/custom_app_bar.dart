import 'package:astridzhao_s_food_app/core/app_export.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  CustomAppBar({
    Key? key,
    this.height,
    this.toolbarHeight,
    this.leadingWidth,
    this.leading,
    this.title,
    this.elevation,
    this.centerTitle,
    this.actions,
    this.backgroundColor,
  }) : super(
          key: key,
        );

  final double? height;

  final double? leadingWidth;

  final double? toolbarHeight;

  final double? elevation;

  final Widget? leading;

  final Widget? title;

  final bool? centerTitle;

  final List<Widget>? actions;

  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return AppBar(
      elevation: 0,
      toolbarHeight: screenHeight * 0.2,
      automaticallyImplyLeading: false,
      backgroundColor: backgroundColor,
      leadingWidth: screenWidth * 0.2,
      leading: leading,
      title: title,
      titleSpacing: 0,
      centerTitle: centerTitle ?? false,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size(
        SizeUtils.width,
        height ?? SizeUtils.height * 0.1,
      );
}
