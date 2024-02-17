import 'dart:developer';
import 'dart:core';
import 'dart:io';
import 'package:astridzhao_s_food_app/database/recipesFormatConversion.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:clipboard/clipboard.dart';
import 'package:astridzhao_s_food_app/Interface/backup_screens/old-create_screen.dart';
import 'package:astridzhao_s_food_app/database/recipes_dao.dart';
import 'package:astridzhao_s_food_app/core/app_export.dart';
import 'package:astridzhao_s_food_app/database/database.dart';
import 'package:astridzhao_s_food_app/Interface/provider_SavingsModel.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class GenerationScreen_favorite extends StatefulWidget {
  final Recipe recipe;

  GenerationScreen_favorite({Key? key, required this.recipe})
      :
        // recipe_from_favorite ,
        super(key: key);

  @override
  _GenerationScreenState createState() => _GenerationScreenState();
}

class _GenerationScreenState extends State<GenerationScreen_favorite> {
  ScrollController _scrollController = ScrollController();
  ScrollController _scrollController_ingredient = ScrollController();

  IconData copyIcon = Icons.content_copy_rounded;
  RecipesDao recipesDao = RecipesDao(DatabaseService().database);
  String generatedImageUrls = "";
  Color enableColor = appTheme.orange_primary;
  Color disableColor = Colors.grey; //your color
  int index_color = -1;

