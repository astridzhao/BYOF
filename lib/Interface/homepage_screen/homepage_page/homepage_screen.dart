import 'dart:async';
import 'package:astridzhao_s_food_app/Interface/homepage_screen/homepage_page/widgets/recipecontentrow_item_widget.dart';
import 'package:astridzhao_s_food_app/Interface/homepage_screen/homepage_page/widgets/saving_summery_widget.dart';
import 'package:astridzhao_s_food_app/bloc/authentication_bloc.dart';
import 'package:astridzhao_s_food_app/widgets/app_bar/appbar_title.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:astridzhao_s_food_app/database/database.dart';
import 'package:astridzhao_s_food_app/database/recipes_dao.dart';
import 'package:astridzhao_s_food_app/Interface/provider_SavingsModel.dart';
import 'package:astridzhao_s_food_app/core/app_export.dart';
import 'package:astridzhao_s_food_app/widgets/app_bar/custom_app_bar.dart';
import 'package:astridzhao_s_food_app/Interface/favorite_page/myfavorite-screen.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key})
      : super(
          key: key,
        );
  HomePagetate createState() => HomePagetate();
}

class Savings {
  final double co2;
  final double dollar;
  Savings(this.co2, this.dollar);
}

class HomePagetate extends State<HomePage> {
  //call database
  final recipe_dao = RecipesDao(DatabaseService().database);
  double savingCo2 = 0;
  double savingDollar = 0;

// retrieve saving model data
  Savings getSavingNums() {
    final savingsModel = Provider.of<SavingsModel>(context, listen: false);
    savingCo2 = savingsModel.savingCo2;
    savingDollar = savingsModel.savingDollar;
    return Savings(savingCo2, savingDollar);
    // Use savingCo2 as needed
  }

