import 'package:astridzhao_s_food_app/Interface/Creeat_Recipe_screen/create_two_screen.dart';
import '../homepage_page/widgets/carbslist_item_widget.dart';
import '../homepage_page/widgets/ingredientslist_item_widget.dart';
import '../homepage_page/widgets/proteinlist_item_widget.dart';
import '../homepage_page/widgets/recipecontentrow_item_widget.dart';
import '../homepage_page/widgets/recipelist_item_widget.dart';
import 'package:astridzhao_s_food_app/core/app_export.dart';
import 'package:astridzhao_s_food_app/widgets/app_bar/appbar_image.dart';
import 'package:astridzhao_s_food_app/widgets/app_bar/appbar_title.dart';
import 'package:astridzhao_s_food_app/widgets/app_bar/custom_app_bar.dart';
import 'package:astridzhao_s_food_app/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';

// ignore_for_file: must_be_immutable
class HomepagePage extends StatelessWidget {
  const HomepagePage({Key? key})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: appTheme.yellow5001,
        appBar: _buildAppBar(context),
        body: SizedBox(
          width: SizeUtils.width,
          child: SingleChildScrollView(
            padding: EdgeInsets.only(top: 20.v),
            child: Container(
              margin: EdgeInsets.only(bottom: 5.v),
              padding: EdgeInsets.symmetric(horizontal: 10.h),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 23.h),
                      child: Text(
                        "So far, you have",
                        style: TextStyle(
                          color: appTheme.black900,
                          fontSize: 12.fSize,
                          fontFamily: 'Outfit',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 15.v),
                  _buildSavingSummary(context),
                  SizedBox(height: 31.v),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 22.h,
                      right: 29.h,
                    ),
                    child: _buildMyMealPlanSection(
                      context,
                      text: "My Favorite Recipes",
                      text1: "See all",
                    ),
                  ),
                  Divider(
                    color: appTheme.gray800,
                    indent: 22.h,
                    endIndent: 17.h,
                  ),
                  SizedBox(height: 3.v),
                  _buildFavoriteRecipeRow(context),
                  SizedBox(height: 14.v),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 22.h,
                      right: 29.h,
                    ),
                    child: _buildMyMealPlanSection(
                      context,
                      text: "My Meal Plan",
                      text1: "View",
                    ),
                  ),
                  SizedBox(height: 1.v),
                  Divider(
                    color: appTheme.gray800,
                    indent: 23.h,
                    endIndent: 16.h,
                  ),
                  SizedBox(height: 10.v),
                  _buildCreateplanSection(context),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 25.h,
                      right: 15.h,
                    ),
                    child: _buildMyMealPlanSection(
                      context,
                      text: "My Fridge",
                      text1: "View",
                    ),
                  ),
                  SizedBox(height: 1.v),
                  Divider(
                    color: appTheme.gray800,
                    indent: 25.h,
                    endIndent: 14.h,
                  ),
                  SizedBox(height: 8.v),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 25.h,
                      right: 15.h,
                    ),
                    child: _buildProtein(
                      context,
                      proteinText: "Fiber",
                      seeAllText: "See all",
                    ),
                  ),
                  SizedBox(height: 1.v),
                  _buildFiberList(context),
                  SizedBox(height: 15.v),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 25.h,
                      right: 15.h,
                    ),
                    child: _buildProtein(
                      context,
                      proteinText: "Protein",
                      seeAllText: "See all",
                    ),
                  ),
                  SizedBox(height: 31.v),
                  _buildProteinList(context),
                  SizedBox(height: 17.v),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 25.h,
                      right: 14.h,
                    ),
                    child: _buildProtein(
                      context,
                      proteinText: "Carbs",
                      seeAllText: "See all",
                    ),
                  ),
                  SizedBox(height: 31.v),
                  _buildCarbsList(context),
                  SizedBox(height: 64.v),
                ],
              ),
            ),
          ),
        ),
        // floatingActionButton: Padding(
        //   padding: EdgeInsets.fromLTRB(50, 0, 10, 0),
        //   child: _buildCreateRecipeButton(context),
        // ),
      ),
    );
  }

  /// Section Widget
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight +
          20.0), // Include extra space height + standard AppBar height
      child: Column(
        children: [
          SizedBox(
              height: 16.0), // Space above AppBar, adjust the height as needed
          CustomAppBar(
            leadingWidth: 73.h,
            leading: Container(
              width: 198.80,
              height: 66,
              margin: EdgeInsets.only(
                left: 29.h,
                top: 6.v,
                bottom: 6.v,
              ),
              padding: EdgeInsets.all(3.h),
              decoration: AppDecoration.outlineGray.copyWith(
                borderRadius: BorderRadiusStyle.roundedBorder20,
              ),
              child: AppbarImage(
                imagePath: ImageConstant.imgAvatar,
              ),
            ),
            title: Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.v),
              child: Column(
                children: [
                  AppbarTitle(
                    text: "Novice Cook",
                    textStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: appTheme.gray60002,
                    ),
                  ),
                  SizedBox(height: 3.v),
                  AppbarTitle(
                    text: "Astrid Zhao",
                    textStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: appTheme.gray60002,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildSavingSummary(BuildContext context) {
    return SizedBox(
      height: 160.v,
      child: ListView.separated(
        padding: EdgeInsets.only(
          left: 47.h,
          right: 38.h,
        ),
        scrollDirection: Axis.horizontal,
        separatorBuilder: (
          context,
          index,
        ) {
          return SizedBox(
            width: 14.h,
          );
        },
        itemCount: 2,
        itemBuilder: (context, index) {
          return RecipelistItemWidget();
        },
      ),
    );
  }

  /// Section Widget
  Widget _buildFavoriteRecipeRow(BuildContext context) {
    return Container(
      height: 85.v,
      padding: EdgeInsets.symmetric(vertical: 9.v),
      child: ListView.separated(
        padding: EdgeInsets.only(left: 10.h),
        scrollDirection: Axis.horizontal,
        separatorBuilder: (
          context,
          index,
        ) {
          return SizedBox(
            width: 24.h,
          );
        },
        itemCount: 8,
        itemBuilder: (context, index) {
          return RecipecontentrowItemWidget();
        },
      ),
    );
  }

  /// Section Widget
  Widget _buildCreateplanSection(BuildContext context) {
    return SizedBox(
      height: 151.v,
      width: 314.h,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: 314.h,
              margin: EdgeInsets.only(bottom: 19.v),
              padding: EdgeInsets.symmetric(
                horizontal: 21.h,
                vertical: 12.v,
              ),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    ImageConstant.imgGroup114,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  CustomImageView(
                    imagePath: ImageConstant.imgStrawberryCake,
                    height: 28.adaptSize,
                    width: 28.adaptSize,
                    margin: EdgeInsets.only(
                      left: 18.h,
                      top: 71.v,
                      bottom: 7.v,
                    ),
                  ),
                  CustomImageView(
                    imagePath: ImageConstant.imgInstantNoodles,
                    height: 28.adaptSize,
                    width: 28.adaptSize,
                    margin: EdgeInsets.only(
                      left: 7.h,
                      top: 39.v,
                      bottom: 39.v,
                    ),
                  ),
                  CustomImageView(
                    imagePath: ImageConstant.imgHamburger1,
                    height: 28.adaptSize,
                    width: 28.adaptSize,
                    margin: EdgeInsets.only(
                      left: 10.h,
                      top: 78.v,
                    ),
                  ),
                  Spacer(),
                  Container(
                    width: 113.h,
                    margin: EdgeInsets.only(
                      top: 16.v,
                      bottom: 37.v,
                    ),
                    child: Text(
                      "Save Time\nSave Money\nSave Enviornment",
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: appTheme.black900,
                        fontSize: 14.fSize,
                        fontFamily: 'Outfit',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreateRecipeButton(BuildContext context) {
    return Positioned(
      child: CustomElevatedButton(
        alignment: Alignment.bottomCenter,
        height: 48.v,
        width: 160.h, // This ensures the button stretches across the width
        text: "Create Recipe",
        buttonTextStyle: TextStyle(
          fontSize: 16, // Example size
          fontWeight: FontWeight.bold, // Example weight
          color: Colors.white, // Example color
        ),
        buttonStyle: CustomButtonStyles.fillYellow,
        onPressed: () {
          _navigateToNextScreen(context);
        },
      ),
    );
  }

  void _navigateToNextScreen(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => CreateTwoScreen()));
  }

  /// Saving Widget
  Widget _buildFiberList(BuildContext context) {
    return SizedBox(
      height: 88.v,
      child: ListView.separated(
        padding: EdgeInsets.only(
          left: 24.h,
          right: 12.h,
        ),
        scrollDirection: Axis.horizontal,
        separatorBuilder: (
          context,
          index,
        ) {
          return SizedBox(
            width: 12.h,
          );
        },
        itemCount: 4,
        itemBuilder: (context, index) {
          return IngredientslistItemWidget();
        },
      ),
    );
  }

  /// Section Widget
  Widget _buildProteinList(BuildContext context) {
    return SizedBox(
      height: 58.v,
      child: ListView.separated(
        padding: EdgeInsets.only(
          left: 24.h,
          right: 12.h,
        ),
        scrollDirection: Axis.horizontal,
        separatorBuilder: (
          context,
          index,
        ) {
          return SizedBox(
            width: 12.h,
          );
        },
        itemCount: 4,
        itemBuilder: (context, index) {
          return ProteinlistItemWidget();
        },
      ),
    );
  }

  /// Section Widget
  Widget _buildCarbsList(BuildContext context) {
    return SizedBox(
      height: 58.v,
      child: ListView.separated(
        padding: EdgeInsets.only(
          left: 25.h,
          right: 11.h,
        ),
        scrollDirection: Axis.horizontal,
        separatorBuilder: (
          context,
          index,
        ) {
          return SizedBox(
            width: 12.h,
          );
        },
        itemCount: 4,
        itemBuilder: (context, index) {
          return CarbslistItemWidget();
        },
      ),
    );
  }

  /// Common widget
  Widget _buildMyMealPlanSection(
    BuildContext context, {
    required String text,
    required String text1,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 1.v),
          child: Text(
            text,
            style: TextStyle(
              color: appTheme.black900,
              fontSize: 16.fSize,
              fontFamily: 'Outfit',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 4.v),
          child: Text(
            text1,
            style: TextStyle(
              color: appTheme.gray700,
              fontSize: 14.fSize,
              fontFamily: 'Outfit',
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  /// Common widget
  Widget _buildProtein(
    BuildContext context, {
    required String proteinText,
    required String seeAllText,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          proteinText,
          style: TextStyle(
            color: appTheme.black900,
            fontSize: 14.fSize,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
          ),
        ),
        Spacer(),
        Padding(
          padding: EdgeInsets.only(bottom: 2.v),
          child: Text(
            seeAllText,
            style: TextStyle(
              color: theme.colorScheme.secondaryContainer,
              fontSize: 12.fSize,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        CustomImageView(
          imagePath: ImageConstant.imgArrowRight,
          height: 10.adaptSize,
          width: 10.adaptSize,
          radius: BorderRadius.circular(
            5.h,
          ),
          margin: EdgeInsets.only(
            left: 1.h,
            top: 2.v,
            bottom: 4.v,
          ),
        ),
      ],
    );
  }
}
