import 'package:astridzhao_s_food_app/core/app_export.dart';
import 'package:astridzhao_s_food_app/Interface/homepage_container_screen/homepage_container_screen.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class LoadingScreen extends StatefulWidget {
  @override
  Splash createState() => Splash();
  const LoadingScreen({Key? key})
      : super(
          key: key,
        );
}

class Splash extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Timer(
        Duration(seconds: 5),
        () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => HomepageContainerScreen())));

    return MaterialApp(
      home: Scaffold(
        backgroundColor: appTheme.black900,
        body: Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(
            horizontal: 40.h,
            vertical: 39.v,
          ),
          child: Column(
            children: [
              SizedBox(height: 40.h),
              CustomImageView(
                imagePath: ImageConstant.imgLogo2RemovebgPreview,
                height: 296.adaptSize,
                width: 296.adaptSize,
                alignment: Alignment.center,
              ),
              Container(
                decoration: AppDecoration.outlineBlack,
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Bring \nYour \nOwn\nFridge\n",
                        style: theme.textTheme.displaySmall,
                      ),
                      WidgetSpan(
                        child: Container(
                            height:
                                8), // Adjust the height according to your preference
                      ),
                      TextSpan(
                        text: "AI recipe",
                        style: theme.textTheme.displayMedium,
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 45.v),
                    Container(
                      width: 132.h,
                      margin: EdgeInsets.symmetric(horizontal: 14.h),
                      child: Text(
                        "Creative Recipe Idea\nMake Cook For Fun",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: appTheme.gray600,
                          fontSize: 14.fSize,
                          fontFamily: 'Outfit',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 33.v),
              SizedBox(height: 5.v),
            ],
          ),
        ),
      ),
    );
  }
}