  Stream<List<String?>> getFilteringValues() {
    final imageURL = recipe_dao.recipes.imageURL;
    final query = recipe_dao.selectOnly(recipe_dao.recipes, distinct: true)
      ..addColumns([imageURL]);
    // Map the results of the query to a list of strings (image URLs)
    Stream<List<String?>> recipeImageURL = query
        .watch()
        .map((rows) => rows.map((row) => row.read(imageURL)).toList());

    return recipeImageURL;
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
          height: SizeUtils.height,
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
                  buildSavingSummary(context),
                  SizedBox(height: 20.v),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 25.h,
                      right: 20.h,
                    ),
                    child: buildDividerSection_favorite_page(
                      context,
                      text: "My Favorite Recipes",
                      text1: "See all",
                    ),
                  ),
                  Divider(
                    color: appTheme.gray800,
                    indent: 20.h,
                    endIndent: 10.h,
                  ),
                  SizedBox(height: 3.v),
                  buildFavoriteRecipeRow(context),
                  SizedBox(height: 15.v),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 25.h,
                      right: 20.h,
                    ),
                    child: buildDividerSection_mealPlan(
                      context,
                      text: "My Meal Plan",
                      text1: "View",
                    ),
                  ),
                  SizedBox(height: 1.v),
                  Divider(
                    color: appTheme.gray800,
                    indent: 20.h,
                    endIndent: 10.h,
                  ),
                  SizedBox(height: 10.v),
                  mealplanDraft(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Section Widget
  PreferredSizeWidget buildAppBar(BuildContext context) {
    // Get the screen width and height
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return PreferredSize(
      preferredSize: Size.fromHeight(screenHeight * 0.1),
      child: // Space above AppBar, adjust the height as needed
          CustomAppBar(
        elevation: 0,
        backgroundColor: appTheme.yellow5001,
        centerTitle: true,
        title: Text(
          'Bring Your Own Fridge',
          style: TextStyle(
              color: Color.fromARGB(190, 0, 0, 0),
              fontSize: 16.fSize,
              fontWeight: FontWeight.w500,
              fontFamily: "Outfit"),
        ),
        toolbarHeight: screenHeight * 0.1,
        leadingWidth: MediaQuery.of(context).size.width * 0.2,
        leading: Builder(builder: (BuildContext context) {
          return CustomImageView(
            imagePath: ImageConstant.imgLogo2RemovebgPreview,
            fit: BoxFit.contain,
            margin: EdgeInsets.only(left: 10.h),
          );
        }),
      ),
    );
  }

  /// Section Widget
  Widget buildSavingSummary(BuildContext context) {
    Savings savings = getSavingNums();

    return SizedBox(
      height: 170.v,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SavingSummeryWidget(
              title: "Reduced",
              imagePath: ImageConstant.co2,
              counter: savings.co2,
              unit: "KG"),
          SizedBox(width: 28),
          SavingSummeryWidget(
              title: "Saved",
              imagePath: ImageConstant.moneybig,
              counter: savings.dollar,
              unit: "USD"),
        ],
      ),
    );
  }

  Widget buildFavoriteRecipeRow(BuildContext context) {
    return Container(
      height: 76.v,
      padding: EdgeInsets.symmetric(vertical: 5.v),
      child: StreamBuilder<List<String?>>(
        stream: getFilteringValues(), // have image name (second half of path)
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
          String default_image_url = "assets/images/random_image_pizza.png";
          return ListView.separated(
            padding: EdgeInsets.only(left: 10.h),
            scrollDirection: Axis.horizontal,
            separatorBuilder: (context, index) => SizedBox(width: 15),
            itemCount: urls.length,
            itemBuilder: (context, index) {
              // Use the URL if it's not null, otherwise use the default image URL
              String imageUrl = urls[index] ?? default_image_url;

              return RecipecontentrowItemWidget(imagefilePath: imageUrl);
            },
          );
        },
      ),
    );
  }

  double getResponsiveFontSize_mealplan(double screenWidth) {
    if (screenWidth < 320) {
      // Smaller screens
      return 14.fSize;
    } else if (screenWidth < 480) {
      // Medium screens
      return 12.fSize;
    } else {
      // Larger screens
      return 11.fSize;
    }
  }

  Widget mealplanDraft(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double fontsize_slogan = getResponsiveFontSize_mealplan(screenWidth);

    return Container(
      width: screenWidth * 0.8, // Adjust the width as needed
      height: screenHeight * 0.2, // Adjust the height as needed
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              width: screenWidth * 0.8,
              height: screenHeight * 0.18,
              decoration: ShapeDecoration(
                color: Color(0xFFEDBA8E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(screenWidth * 0.1),
                ),
              ),
            ),
          ),
          Positioned(
            // Adjust position for rectangle
            left: screenWidth * 0.1,
            top: screenHeight * -0.04,
            child: Container(
              width: screenWidth * 0.8,
              height: screenHeight * 0.9,
              child: Stack(
                // children images
                children: [
                  Positioned(
                    left: 0,
                    top: 63,
                    child: Container(
                      width: 27,
                      height: 27,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/img_vegetarian.png'),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 127,
                    top: 145.90,
                    child: Transform(
                      transform: Matrix4.identity()
                        ..translate(0.0, 0.0)
                        ..rotateZ(-1.14),
                      child: Container(
                        width: 160.54,
                        height: 148.87,
                        decoration: ShapeDecoration(
                          gradient: LinearGradient(
                            begin: Alignment(0.00, -1.00),
                            end: Alignment(0, 1),
                            colors: [Color(0xFFE9E9E9), Color(0x00E9E9E9)],
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(21),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 95,
                    top: 56,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/img_melonpie.png'),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 89,
                    top: 132,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/img_hamburger.png'),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 51,
                    top: 93,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image:
                              AssetImage('assets/images/img_instantnoodle.png'),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 16,
                    top: 125,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                              'assets/images/img_strawberrycake.png'),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: screenWidth * 0.26,
                    top: screenHeight * 0.08,
                    child: SizedBox(
                      width: screenWidth * 0.4,
                      height: screenHeight * 0.6,
                      child: Text(
                        'Save Time\nSave Money\nSave Enviornment',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: fontsize_slogan,
                          fontFamily: 'Outfit',
                          fontWeight: FontWeight.w400,
                          height: 0,
                        ),
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

  /// Section Widget
  Widget _buildCreateplanSection(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return SizedBox(
      width: screenWidth * 0.86,
      height: screenHeight * 0.25,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: screenWidth * 0.85,
              height: screenHeight * 0.20,
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
  Widget buildDividerSection_favorite_page(
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
                  builder: (context) => FavoriteRecipePage2()));
            },
          ),
        ),
      ],
    );
  }

  Widget buildDividerSection_mealPlan(
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
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(
                        "Sorry! This feature is not available yet.",
                        style:
                            TextStyle(fontFamily: "Outfit", fontSize: 14.fSize),
                      ),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              "OK",
                              style: TextStyle(
                                  fontFamily: "Outfit",
                                  fontSize: 12.fSize,
                                  color: appTheme.black900),
                            ))
                      ],
                    );
                  });
            },
          ),
        ),
      ],
    );
  }

  /// Section Widget
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    // Get the screen width and height
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return PreferredSize(
      preferredSize: Size.fromHeight(screenHeight * 0.13),
      child: CustomAppBar(
        backgroundColor: Colors.transparent,
        leading: CircleAvatar(
          // Adjust the radius as needed
          backgroundColor: Colors.transparent,
          child: CustomImageView(
            imagePath: ImageConstant.imgAvatar,
            height: 100.adaptSize,
            width: 100.adaptSize,
            margin: EdgeInsets.all(0.03 * screenWidth),
            fit: BoxFit.contain,
          ),
        ),
        title: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: 0.02 * screenWidth, vertical: 0.1 * screenHeight),
          child: Column(
            children: [
              AppbarTitle(
                text: "Level",
                textStyle: TextStyle(
                  fontSize: 15.fSize,
                  fontWeight: FontWeight.normal,
                  color: appTheme.gray60002,
                ),
              ),
              SizedBox(height: 3.v),
              AppbarTitle(
                text: "User",
                textStyle: TextStyle(
                  fontSize: 20.fSize,
                  fontWeight: FontWeight.w500,
                  color: appTheme.gray60002,
                ),
              ),
            ],
          ),
        ),
        actions: [
          BlocConsumer<AuthenticationBloc, AuthenticationState>(
            listener: (context, state) {
              if (state is AuthenticationLoadingState) {
                const CircularProgressIndicator();
              } else if (state is AuthenticationFailureState) {
                showDialog(
                    context: context,
                    builder: (context) {
                      return const AlertDialog(
                        content: Text('error'),
                      );
                    });
              }
            },
            builder: (context, state) {
              return ElevatedButton(
                  onPressed: () {
                    BlocProvider.of<AuthenticationBloc>(context).add(SignOut());
                  },
                  child: const Text('logOut'));
            },
          ),
        ],
      ),
    );
  }
}
