import 'dart:io';

import 'package:astridzhao_s_food_app/Interface/_favorites_screen.dart';
import 'package:astridzhao_s_food_app/database/database.dart';
import 'package:astridzhao_s_food_app/database/recipesFormatConversion.dart';
import 'package:astridzhao_s_food_app/database/recipes_dao.dart';

import '../homepage_page/widgets/recipecontentrow_item_widget.dart';
import 'widgets/saving_summery_widget.dart';
import 'package:astridzhao_s_food_app/core/app_export.dart';
import 'package:astridzhao_s_food_app/widgets/app_bar/appbar_image.dart';
import 'package:astridzhao_s_food_app/widgets/app_bar/appbar_title.dart';
import 'package:astridzhao_s_food_app/widgets/app_bar/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:developer';

// ignore_for_file: must_be_immutable
class HomepagePage extends StatefulWidget {
  HomepagePage({Key? key})
      : super(
          key: key,
        );
  HomepagePageState createState() => HomepagePageState();
}

class HomepagePageState extends State<HomepagePage> {
  final recipe_dao = RecipesDao(DatabaseService().database);

  Stream<List<String?>> getFilteringValues() {
    final imageURL = recipe_dao.recipes.imageURL;
    // print(imageURL);
    // Assuming 'select' and 'get' are correctly defined in your DAO
    final query = recipe_dao.selectOnly(recipe_dao.recipes, distinct: true)
      ..addColumns([imageURL]);
    // Map the results of the query to a list of strings (image URLs)
    Stream<List<String?>> recipeImageURL = query
        .watch()
        .map((rows) => rows.map((row) => row.read(imageURL)).toList());

    // print(recipeImageURL);
    return recipeImageURL;
    // return query.map((row) => row.read(imageURL));
  }

  Map<int, String> allRecipeImageURLs = {};

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
                    child: _buildDividerSection_favorite_page(
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
                    child: _buildDividerSection_mealPlan(
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
      height: 170.v,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SavingSummeryWidget(
              title: "Reduced",
              imagePath: ImageConstant.co2,
              counter: 1,
              unit: "KG"),
          SizedBox(width: 28),
          SavingSummeryWidget(
              title: "Saved",
              imagePath: ImageConstant.moneybig,
              counter: 2,
              unit: "USD"),
        ],
      ),
    );
  }

  Widget _buildFavoriteRecipeRow(BuildContext context) {
    return Container(
      height: 76.v,
      padding: EdgeInsets.symmetric(vertical: 5.v),
      child: StreamBuilder<List<String?>>(
        stream: getFilteringValues(), // This is your stream of image URLs
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show loading indicator while waiting for data
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Display an error message if something went wrong
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // Display a message if there are no recipes
            return Center(child: Text('No favorites yet...'));
          }

          // Here we have data
          List<String?> urls = snapshot.hasData ? snapshot.data! : [];
          String default_image_url = "assets/images/generate2.png";
          // // If no URLs are fetched, add a default URL to the list
          // if (urls.isEmpty) {
          //   urls.add(
          //       default_image_url); // Replace with your actual default image URL
          // }
          return ListView.separated(
            padding: EdgeInsets.only(left: 10.h),
            scrollDirection: Axis.horizontal,
            separatorBuilder: (context, index) => SizedBox(width: 15),
            itemCount: urls.length,
            itemBuilder: (context, index) {
              // Use the URL if it's not null, otherwise use the default image URL
              String imageUrl = urls[index] ??
                  default_image_url; // Replace with your actual default image URL
              return RecipecontentrowItemWidget(imagefilePath: imageUrl);
            },
          );
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
                    width: 120.h,
                    margin: EdgeInsets.only(
                      top: 16.v,
                      bottom: 33.v,
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

  /// Common widget
  Widget _buildDividerSection_favorite_page(
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
          child: TextButton(
            child: Text(
              text1,
              style: TextStyle(
                color: appTheme.gray700,
                fontSize: 14.fSize,
                fontFamily: 'Outfit',
                fontWeight: FontWeight.w400,
              ),
            ),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => FavoriteRecipePage()));
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDividerSection_mealPlan(
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
          child: TextButton(
            child: Text(
              text1,
              style: TextStyle(
                color: appTheme.gray700,
                fontSize: 14.fSize,
                fontFamily: 'Outfit',
                fontWeight: FontWeight.w400,
              ),
            ),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => FavoriteRecipePage()));
            },
          ),
        ),
      ],
    );
  }
}