  // add notifier Model for increasing numbers, used in madeButton
  void incrementSavingNums(double co2, double dollar) {
    print("add co2: " + co2.toString());
    print("add dollar: " + dollar.toString());
    final savingsModel = Provider.of<SavingsModel>(context, listen: false);
    savingsModel.savingCo2 += co2;
    savingsModel.savingDollar += dollar;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customeAppbar(context),
      body: Stack(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            padding: EdgeInsets.only(top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                title(context),
                SizedBox(height: 5),
                saving_summery(context),
                SizedBox(height: 20),
                buttons_group(context),
                SizedBox(height: 10),
                //divider
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Divider(
                    indent: 1,
                  ),
                ),
                SizedBox(height: 18),
                group_info(context),
                instruction(context),
                //divider
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Divider(
                    indent: 1,
                  ),
                ),
                // SizedBox(height: 13),
                // _buildTimerControls(context),
                SizedBox(height: 30),
                bottomSettingBar(context),
                SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget customeAppbar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.keyboard_backspace),
        tooltip: 'Back to home page',
        color: Colors.blueGrey,
        splashColor: appTheme.orange_primary,
        onPressed: () {
          Navigator.of(context).pop(
            MaterialPageRoute(builder: (context) => CreateScreen()),
          );
        },
      ),
    );
  }

  // // class Tooltipimage extends State<GenerationScreen> {
  // Widget Tooltipimage(BuildContext context) {
  //   return Tooltip(
  //     message: 'Click to generate',
  //     child: Text("Do you want to see what it looks like?",
  //         style: TextStyle(
  //             color: Color.fromARGB(255, 174, 73, 6),
  //             fontFamily: "Outfit",
  //             fontSize: 13)),
  //   );
  // }

  Widget popupDialogImage(BuildContext context) {
    return new AlertDialog(
      // title: const Text('Your dish looks like...'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.network(generatedImageUrls),
        ],
      ),
      actions: <Widget>[
        new TextButton(
          onPressed: () {},
          child: Text(
            'Save Image',
            style: TextStyle(color: Colors.black54),
          ),
        ),
        new TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'Close',
            style: TextStyle(color: Colors.black54),
          ),
        ),
      ],
    );
  }

  /// Section Widget
  Widget title(BuildContext context) {
    return Container(
        padding: EdgeInsets.fromLTRB(60, 0, 60, 20),
        alignment: Alignment.topCenter,
        child: AutoSizeText(widget.recipe.title.toString(),
            textAlign: TextAlign.center,
            maxLines: 2,
            style: TextStyle(
                fontFamily: "Outfit",
                fontSize: 16.fSize,
                fontWeight: FontWeight.w500)));
  }

  Widget buttons_group(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // favoriteButton(context),
          madeButton(context),
        ],
      ),
    );
  }

  Widget group_info(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Child left: ingredient + cooking time:
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(10.h, 0, 0, 10.v),
              padding: EdgeInsets.fromLTRB(0, 0, 5.h, 15.v),
              decoration: AppDecoration.fillYellow.copyWith(
                borderRadius: BorderRadiusStyle.roundedBorder10,
              ),
              width: MediaQuery.of(context).size.width * 0.45,
              child: Column(
                children: [
                  CustomImageView(
                    height: 40.adaptSize,
                    width: 40.adaptSize,
                    imagePath: ImageConstant.tomato,
                    margin: EdgeInsets.only(bottom: 5.v, top: 2.v),
                  ),
                  Text(
                    "Ingredients",
                    style: TextStyle(
                      fontFamily: "Outfit",
                      fontSize: 16.fSize,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  // SizedBox(height: 5.v),
                  Container(
                    padding: EdgeInsets.only(top: 5.v),
                    height: MediaQuery.of(context).size.height * 0.23,
                    child: Scrollbar(
                      controller: _scrollController_ingredient,
                      thumbVisibility: true,
                      thickness: 3.0,
                      radius: Radius.circular(5),
                      child: ListView.builder(
                        controller: _scrollController_ingredient,
                        itemCount: 1,
                        // itemCount: 1,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(
                              widget.recipe.ingredients.join("\n \n"),
                              style: TextStyle(
                                fontFamily: "Outfit",
                                fontSize: 12.fSize,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              child: cookingTime(context),
            ),
          ],
        ),

        Container(
          margin: EdgeInsets.fromLTRB(0, 0, 10.h, 0),
          padding: EdgeInsets.fromLTRB(10.h, 10.v, 5.h, 15.v),
          height: MediaQuery.of(context).size.height * 0.4,
          width: MediaQuery.of(context).size.width * 0.35,
          decoration: AppDecoration.fillYellow.copyWith(
            borderRadius: BorderRadiusStyle.roundedBorder10,
          ),
          child: Column(
            children: [
              CustomImageView(
                height: 40.adaptSize,
                width: 40.adaptSize,
                imagePath: ImageConstant.imggenerationpage_notes,
                margin: EdgeInsets.only(bottom: 5.v, top: 2.v),
              ),
              SizedBox(
                height: 10.v,
              ),
              //note section
              Expanded(
                // Wrap the Text widget in Expanded
                child: SingleChildScrollView(
                  // Make it scrollable
                  child: Text(widget.recipe.notes.toString(),
                      style: TextStyle(
                          fontFamily: "Outfit",
                          fontSize: 12.fSize,
                          fontWeight: FontWeight.normal)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget instruction(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.adaptSize),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5.h),
        padding: EdgeInsets.all(10.adaptSize),
        decoration: AppDecoration.fillYellow.copyWith(
          borderRadius: BorderRadiusStyle.roundedBorder10,
        ),
        child: Column(
          children: [
            CustomImageView(
              height: MediaQuery.of(context).size.height * 0.05,
              width: MediaQuery.of(context).size.width * 0.1,
              imagePath: ImageConstant.imggenerationpage_instruction,
              margin: EdgeInsets.only(bottom: 0, top: 2.v),
            ),
            SizedBox(height: 5.v),
            Text(
              "Instructions",
              style: TextStyle(
                  fontFamily: "Outfit",
                  fontSize: 16.fSize,
                  fontWeight: FontWeight.w500),
            ),
            Container(
              padding: EdgeInsets.only(top: 5.v),
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width * 0.8,
              child: Scrollbar(
                controller: _scrollController,
                thumbVisibility: true,
                thickness: 3.0, // Optional: Adjust thickness of the scrollbar
                radius: Radius.circular(5),
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(widget.recipe.instructions.join('\n \n'),
                          style: TextStyle(
                              fontFamily: "Outfit",
                              fontSize: 12.fSize,
                              fontWeight: FontWeight.normal)),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  double getResponsiveFontSize_savingSummary(double screenWidth) {
    if (screenWidth < 320) {
      // Smaller screens
      return 18.fSize;
    } else if (screenWidth < 480) {
      // Medium screens
      return 14.fSize;
    } else {
      // Larger screens
      return 14.fSize;
    }
  }

  /// Section Widget
  Widget saving_summery(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double fontsize_unit = getResponsiveFontSize_savingSummary(screenWidth);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.h),
      padding: EdgeInsets.symmetric(
        horizontal: 20.h,
        vertical: 6.v,
      ),
      decoration: AppDecoration.fillGray.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 5.v),
          Text(
            "You will save",
            style: TextStyle(
                fontFamily: "Outfit",
                fontSize: 16.fSize,
                color: Colors.white,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12.v),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.only(left: 17.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: 6.v,
                      bottom: 11.v,
                    ),
                    child: Text(
                      widget.recipe.savingSummary_CO2.toString(),
                      style: TextStyle(
                          fontFamily: "Outfit",
                          fontSize: 18.fSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 25.h,
                      top: 14.v,
                      bottom: 3.v,
                    ),
                    child: Text(
                      "KG CO2",
                      style: TextStyle(
                          fontFamily: "Outfit",
                          fontSize: fontsize_unit,
                          color: Colors.white),
                    ),
                  ),
                  Spacer(
                    flex: 50,
                  ),
                  SizedBox(
                    height: 36.v,
                    child: VerticalDivider(
                      width: 1.h,
                      thickness: 1.v,
                      color: Colors.white,
                    ),
                  ),
                  Spacer(
                    flex: 49,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 7.v,
                      bottom: 10.v,
                    ),
                    child: Text(
                      widget.recipe.savingSummary_money.toString(),
                      style: TextStyle(
                          fontFamily: "Outfit",
                          fontSize: 18.fSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 28.h,
                      top: 15.v,
                      bottom: 2.v,
                    ),
                    child: Text(
                      "DOLLARS",
                      style: TextStyle(
                          fontFamily: "Outfit",
                          fontSize: fontsize_unit,
                          color: Colors.white),
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

  Widget cookingTime(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10.h,
        vertical: 2.v,
      ),
      height: MediaQuery.of(context).size.height * 0.05,
      width: MediaQuery.of(context).size.width * 0.45,
      decoration: AppDecoration.fillYellow.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomImageView(
            height: 20.adaptSize,
            width: 20.adaptSize,
            imagePath: ImageConstant.imgClasicAlarmClock,
            margin: EdgeInsets.only(top: 1.v),
          ),
          Spacer(),
          Text(
            widget.recipe.cookTime.toString(),
            style: TextStyle(fontFamily: "Outfit", fontSize: 14.fSize),
          ),
          Spacer(),
          Text(
            "minutes",
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildTimerControls(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.h),
      padding: EdgeInsets.symmetric(
        horizontal: 28.h,
        vertical: 12.v,
      ),
      decoration: AppDecoration.fillYellow.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder20,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CustomImageView(
            // imagePath: ImageConstant.imgImage24,
            height: 30.adaptSize,
            width: 30.adaptSize,
            margin: EdgeInsets.only(
              left: 2.h,
              top: 7.v,
              bottom: 37.v,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              "Start",
              style: theme.textTheme.bodySmall,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              "End",
              style: theme.textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }

  Widget bottomSettingBar(BuildContext context) {
    return OverflowBar(
      alignment: MainAxisAlignment.end,
      spacing: 10,
      children: <Widget>[
        IconButton(
          icon: Icon(copyIcon),
          tooltip: "Copy",
          onPressed: () {
            FlutterClipboard.copy(recipeToCopyableMarkdown(widget.recipe));
            // ScaffoldMessenger.of(context).showSnackBar(
            //   SnackBar(content: Text("Copied")),
            // );
          },
        ),
        IconButton(
            icon: Icon(Icons.share),
            padding: EdgeInsets.only(right: 30),
            tooltip: "Share",
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
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
                            "Close",
                            style: TextStyle(
                                fontFamily: "Outfit",
                                fontSize: 12.fSize,
                                color: appTheme.black900),
                          ),
                        ),
                      ],
                    );
                  });
            }),
      ],
    );
  }

  double getResponsiveFontSize_buttontext(double screenWidth) {
    if (screenWidth < 320) {
      // Smaller screens
      return 16.fSize;
    } else if (screenWidth < 480) {
      // Medium screens
      return 14.fSize;
    } else {
      // Larger screens
      return 13.fSize;
    }
  }

  Widget favoriteButton(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double fontsize_text = getResponsiveFontSize_buttontext(screenWidth);
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: TextButton.icon(
        icon: Icon(Icons.favorite_border_outlined),
        label: Text(
          "Add to My Favorite",
          style: TextStyle(
            fontFamily: "Outfit",
            fontSize: fontsize_text,
          ),
        ),
        style: TextButton.styleFrom(
          backgroundColor: index_color == 1 ? disableColor : enableColor,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(
            horizontal: 15.h,
            vertical: 8.v,
          ),
        ),
        onPressed: () async {
          setState(() {
            index_color = 1;
          });

          final insertedRecipe = await recipesDao
              .into(recipesDao.recipes)
              .insertReturning(widget.recipe);

          int currentID = insertedRecipe.id;
          // log("ID: " + currentID.toString());
          // log(generatedImageUrls);
          if (generatedImageUrls != "") {
            //save image to local -> generatedImageUrls
            var response = await http.get(Uri.parse(generatedImageUrls));
            // store pictures in document directory
            Directory documentdirectory =
                await getApplicationDocumentsDirectory();
            File file = new File(path.join(
                documentdirectory.path, path.basename(generatedImageUrls)));
            await file.writeAsBytes(response.bodyBytes);
            log("image saving path: " + file.path);
            await (recipesDao.update(recipesDao.recipes)..where((tbl) => tbl.id.equals(currentID)))
              ..write(RecipesCompanion(imageURL: drift.Value(path.basename(generatedImageUrls))));
            // log("image saving name: " + path.basename(generatedImageUrls));
          }
        },
      ),
    );
  }

  Widget madeButton(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double fontsize_text = getResponsiveFontSize_buttontext(screenWidth);
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: TextButton.icon(
          icon: Icon(Icons.hdr_strong),
          label: Text(
            "I made it",
            style: TextStyle(
              fontFamily: "Outfit",
              fontSize: fontsize_text,
            ),
          ),
          style: TextButton.styleFrom(
            backgroundColor: index_color == 1 ? disableColor : enableColor,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(
              horizontal: 15.h,
              vertical: 8.v,
            ),
          ),
          onPressed: () {
            setState(() {
              index_color == 1;
            });

            incrementSavingNums(widget.recipe.savingSummary_CO2,
                widget.recipe.savingSummary_money);
          }),
    );
  }
}
