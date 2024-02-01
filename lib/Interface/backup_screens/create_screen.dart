import 'dart:developer';

import 'package:astridzhao_s_food_app/core/app_export.dart';
// import 'package:drift/drift.dart' ;
import 'package:flutter/material.dart';
import 'package:astridzhao_s_food_app/Interface/Create_Recipe_screen/generation_screen.dart';
import 'package:astridzhao_s_food_app/key/api_key.dart';
import 'package:astridzhao_s_food_app/Interface/Create_Recipe_screen/RecipeSettingBottomSheet.dart';
import 'package:astridzhao_s_food_app/widgets/custom_drop_down.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:language_picker/language_picker.dart';
import 'package:language_picker/languages.dart';
import 'package:auto_size_text/auto_size_text.dart';

/// Flutter code sample for [AppBar].

// ignore_for_file: must_be_immutable
class CreateScreen extends StatefulWidget {
  // final RecipesCompanion recipe;

  CreateScreen({
    Key? key,
  }) : super(key: key);
  @override
  CreateScreenState createState() => CreateScreenState();
}

class CreateScreenState extends State<CreateScreen> {
  // Create a GlobalKey
  // final GlobalKey<_CustomDropDownState> dropDownKey = GlobalKey<_CustomDropDownState>();
  String resultCompletion = "";
  late TextEditingController atomInputContainerController;

  void initState() {
    super.initState();
    atomInputContainerController = TextEditingController();
  }

  void dispose() {
    atomInputContainerController.dispose();
    super.dispose();
  }

  List<String> ingredients_protein = [
    "chicken breast",
    "chicken thigh",
    "beef brisket",
    "steak",
    "ground beef",
    "turkey bacon",
    "pork ribs",
    "pork chops",
    "shrimp",
    "fish fillet",
    "egg",
    "tofu",
    "tempeh",
  ];
  List<String> ingredients_vege = [
    "tomato",
    "onion",
    "brocolli",
    "califlower",
    "mushroom",
    "carrot",
    "cabbage",
    "spinach",
    "baby spinach",
    "brussel sprouts",
    "lettuce",
    "pepper",
    "cucumber",
    "zuchinni",
    "eggplant",
  ];

  List<String> ingredients_carb = [
    "egg noodle",
    "white rice",
    "wrap",
    "pasta",
    "potato",
    "sweet potato",
    "squash",
    "bread",
    "rolled oats"
  ];
  List<String> ingredients_others = [
    "peanut butter",
    "curry paste",
    "chicken broth",
    "garlic",
    "ginger",
  ];

  List<String> selectedIngredients = [];

  List<String> currentIngredientList = [];

  List<String> dropdownItemList1_cuisine = [
    "No Preference",
    "Asian",
    "Italian",
    "Mexican",
    "New American",
    "Indian",
    "Chinese",
    "Korean",
    "Thai",
    "Japanese",
    "German",
    "French",
    "Hungarian"
  ];

  List<String> dropdownItemList2_cooking_ethod = [
    "No Preference",
    "Pan Fry",
    "Steam",
    "Air Fry",
    "Oven",
    "Boil",
    "Blend"
  ];

  List<String> dropdownItemList3_dish_type = [
    "No Preference",
    "Breakfast",
    "Lunch/Dinner",
    "Baby Food",
    "Dessert",
    "Smoothie",
    "One-pot Meal",
    "Low Calorie Meal"
  ];

  List<String> dropdownItemList4_restriction = [
    "No Restriction",
    "Vegetarian",
    "Vegan",
    "Paleo",
    "Dukin",
    "Atkins",
    "Nuts Allergies",
    "Egg Allergies",
    "Gluten Allergies",
    "Diary Allergies",
    "Milk Allergies",
    "Seafood Allergies",
  ];

  List<String> dropdownItemList5_servingsize = [
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
  ];

  // Variables to hold the selected preferences
  String selectedCuisine = "No Preference";
  String selectedCookingMethod = "No Preference";
  String selectedDishType = "No Preference";
  String selectedDietaryRestriction = "No Restriction";
  String selectedServingSize = "1";
  String selectedLangauge = Languages.english.name;

