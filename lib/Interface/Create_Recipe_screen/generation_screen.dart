import 'dart:developer';
import 'dart:core';
import 'dart:io';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:clipboard/clipboard.dart';
import 'package:astridzhao_s_food_app/Interface/Create_Recipe_screen/create_screen.dart';
import 'package:astridzhao_s_food_app/database/recipes_dao.dart';
import 'package:astridzhao_s_food_app/core/app_export.dart';
import 'package:astridzhao_s_food_app/database/database.dart';
import 'package:astridzhao_s_food_app/Interface/provider.dart';
import 'package:provider/provider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:astridzhao_s_food_app/database/recipesFormatConversion.dart';
import 'package:astridzhao_s_food_app/key/api_key.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class GenerationScreen extends StatefulWidget {
  final String resultCompletion;
  final RecipesCompanion recipe;

  GenerationScreen({Key? key, required this.resultCompletion})
      : recipe = RecipeFromLLMJson(resultCompletion),
        // recipe_from_favorite ,
        super(key: key);

  @override
  _GenerationScreenState createState() => _GenerationScreenState();
}

class _GenerationScreenState extends State<GenerationScreen> {
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
    return MaterialApp(
        home: SafeArea(
      child: Scaffold(
        appBar: customeAppbar(context),
        body: Column(
          children: [
            Column(
              children: [
                title(context),
                SizedBox(height: 5.v),
                saving_summery(context),
                SizedBox(height: 20.v),
                buttons_group(context),
                SizedBox(height: 10.v),
                //divider
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.v),
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Divider(
                    indent: 1,
                  ),
                ),
              ],
            ),
            // Below is recipe widgets
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                padding: EdgeInsets.only(top: 10.v),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // SizedBox(
                    //   // height: 25.v,
                    //   child: CustomImageView(
                    //     height: 100.adaptSize,
                    //     width: 100.adaptSize,
                    //     imagePath: ImageConstant.imgLogo2RemovebgPreview,
                    //     margin: EdgeInsets.only(top: 1.v),
                    //   ),
                    // ),
                    group_info(context),
                    instruction(context),
                    //divider
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20.v),
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Divider(
                        indent: 1,
                      ),
                    ),
                    SizedBox(height: 13.v),
                    _buildTimerControls(context),
                    SizedBox(height: 30.v),
                    bottomSettingBar(context),
                    SizedBox(height: 40.v),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }

  Future<void> generateImage(String recipe) async {
    // OpenAI.organization = riceBucketID;
    OpenAI.apiKey = azapikey;
    final image = await OpenAI.instance.image.create(
        n: 1,
        prompt: "Create an image of a dish related to the recipe titled '$recipe'. Note that the recipe title might be in a language other than English. The image should depict a dish that could be featured on a restaurant menu. " +
            "Please focus on creating an image that is appealing, with a cute and cartoonish style, making the dish look delicious and enticing to customers. " +
            "It is important that the image contains no text of any kind, focusing solely on the visual representation of the dish.");

    setState(() {
      for (int index = 0; index < image.data.length; index++) {
        final currentItem = image.data[index];
        generatedImageUrls = currentItem.url.toString();
        // print(currentItem.url);
      }
      ;
    });
  }

  PreferredSizeWidget customeAppbar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      toolbarHeight: MediaQuery.of(context).size.height * 0.1,
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
      actions: [
        TextButton.icon(
          icon: Icon(Icons.question_mark_rounded),
          label: Text("Want to see what it looks like?",
              style: TextStyle(
                  color: Color.fromARGB(255, 174, 73, 6),
                  fontFamily: "Outfit",
                  fontSize: 15.fSize)),
          onPressed: () async {
            // alert of generating...
            showDialog(
              context: context,
              barrierDismissible: false, // User must tap button to close dialog
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: Icon(
                            Icons.close,
                            color: Colors.black,
                            size: 25.adaptSize,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      Center(
                        child: Text(
                          "Crafting a delightful dish image...",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'Outfit', fontSize: 12.fSize),
                        ),
                      ),
                    ],
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 20.h,
                        height: 20.v, // Adjust the height as needed
                        child: CircularProgressIndicator(),
                      ),
                      SizedBox(height: 20.v),
                      Text("Do not exit.",
                          style: TextStyle(
                            fontFamily: 'Outfit',
                            fontWeight: FontWeight.bold,
                            wordSpacing: 0,
                            letterSpacing: 0,
                            fontSize: 10.fSize,
                            color: appTheme.orange_primary,
                          )),
                    ],
                  ),
                );
              },
            );

            await generateImage(widget.recipe.title.toString());
            Navigator.of(context).pop();
            showDialog(
              context: context,
              builder: (BuildContext context) => popupDialogImage(context),
            );
            // log("imageURL" + generatedImageUrls);
          },
        ),
      ],
    );
  }

  Widget Tooltipimage(BuildContext context) {
    return Tooltip(
      message: 'Click to generate',
      child: Text("Want to see what it looks like?",
          style: TextStyle(
              color: Color.fromARGB(255, 174, 73, 6),
              fontFamily: "Outfit",
              fontSize: 13)),
    );
  }

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
          //TODO: save image in local album gallery
          onPressed: () {},
          child: Text(
            'Save Image',
            style: TextStyle(color: Colors.black54, fontSize: 14.fSize),
          ),
        ),
        new TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'Close',
            style: TextStyle(color: Colors.black54, fontSize: 14.fSize),
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
        child: AutoSizeText(widget.recipe.title.value.toString(),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          madeButton(context),
          favoriteButton(context),
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
                    height: MediaQuery.of(context).size.height * 0.22,
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
                              widget.recipe.ingredients.value.join("\n \n"),
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
              // <-- Fixed width.
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
              Expanded(
                // Wrap the Text widget in Expanded
                child: SingleChildScrollView(
                  // Make it scrollable
                  child: Text(widget.recipe.notes.value.toString(),
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
                      title: Text(
                          widget.recipe.instructions.value.join('\n \n'),
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
      return 13.fSize;
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
                      widget.recipe.savingSummary_CO2.value.toString(),
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
                      widget.recipe.savingSummary_money.value.toString(),
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
            widget.recipe.cookTime.value.toString(),
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
      spacing: 10.adaptSize,
      children: <Widget>[
        IconButton(
          icon: Icon(copyIcon),
          tooltip: "Copy",
          onPressed: () {
            FlutterClipboard.copy(widget.resultCompletion);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Copied")),
            );
          },
        ),
        IconButton(
          icon: Icon(Icons.share),
          padding: EdgeInsets.only(right: 30.h),
          tooltip: "Share",
          onPressed: () {
            // TODO: Add share functionality here
          },
        ),
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
      padding: EdgeInsets.only(left: 10.h, right: 10.h),
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
            log("image saving name: " + path.basename(generatedImageUrls));
          }
        },
      ),
    );
  }

  Widget madeButton(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double fontsize_text = getResponsiveFontSize_buttontext(screenWidth);
    return Padding(
      padding: EdgeInsets.only(left: 10.h, right: 10.h),
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
            backgroundColor: index_color == 2 ? disableColor : enableColor,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(
              horizontal: 15.h,
              vertical: 8.v,
            ),
          ),
          onPressed: () {
            setState(() {
              index_color == 2;
            });

            incrementSavingNums(widget.recipe.savingSummary_CO2.value,
                widget.recipe.savingSummary_money.value);
          }),
    );
  }
}
