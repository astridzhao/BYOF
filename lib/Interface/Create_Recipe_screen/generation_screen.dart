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
  IconData copyIcon = Icons.content_copy_rounded;
  RecipesDao recipesDao = RecipesDao(DatabaseService().database);
  String generatedImageUrls = "";
  Color enableColor = appTheme.green_primary;
  Color disableColor = Colors.grey; //your color
  int index_color = -1;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
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
                  SizedBox(height: 13),
                  _buildTimerControls(context),
                  SizedBox(height: 30),
                  bottomSettingBar(context),
                  SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> generateImage(String recipe) async {
    OpenAI.apiKey = azapiKey;
    final image = await OpenAI.instance.image.create(
        n: 1,
        prompt: "You act as a professional image-generating assistant. By referencing the recipe title $recipe, use your imagination to create a related dish image can put on my restaurant menu. " +
            "The image style should be cute and cartoon, and make it looks tasty to attract customers. " +
            "Do not put any text on the image. ");

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
        // TODO(astrid): save image locally + get local url
        // final imageURL =
        //     "path-to-image";
        TextButton.icon(
          icon: Icon(Icons.question_mark_rounded),
          label: Text("Want to see what it looks like?",
              style: TextStyle(
                  color: Color.fromARGB(255, 174, 73, 6),
                  fontFamily: "Outfit",
                  fontSize: 13)),
          onPressed: () async {
            await generateImage(widget.recipe.title.toString());
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
        child: Text(widget.recipe.title.value.toString(),
            textAlign: TextAlign.center,
            maxLines: 2,
            style: TextStyle(
                fontFamily: "Outfit",
                fontSize: 14.fSize,
                fontWeight: FontWeight.w500)));
  }

  Widget group_info(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        //Child left: ingredient + cooking time:
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                // CustomImageView(
                //   height: 40,
                //   width: 40,
                //   imagePath: ImageConstant.imggenerationpage_ingredient,
                //   margin: EdgeInsets.only(
                //     top: 5,
                //     bottom: 5,
                //   ),
                // ),
                // Spacer(),
                Container(
                  margin: EdgeInsets.fromLTRB(10, 0, 0, 10),
                  padding: EdgeInsets.fromLTRB(0, 0, 5, 15),
                  decoration: AppDecoration.fillYellow.copyWith(
                    borderRadius: BorderRadiusStyle.roundedBorder10,
                  ),
                  height: MediaQuery.of(context).size.height * 0.25,
                  width: MediaQuery.of(context).size.width *
                      0.5, // <-- Fixed width
                  child: ListView.builder(
                    itemCount: 1,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(widget.recipe.ingredients.value.join('\n'),
                            style: TextStyle(
                                fontFamily: "Outfit",
                                fontSize: 12.fSize,
                                fontWeight: FontWeight.normal)),
                      );
                    },
                  ),
                ),
              ],
            ),
            SizedBox(
              // <-- Fixed width.
              child: cookingTime(context),
            ),
          ],
        ),

        Container(
          margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
          padding: EdgeInsets.fromLTRB(10, 10, 5, 15),
          height: MediaQuery.of(context).size.height * 0.3,
          width: MediaQuery.of(context).size.width * 0.4,
          decoration: AppDecoration.fillYellow.copyWith(
            borderRadius: BorderRadiusStyle.roundedBorder10,
          ),
          child: Column(
            children: [
              CustomImageView(
                height: 40,
                width: 40,
                imagePath: ImageConstant.imggenerationpage_notes,
                margin: EdgeInsets.only(bottom: 5, top: 2),
              ),
              Text(widget.recipe.notes.value.toString(),
                  style: TextStyle(
                      fontFamily: "Outfit",
                      fontSize: 12.fSize,
                      fontWeight: FontWeight.normal)),
            ],
          ),
        ),

        //   ],
        // ),
      ],
    );
  }

  Widget instruction(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5.h),
        padding: EdgeInsets.all(10),
        decoration: AppDecoration.fillYellow.copyWith(
          borderRadius: BorderRadiusStyle.roundedBorder10,
        ),
        child: Column(
          children: [
            SizedBox(height: 5),
            Text(
              "Instructions",
              style: TextStyle(
                  fontFamily: "Outfit",
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
            ),
            Container(
              padding: EdgeInsets.only(top: 5),
              height: 300,
              child: ListView.builder(
                itemCount: 1,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(widget.recipe.instructions.value.join('\n \n'),
                        style: TextStyle(
                            fontFamily: "Outfit",
                            fontSize: 12.fSize,
                            fontWeight: FontWeight.normal)),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Section Widget
  Widget saving_summery(BuildContext context) {
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
                fontSize: 14,
                color: Colors.white70,
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
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white70),
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
                          fontSize: 14,
                          color: Colors.white70),
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
                      color: Colors.white60,
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
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white70),
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
                          fontSize: 14,
                          color: Colors.white70),
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
      height: MediaQuery.of(context).size.height * 0.03,
      width: MediaQuery.of(context).size.width * 0.5,
      decoration: AppDecoration.fillYellow.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomImageView(
            height: 20.h,
            width: 20.v,
            imagePath: ImageConstant.imgClasicAlarmClock,
            margin: EdgeInsets.only(top: 1.v),
          ),
          Spacer(),
          Text(
            widget.recipe.cookTime.value.toString(),
            style: TextStyle(fontFamily: "Outfit", fontSize: 12.fSize),
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
      alignment: MainAxisAlignment.spaceEvenly,
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
          tooltip: "Share",
          onPressed: () {
            // TODO: Add share functionality here
          },
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: TextButton.icon(
            icon: Icon(Icons.favorite_border_outlined),
            label: Text(
              "Add to My Favorite",
              style: TextStyle(
                fontFamily: "Outfit",
              ),
            ),
            style: TextButton.styleFrom(
              backgroundColor: index_color == 1 ? disableColor : enableColor,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(
                horizontal: 15.0,
                vertical: 8.0,
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
        ),
      ],
    );
  }
}