  String get contentUser =>
      """My ingredients are denoted by backticks: ```$selectedIngredients```, DO NOT use any other ingredients that I did not pick, but you can use other essential sauce/spices; 
      and please following below cooking preferences: 1. Dish's cuisine style should be $selectedCuisine. 2. Dish type should be $selectedDishType. 3. Using cooking method $selectedCookingMethod to cook. 4. Be mindful of I have $selectedDietaryRestriction diet restriction. 5. I have $selectedServingSize people to eat. Tell me how many amount of food I need to use in 'Ingredient List'. """;

  String get system_prompt =>
      """As a professional personal recipe-generating assistant, your task is to create ONE recipe using provided leftover ingredients. The response should be formatted as a JSON object containing 7 child objects, each with specific data types and content requirements:  
      1. Title (String): The name of the dish. 
      2. Ingredient List (List[String]): Ingredients used in the recipe.
      3. Step-by-Step Instructions (List[String]): Detailed cooking steps.
      4. Expected Cooking Time (Integer): Time required for cooking, in minutes.
      5. Note (String): Additional tips.
      6. Saving Co2 (Double): Estimated CO2 savings in kilograms, calculated as the sum of (Amount of each food type wasted × Emission factor for that food type). The number should never be 0. Even if the result is an integer value, it should be represented with a decimal point (e.g., '3' should be '3.0')
      7. Saving Money (Double): Estimated monetary savings in US dollars, represented as a floating-point number. The number should never be 0. Even if the savings are whole numbers, they should be formatted with a decimal point (e.g., '5' should be '5.0').

      Format of the JSON object:
      {
        "Title": "String",
        "Ingredient List": ["String"],
        "Step-by-Step Instructions": ["String"],
        "Expected Cooking Time": Integer,
        "Note": "String",
        "Saving Co2": Double,
        "Saving Money": Double
      }"

      Additional Rules: 
    - The recipe must closely resemble dishes from the selected cuisine ($selectedCuisine).
    - Use only the ingredients provided by the user, with the allowance of essential sauces and spices.
    - The recipe output should be in the selected language ($selectedLangauge).
      """;

  double getResponsiveFontSize_title(double screenWidth) {
    if (screenWidth < 320) {
      // Smaller screens
      return 17.fSize;
    } else if (screenWidth < 480) {
      // Medium screens
      return 15.fSize;
    } else {
      // Larger screens
      return 14.fSize;
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    // Adjust aspect ratio based on screen width
    double childAspectRatio;
    if (screenWidth <= 320) {
      // for smaller screens like iPhone SE
      childAspectRatio = MediaQuery.of(context).size.width /
          (MediaQuery.of(context).size.height /
              2.3); // or whatever works for the smallest screen
    } else if (screenWidth <= 480) {
      // Decrease the aspect ratio as the screen gets wider
      childAspectRatio = MediaQuery.of(context).size.width /
          (MediaQuery.of(context).size.height /
              2.5); // You may need to adjust this value
    } else {
      childAspectRatio = MediaQuery.of(context).size.width /
          (MediaQuery.of(context).size.height / 2.7); // You may need to adju
    }

    double crossAxisSpacing;
    if (screenWidth <= 320) {
      // for smaller screens like iPhone SE
      crossAxisSpacing = 15; // or whatever works for the smallest screen
    } else if (screenWidth <= 480) {
      // Decrease the aspect ratio as the screen gets wider
      crossAxisSpacing = 10;

      /// You may need to adjust this value
    } else {
      // Decrease the aspect ratio as the screen gets wider
      crossAxisSpacing = 5; // You may need to adjust this value
    }

    return MaterialApp(
      home: SafeArea(
          child: Scaffold(
        backgroundColor: appTheme.yellow_secondary,
        resizeToAvoidBottomInset: false,
        // appBar: MyAppBar(),
        appBar: AppBar(
          leadingWidth: MediaQuery.of(context).size.width * 0.2,
          elevation: 0,
          backgroundColor: appTheme.yellow_secondary,
          leading: Builder(builder: (BuildContext context) {
            return CustomImageView(
              imagePath: ImageConstant.imgLogo2RemovebgPreview,
              fit: BoxFit.contain,
              margin: EdgeInsets.only(left: 10.h),
            );
          }),
          toolbarHeight: 100.v,
          //Testing:for UX
          // title: Text(
          //   'BRING YOUR OWN FRIDGE',
          //   // style: TextStyle(fontSize: 16.fSize, fontFamily: "Outfit"),
          // ),

          // // backgroundColor: Color(0xFF5A7756),
          // titleTextStyle: TextStyle(
          //     color: Color.fromARGB(190, 0, 0, 0),
          //     fontSize: 17.adaptSize,
          //     fontWeight: FontWeight.bold,
          //     fontFamily: "Outfit"),
          actions: <Widget>[
            //Testing:for UX
            // IconButton(
            //   icon: const Icon(Icons.more_horiz),
            //   color: Colors.blueGrey,
            //   splashColor: appTheme.orange_primary,
            //   tooltip: 'More Recipe Settings',
            //   onPressed: () {
            //     _buildRecipeSetting(context);
            //   },
            // ),
            TextButton(
              child: Text(
                "Generate",
                style: TextStyle(
                    fontSize: 15.fSize,
                    fontFamily: "Outfit",
                    color: appTheme.green_primary),
              ),
              onPressed: () async {
                // Show the dialog
                showDialog(
                  context: context,
                  barrierDismissible:
                      false, // User must tap button to close dialog
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: Row(
                        children: [
                          SizedBox(
                            width: 20.h,
                            height: 20.v, // Adjust the height as needed
                            child: CircularProgressIndicator(),
                          ),
                          SizedBox(width: 20.h),
                          Text("Crafting a culinary masterpiece..."),
                        ],
                      ),
                    );
                  },
                );

                await sendPrompt();
                // Close the dialog
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        GenerationScreen(resultCompletion: resultCompletion)));
              },
            ),
          ],
        ),
        body: Stack(children: [
          SingleChildScrollView(
              child: Container(
                  width: double.maxFinite,
                  margin: EdgeInsets.only(top: 5.v, bottom: 6.v),
                  child: Stack(children: [
                    Align(
                        alignment: Alignment.topCenter,
                        //Language Picker Widget
                        child: Padding(
                            padding: EdgeInsets.only(left: 30.h, right: 30.h),
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: appTheme.yellow_primary,
                                      borderRadius: BorderRadius.circular(
                                        20.h,
                                      ),
                                    ),
                                    child: (_buildLanguagePicker(context)),
                                  ),
                                  SizedBox(height: 20.v),

                                  // Choose Preference Widget
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10.h, vertical: 24.v),
                                    decoration: BoxDecoration(
                                      color: appTheme.gray700,
                                      borderRadius: BorderRadius.circular(
                                        20.h,
                                      ),
                                    ),
                                    child: GridView.count(
                                      primary: false,
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      crossAxisSpacing:
                                          crossAxisSpacing, //space between columns
                                      mainAxisSpacing: 0, //space between rows
                                      crossAxisCount:
                                          MediaQuery.of(context).size.width >
                                                  600
                                              ? 3
                                              : 2,
                                      childAspectRatio: childAspectRatio,
                                      children: <Widget>[
                                        cuisineStyle(context),
                                        cookingMethod(context),
                                        dishType(context),
                                        dietaryRestriction(context),
                                        servingSize(context),
                                        //add number of dishes as an option
                                      ],
                                    ),
                                  ),
                                  _buildIngredientInputSection(context),
                                  SizedBox(height: 40.v),
                                ]))),
                  ]))),
        ]),
      )),
    );
  }

  Widget cuisineStyle(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Cuisine Style",
            style: TextStyle(
                color: Colors.white, fontSize: 12.fSize, fontFamily: "Outfit"),
          ),
          SizedBox(height: 4.v),
          Flexible(
            child: CustomDropDown(
              hintText: dropdownItemList1_cuisine.first,
              hintStyle: TextStyle(fontSize: 13.fSize, fontFamily: "Outfit"),
              items: dropdownItemList1_cuisine,
              onChanged: (value) {
                setState(() {
                  selectedCuisine = value;
                });
                // _updateSelections();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget cookingMethod(BuildContext context) {
    return SizedBox(
      // height: MediaQuery.of(context).size.height * 0.10,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Cooking Method",
            style: TextStyle(
                color: Colors.white, fontSize: 12.fSize, fontFamily: "Outfit"),
          ),
          SizedBox(height: 4.v),
          Flexible(
            child: CustomDropDown(
              hintText: dropdownItemList2_cooking_ethod.first,
              hintStyle: TextStyle(fontSize: 13.fSize, fontFamily: "Outfit"),
              items: dropdownItemList2_cooking_ethod,
              onChanged: (value) {
                setState(() {
                  selectedCookingMethod = value;
                });
                // _updateSelections();
              },
            ),
          )
        ],
      ),
    );
  }

  Widget dishType(BuildContext context) {
    return SizedBox(
      // height: MediaQuery.of(context).size.height * 0.10,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Dish Type",
            style: TextStyle(
                color: Colors.white, fontSize: 12.fSize, fontFamily: "Outfit"),
          ),
          SizedBox(height: 4.v),
          Flexible(
            child: CustomDropDown(
              hintText: dropdownItemList3_dish_type.first,
              hintStyle: TextStyle(fontSize: 13.fSize, fontFamily: "Outfit"),
              items: dropdownItemList3_dish_type,
              onChanged: (value) {
                setState(() {
                  selectedDishType = value;
                });
                // _updateSelections();
              },
            ),
          )
        ],
      ),
    );
  }

  Widget dietaryRestriction(BuildContext context) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Dietary Restriction",
            style: TextStyle(
                color: Colors.white, fontSize: 12.fSize, fontFamily: "Outfit"),
          ),
          SizedBox(height: 4.v),
          Flexible(
            child: CustomDropDown(
              hintText: dropdownItemList4_restriction.first,
              hintStyle: TextStyle(fontSize: 13.fSize, fontFamily: "Outfit"),
              items: dropdownItemList4_restriction,
              onChanged: (value) {
                setState(() {
                  selectedDietaryRestriction = value;
                });
                // _updateSelections();
              },
            ),
          )
        ],
      ),
    );
  }

  Widget servingSize(BuildContext context) {
    return SizedBox(
      // height: MediaQuery.of(context).size.height * 0.10,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Serving Size",
            style: TextStyle(
                color: Colors.white, fontSize: 12.fSize, fontFamily: "Outfit"),
          ),
          SizedBox(height: 4.v),
          Flexible(
            child: CustomDropDown(
              hintText: dropdownItemList5_servingsize.first,
              hintStyle: TextStyle(fontSize: 13.fSize, fontFamily: "Outfit"),
              items: dropdownItemList5_servingsize,
              onChanged: (value) {
                setState(() {
                  selectedServingSize = value;
                });
                // _updateSelections();
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildLanguagePicker(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20.h, right: 00.0, top: 0.0, bottom: 00.0),
      child: Row(
        children: [
          const Text(
            "Pick Your Language",
            style: TextStyle(fontSize: 13, fontFamily: "Outfit"),
          ),
          // const Spacer(),
          SizedBox(width: 20.h),
          SizedBox(
            width: 150.h,
            child: LanguagePickerDropdown(
              initialValue: Languages.english,
              itemBuilder: ((language) => DropdownMenuItem(
                      child: Text(
                    language.name,
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: "Outfit",
                      fontWeight: FontWeight.w300,
                      fontSize: 14.adaptSize,
                    ),
                  ))),
              onValuePicked: (Language language) {
                setState(() {
                  selectedLangauge = language.name;
                  
                });
              },
            ),
          )
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildIngredientInputSection(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double responsiveFontSize_title = getResponsiveFontSize_title(screenWidth);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 4.v),
        TextFormField(
          readOnly: true,
          maxLines: null,
          // keyboardType: TextInputType.text,
          controller: atomInputContainerController,
          decoration: InputDecoration(
            labelText: "Add today's ingredients (max to 6)",
            labelStyle: TextStyle(
              fontFamily: "Outfit",
              fontSize: 14.fSize,
            ),
            // errorText: "Cannot be Empty"
          ),
          style: TextStyle(
            fontSize: 16.fSize, // Font size for the input text
            fontFamily: "Outfit",
            // You can add other styling properties here if needed
          ),
        ),
        SizedBox(height: 20.h),

        //Ingredients choosing widgets
        Text("Choose My Protein",
            textAlign: TextAlign.center,
            softWrap: true,
            style: TextStyle(
              fontSize: responsiveFontSize_title,
              fontFamily: "Outfit",
            )),
        SizedBox(height: 10.h),
        _buildButtonProtein(context),
        SizedBox(height: 10.h),
        Text("Choose My Fiber",
            textAlign: TextAlign.center,
            softWrap: true,
            style: TextStyle(
              fontSize: responsiveFontSize_title,
              fontFamily: "Outfit",
            )),
        SizedBox(height: 10.h),
        _buildButtonVegetable(context),
        SizedBox(height: 10.h),
        Text("Choose My Carbs",
            textAlign: TextAlign.center,
            softWrap: true,
            style: TextStyle(
              fontSize: responsiveFontSize_title,
              fontFamily: "Outfit",
            )),
        SizedBox(height: 5.h),
        _buildButtonCarb(context),
        SizedBox(height: 10.h),
        Text("Choose Additionals",
            textAlign: TextAlign.center,
            maxLines: 1,
            softWrap: true,
            style: TextStyle(
              fontSize: responsiveFontSize_title,
              fontFamily: "Outfit",
            )),
        SizedBox(height: 5.h),
        _buildButtonOthers(context),
      ],
    );
  }

  void addIngredientItem(List<String> currentIngredientList) async {
    String? newIngredient = await _showAddIngredientDialog(context);
    if (newIngredient != null && newIngredient.isNotEmpty) {
      setState(() {
        currentIngredientList.add(newIngredient);
      });
    }
  }

  Widget _buildButtonProtein(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: ingredients_protein.length + 1,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisExtent: 40.v,
          crossAxisCount: MediaQuery.of(context).size.width > 600 ? 5 : 3,
          // childAspectRatio: MediaQuery.of(context).size.width *0.2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10),
      itemBuilder: (context, index) {
        if (index == ingredients_protein.length) {
          return SizedBox(
              height: 5.v,
              width: 5.h,
              child: FittedBox(
                  fit: BoxFit.contain,
                  child: FloatingActionButton(
                    heroTag: null,
                    // You can adjust this as needed
                    tooltip: "Add a new protein",
                    onPressed: () {
                      // currentIngredientList = ingredients_protein;
                      addIngredientItem(ingredients_protein);
                    },
                    child: Icon(Icons.add),
                    backgroundColor: appTheme.yellow_primary,
                    // shape: RoundedRectangleBorder(
                    //     borderRadius:
                    //         BorderRadius.all(Radius.circular(10)))
                  )));
        } else {
          String data = ingredients_protein[index];
          bool isSelected = selectedIngredients.contains(data);
          return ElevatedButton(
            style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 1.h),
                textStyle: TextStyle(fontFamily: "Outfit", fontSize: 12.fSize),
                foregroundColor: Colors.white,
                backgroundColor:
                    isSelected ? Colors.grey : appTheme.green_primary),
            onPressed: () {
              setState(() {
                if (selectedIngredients.contains(data)) {
                  // If the data is already selected, remove it
                  selectedIngredients.remove(data);
                } else {
                  if (selectedIngredients.length < 6) {
                    // If the data is not selected, add it
                    selectedIngredients.add(data);
                  }
                }
                atomInputContainerController.text =
                    selectedIngredients.join("  ");
              });
            },
            child: AutoSizeText(data,
                textAlign: TextAlign.center,
                softWrap: true,
                style: TextStyle(
                  fontFamily: "Outfit",
                  fontSize: 13.fSize,
                )),
          );
        }
      },
    );
  }

  Widget _buildButtonVegetable(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: ingredients_vege.length + 1, // Add 1 for the "Add" button
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisExtent: 40.v,
          crossAxisCount: MediaQuery.of(context).size.width > 600 ? 5 : 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10),
      itemBuilder: (context, index) {
        if (index == ingredients_vege.length) {
          return SizedBox(
              height: 5.v,
              width: 5.h,
              child: FittedBox(
                  fit: BoxFit.contain,
                  child: FloatingActionButton(
                    heroTag: null,
                    tooltip: "Add a new vegetable",
                    onPressed: () {
                      // currentIngredientList = ingredients_vege;
                      addIngredientItem(ingredients_vege);
                    },
                    child: Icon(Icons.add),
                    backgroundColor: appTheme.yellow_primary,
                    // shape: RoundedRectangleBorder(
                    //     borderRadius:
                    //         BorderRadius.all(Radius.circular(10)))
                  )));
        } else {
          String data = ingredients_vege[index];
          bool isSelected = selectedIngredients.contains(data);
          return ElevatedButton(
            style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 1.h),
                textStyle: TextStyle(fontFamily: "Outfit", fontSize: 13.fSize),
                foregroundColor: Colors.white,
                backgroundColor:
                    isSelected ? Colors.grey : appTheme.green_primary),
            onPressed: () {
              setState(() {
                if (selectedIngredients.contains(data)) {
                  selectedIngredients.remove(data);
                } else {
                  if (selectedIngredients.length < 6) {
                    selectedIngredients.add(data);
                  }
                }
                atomInputContainerController.text =
                    selectedIngredients.join("  ");
              });
            },
            child: AutoSizeText(data,
                textAlign: TextAlign.center,
                softWrap: true,
                maxLines: 1,
                style: TextStyle(
                  fontFamily: "Outfit",
                  fontSize: 13.fSize,
                )),
          );
        }
      },
    );
  }

  Widget _buildButtonCarb(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: ingredients_carb.length + 1, // Add 1 for the "Add" button
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisExtent: 40.v,
          crossAxisCount: MediaQuery.of(context).size.width > 600 ? 5 : 3,
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0),
      itemBuilder: (context, index) {
        if (index == ingredients_carb.length) {
          return SizedBox(
              height: 5.v,
              width: 5.h,
              child: FittedBox(
                  fit: BoxFit.contain,
                  child: FloatingActionButton(
                    heroTag: null,
                    tooltip: "Add a new carb",
                    onPressed: () {
                      // currentIngredientList = ingredients_carb;
                      addIngredientItem(ingredients_carb);
                    },
                    child: Icon(Icons.add),
                    backgroundColor: appTheme.yellow_primary,
                    // shape: RoundedRectangleBorder(
                    //     borderRadius:
                    //         BorderRadius.all(Radius.circular(10)))
                  )));
        } else {
          String data = ingredients_carb[index];
          bool isSelected = selectedIngredients.contains(data);
          return ElevatedButton(
            style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 1.h),
                textStyle: TextStyle(fontFamily: "Outfit", fontSize: 13.fSize),
                foregroundColor: Colors.white,
                backgroundColor:
                    isSelected ? Colors.grey : appTheme.green_primary),
            onPressed: () {
              setState(() {
                if (selectedIngredients.contains(data)) {
                  // If the data is already selected, remove it
                  selectedIngredients.remove(data);
                } else {
                  if (selectedIngredients.length < 6) {
                    // If the data is not selected, add it
                    selectedIngredients.add(data);
                  }
                }
                atomInputContainerController.text =
                    selectedIngredients.join("  ");
              });
            },
            child: AutoSizeText(data,
                textAlign: TextAlign.center,
                softWrap: true,
                maxLines: 1,
                style: TextStyle(
                  fontFamily: "Outfit",
                  fontSize: 13.fSize,
                )),
          );
        }
      },
    );
  }

  Widget _buildButtonOthers(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: ingredients_others.length + 1, // Add 1 for the "Add" button
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisExtent: 40.v,
          crossAxisCount: MediaQuery.of(context).size.width > 600 ? 5 : 3,
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0),
      itemBuilder: (context, index) {
        if (index == ingredients_others.length) {
          return SizedBox(
              height: 5.v,
              width: 5.h,
              child: FittedBox(
                  fit: BoxFit.contain,
                  child: FloatingActionButton(
                    heroTag: null,
                    tooltip: "Add",
                    onPressed: () {
                      // currentIngredientList = ingredients_others;
                      addIngredientItem(ingredients_others);
                    },
                    child: Icon(Icons.add),
                    backgroundColor: appTheme.yellow_primary,
                    // shape: RoundedRectangleBorder(
                    //     borderRadius:
                    //         BorderRadius.all(Radius.circular(10)))
                  )));
        } else {
          String data = ingredients_others[index];
          bool isSelected = selectedIngredients.contains(data);
          return ElevatedButton(
            style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 1.h),
                textStyle: TextStyle(fontFamily: "Outfit", fontSize: 13.fSize),
                foregroundColor: Colors.white,
                backgroundColor:
                    isSelected ? Colors.grey : appTheme.green_primary),
            onPressed: () {
              setState(() {
                if (selectedIngredients.contains(data)) {
                  // If the data is already selected, remove it
                  selectedIngredients.remove(data);
                } else {
                  if (selectedIngredients.length < 6) {
                    // If the data is not selected, add it
                    selectedIngredients.add(data);
                  }
                }
                atomInputContainerController.text =
                    selectedIngredients.join("  ");
              });
            },
            child: AutoSizeText(data,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                softWrap: true,
                style: TextStyle(fontFamily: "Outfit", fontSize: 13.fSize)),
          );
        }
      },
    );
  }

  void _buildRecipeSetting(BuildContext context) async {
    final result = await showModalBottomSheet<Map<String, String>>(
      context: context,
      builder: (BuildContext bc) {
        return RecipeSettingBottomSheet(
          initialSelections: {
            'cuisine': selectedCuisine,
            'cookingMethod': selectedCookingMethod,
            'dishType': selectedDishType,
            'dietaryRestriction': selectedDietaryRestriction,
            'servingsize': selectedServingSize,
          },
          onSelectionChanged: (selections) {
            setState(() {
              selectedCuisine = selections['cuisine'] ?? '';
              selectedCookingMethod = selections['cookingMethod'] ?? '';
              selectedDishType = selections['dishType'] ?? '';
              selectedDietaryRestriction =
                  selections['dietaryRestriction'] ?? '';
              selectedServingSize = selections['servingsize'] ?? '';
            });
          },
        );
      },
    );

    if (result != null) {
      setState(() {
        selectedCuisine = result['cuisine'] ?? '';
        selectedCookingMethod = result['cookingMethod'] ?? '';
        selectedDishType = result['dishType'] ?? '';
        selectedDietaryRestriction = result['dietaryRestriction'] ?? '';
        selectedServingSize = result['dietaryRestriction'] ?? '';
      });
    }
  }

  sendPrompt() async {
    // OpenAI.organization = riceBucketID;
    OpenAI.apiKey = azapikey;
    final systemMessage = OpenAIChatCompletionChoiceMessageModel(
      // content: "I want to provide delicious recipe for users by using their leftover ingredients. You act as a professional personal recipe-generating assistant who need to create ONE recipe using provided ingredients. " +
      //     " To ensure a precise and high-quality response, you should following below rules: 1. please return the response in create a JSON object which enumerates a set of 7 child objects, " +
      //     " Each objects are respectively named as Title, Ingredient List, Step-by-Step Instructions, Expected Cooking Time, Note, Saving Co2, and Saving Money." +
      //     " The result JSON objetcs should be in this format: " +
      //     "{Title: string, Ingredient List: list[String], Step-by-Step Instructions: list[String], Expected Cooking Time: integer, Note: String, Saving Co2: double, Saving Money: double}." +
      //     " 2. the unit of 'Expected Cooking Time' is in minutes; " +
      //     " 3. the creative recipe need to be as similar to famous and authentic $selectedCuisine dishes as possible; " +
      //     " 4. 'Saving Co2' should be an estimated double number of Co2 the user saved from this meal by reducing food waste. Total CO2 emissions=∑(Amount of each food type wasted×Emission factor for that food type); " +
      //     " 5. 'Saving money' should be estimated double number of money the user saved from not throw those ingredients; " +
      //     " 6. Do not use any other food/ingredients that users did not pick, but you can use some essential sauce/spices." +
      //     " 7. The recipe output should be in $selectedLangauge language. ",
      content: system_prompt,

      role: OpenAIChatMessageRole.assistant,
    );
    // log(system_prompt);

    // the user message that will be sent to the request.
    final userMessage = OpenAIChatCompletionChoiceMessageModel(
      content: contentUser,
      role: OpenAIChatMessageRole.user,
    );

    // all messages to be sent.
    final requestMessages = [
      systemMessage,
      userMessage,
    ];
    final completion = await OpenAI.instance.chat
        .create(model: 'gpt-3.5-turbo', messages: requestMessages);

    setState(() {
      resultCompletion = completion.choices.first.message.content;

      log(resultCompletion);

      // atomInputContainerController.clear();
      // selectedIngredients.clear();
    });
  }
}

Future<String?> _showAddIngredientDialog(BuildContext context) async {
  String? ingredientName;

  return showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          'Add Ingredient',
          style: TextStyle(fontSize: 14.fSize, fontFamily: "Outfit"),
        ),
        content: TextField(
          autofocus: true,
          onChanged: (value) {
            ingredientName = value;
          },
          decoration: InputDecoration(hintText: "Enter ingredient name"),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              'Cancel',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 13.fSize,
                  fontFamily: "Outfit"),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text(
              'Add',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 13.fSize,
                  fontFamily: "Outfit"),
            ),
            onPressed: () {
              Navigator.of(context).pop(ingredientName);
            },
          ),
        ],
      );
    },
  );
}
