import 'dart:developer';

import 'package:astridzhao_s_food_app/core/app_export.dart';
import 'package:astridzhao_s_food_app/database/database.dart';
import 'package:astridzhao_s_food_app/database/recipesFormatConversion.dart';
import 'package:flutter/material.dart';
import 'package:astridzhao_s_food_app/Interface/Create_Recipe_screen/generation_screen.dart';
import 'package:astridzhao_s_food_app/key/api_key.dart';
import 'package:astridzhao_s_food_app/Interface/Create_Recipe_screen/RecipeSettingBottomSheet.dart';
import 'package:astridzhao_s_food_app/widgets/custom_drop_down.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:language_picker/language_picker.dart';
import 'package:language_picker/languages.dart';

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
  TextEditingController atomInputContainerController = TextEditingController();

  String selectedLangauge = Languages.english.name;

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
  List<String> ingredients_fruit = [
    "apple",
    "banana",
    "strawberry",
    "blueberry",
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
    "American",
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
    "Quick Meal",
    "One-pot Meal",
    "Low Calorie Meal"
  ];

  List<String> dropdownItemList4_restriction = [
    "No Restriction",
    "Vegetarian",
    "Vegan",
    "Nuts Allergies"
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

  String get contentUser =>
      "My ingredients are denoted by backticks: ```$selectedIngredients``` ;" +
      "and please following below cooking preferences: "
          "1. Cuisine style should be $selectedCuisine. "
          "2. Dish type should be $selectedDishType. " +
      "3. Using cooking method $selectedCookingMethod to cook. "
          "4. Be mindful of I have $selectedDietaryRestriction diet restriction. "
          "5. I have $selectedServingSize people to eat. ";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      backgroundColor: appTheme.yellow_secondary,
      resizeToAvoidBottomInset: false,
      // appBar: MyAppBar(),
      appBar: AppBar(
        leadingWidth: 80,
        elevation: 0,
        backgroundColor: appTheme.yellow_secondary,
        leading: Builder(builder: (BuildContext context) {
          return CustomImageView(
            imagePath: ImageConstant.imgLogo2RemovebgPreview,
            margin: EdgeInsets.only(left: 10),
          );
        }),
        title: const Text('BRING YOUR OWN FRIDGE'),
        toolbarHeight: 90,
        // backgroundColor: Color(0xFF5A7756),
        titleTextStyle: TextStyle(
            color: Color.fromARGB(190, 0, 0, 0),
            fontSize: 15,
            fontWeight: FontWeight.bold,
            fontFamily: "Outfit"),
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
                  fontFamily: "Outfit", color: appTheme.green_primary),
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
                          width: 20,
                          height: 20, // Adjust the height as needed
                          child: CircularProgressIndicator(),
                        ),
                        SizedBox(width: 20),
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
                margin: EdgeInsets.only(top: 5, bottom: 6.v),
                child: Stack(children: [
                  Align(
                      alignment: Alignment.topCenter,
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
                                SizedBox(height: 20),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 20),
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
                                    // padding:  EdgeInsets.all(2),
                                    crossAxisSpacing: 15,
                                    mainAxisSpacing: 1,
                                    crossAxisCount: 2,
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
    ));
  }

  Widget cuisineStyle(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.10,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Cuisine Style",
            style: TextStyle(
                color: Colors.white, fontSize: 10, fontFamily: "Outfit"),
          ),
          SizedBox(height: 3),
          CustomDropDown(
            hintText: dropdownItemList1_cuisine.first,
            hintStyle: TextStyle(fontSize: 12, fontFamily: "Outfit"),
            items: dropdownItemList1_cuisine,
            onChanged: (value) {
              setState(() {
                selectedCuisine = value;
              });
              // _updateSelections();
            },
          ),
        ],
      ),
    );
  }

  Widget cookingMethod(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.10,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Cooking Method",
            style: TextStyle(
                color: Colors.white, fontSize: 10, fontFamily: "Outfit"),
          ),
          SizedBox(height: 3),
          CustomDropDown(
            hintText: dropdownItemList2_cooking_ethod.first,
            hintStyle: TextStyle(fontSize: 12, fontFamily: "Outfit"),
            items: dropdownItemList2_cooking_ethod,
            onChanged: (value) {
              setState(() {
                selectedCookingMethod = value;
              });
              // _updateSelections();
            },
          ),
        ],
      ),
    );
  }

  Widget dishType(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.10,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Dish Type",
            style: TextStyle(
                color: Colors.white, fontSize: 10, fontFamily: "Outfit"),
          ),
          SizedBox(height: 3),
          CustomDropDown(
            hintText: dropdownItemList3_dish_type.first,
            hintStyle: TextStyle(fontSize: 12, fontFamily: "Outfit"),
            items: dropdownItemList3_dish_type,
            onChanged: (value) {
              setState(() {
                selectedDishType = value;
              });
              // _updateSelections();
            },
          ),
        ],
      ),
    );
  }

  Widget dietaryRestriction(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.10,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Dietary Restriction",
            style: TextStyle(
                color: Colors.white, fontSize: 10, fontFamily: "Outfit"),
          ),
          SizedBox(height: 3),
          CustomDropDown(
            hintText: dropdownItemList4_restriction.first,
            hintStyle: TextStyle(fontSize: 12, fontFamily: "Outfit"),
            items: dropdownItemList4_restriction,
            onChanged: (value) {
              setState(() {
                selectedDietaryRestriction = value;
              });
              // _updateSelections();
            },
          ),
        ],
      ),
    );
  }

  Widget servingSize(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.10,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Serving Size",
            style: TextStyle(
                color: Colors.white, fontSize: 10, fontFamily: "Outfit"),
          ),
          SizedBox(height: 3),
          CustomDropDown(
            hintText: dropdownItemList5_servingsize.first,
            hintStyle: TextStyle(fontSize: 12, fontFamily: "Outfit"),
            items: dropdownItemList5_servingsize,
            onChanged: (value) {
              setState(() {
                selectedServingSize = value;
              });
              // _updateSelections();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLanguagePicker(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: 20.0, right: 00.0, top: 0.0, bottom: 00.0),
      child: Row(
        children: [
          const Text(
            "Pick Your Language",
            style: TextStyle(fontSize: 13, fontFamily: "Outfit"),
          ),
          // const Spacer(),
          SizedBox(width: 20),
          SizedBox(
            width: 150,
            child: LanguagePickerDropdown(
              initialValue: Languages.english,
              itemBuilder: ((language) => DropdownMenuItem(
                      child: Text(
                    language.name,
                    style: const TextStyle(
                      color: Colors.black,
                      fontFamily: "Outfit",
                      fontWeight: FontWeight.w300,
                      fontSize: 12,
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
              labelText: "Add today's ingredients (max to 5)",
              labelStyle: TextStyle(
                fontFamily: "Outfit",
                fontSize: 14,
              )),
        ),
        SizedBox(height: 20),
        Text("Choose My Protein",
            textAlign: TextAlign.center,
            softWrap: true,
            style: TextStyle(
              fontFamily: "Outfit",
            )),
        SizedBox(height: 10),
        _buildButtonProtein(context),
        SizedBox(height: 10),
        Text("Choose My Fiber",
            textAlign: TextAlign.center,
            softWrap: true,
            style: TextStyle(
              fontFamily: "Outfit",
            )),
        SizedBox(height: 10),
        _buildButtonVegetable(context),
        SizedBox(height: 10),
        Text("Choose My Carbs",
            textAlign: TextAlign.center,
            softWrap: true,
            style: TextStyle(
              fontFamily: "Outfit",
            )),
        SizedBox(height: 5),
        _buildButtonCarb(context),
        SizedBox(height: 10),
        Text("Choose Additionals",
            textAlign: TextAlign.center,
            softWrap: true,
            style: TextStyle(
              fontFamily: "Outfit",
            )),
        SizedBox(height: 5),
        _buildButtonOthers(context),
      ],
    );
  }

  Widget _buildButtonProtein(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: ingredients_protein.length + 1,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisExtent: 40.v,
          crossAxisCount: 3,
          // childAspectRatio: MediaQuery.of(context).size.width *0.2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10),
      itemBuilder: (context, index) {
        if (index == ingredients_protein.length) {
          // This is the "Add" button

          return SizedBox(
              height: 5,
              width: 5,
              child: FittedBox(
                  fit: BoxFit.contain,
                  child: FloatingActionButton(
                    heroTag: null,
                    // You can adjust this as needed
                    tooltip: "Add a new protein",
                    onPressed: () {
                      currentIngredientList = ingredients_protein;
                      addIngredientItem();
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
                padding: EdgeInsets.symmetric(horizontal: 1),
                textStyle: TextStyle(fontFamily: "Outfit", fontSize: 12),
                foregroundColor: Colors.white,
                backgroundColor:
                    isSelected ? Colors.grey : appTheme.green_primary),
            onPressed: () {
              setState(() {
                if (selectedIngredients.contains(data)) {
                  // If the data is already selected, remove it
                  selectedIngredients.remove(data);
                } else {
                  if (selectedIngredients.length < 5) {
                    // If the data is not selected, add it
                    selectedIngredients.add(data);
                  }
                }
                atomInputContainerController.text =
                    selectedIngredients.join("  ");
              });
            },
            child: Text(data,
                textAlign: TextAlign.center,
                softWrap: true,
                style: TextStyle(
                  fontFamily: "Outfit",
                )),
          );
        }
      },
    );
  }

  void addIngredientItem() async {
    String? newIngredient = await _showAddIngredientDialog(context);
    if (newIngredient != null && newIngredient.isNotEmpty) {
      setState(() {
        currentIngredientList.add(newIngredient);
      });
    }
  }

  Widget _buildButtonVegetable(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: ingredients_vege.length + 1, // Add 1 for the "Add" button
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisExtent: 40.v,
          crossAxisCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10),
      itemBuilder: (context, index) {
        if (index == ingredients_vege.length) {
          // This is the "Add" button

          return SizedBox(
              height: 5,
              width: 5,
              child: FittedBox(
                  fit: BoxFit.contain,
                  child: FloatingActionButton(
                    heroTag: null,
                    tooltip: "Add a new vegetable",
                    onPressed: () {
                      currentIngredientList = ingredients_vege;
                      addIngredientItem();
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
                padding: EdgeInsets.symmetric(horizontal: 1),
                textStyle: TextStyle(fontFamily: "Outfit", fontSize: 12),
                foregroundColor: Colors.white,
                backgroundColor:
                    isSelected ? Colors.grey : appTheme.green_primary),
            onPressed: () {
              setState(() {
                if (selectedIngredients.contains(data)) {
                  selectedIngredients.remove(data);
                } else {
                  if (selectedIngredients.length < 5) {
                    selectedIngredients.add(data);
                  }
                }
                atomInputContainerController.text =
                    selectedIngredients.join("  ");
              });
            },
            child: Text(data,
                textAlign: TextAlign.center,
                softWrap: true,
                style: TextStyle(
                  fontFamily: "Outfit",
                )),
          );
        }
      },
    );
  }

  Widget _buildButtonCarb(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: ingredients_carb.length + 1, // Add 1 for the "Add" button
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisExtent: 40.v,
          crossAxisCount: 3,
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0),
      itemBuilder: (context, index) {
        if (index == ingredients_carb.length) {
          // This is the "Add" button
          currentIngredientList = ingredients_carb;
          return SizedBox(
              height: 5,
              width: 5,
              child: FittedBox(
                  fit: BoxFit.contain,
                  child: FloatingActionButton(
                    heroTag: null,
                    tooltip: "Add a new carb",
                    onPressed: () {
                      currentIngredientList = ingredients_carb;
                      addIngredientItem();
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
                padding: EdgeInsets.symmetric(horizontal: 1),
                textStyle: TextStyle(fontFamily: "Outfit", fontSize: 12),
                foregroundColor: Colors.white,
                backgroundColor:
                    isSelected ? Colors.grey : appTheme.green_primary),
            onPressed: () {
              setState(() {
                if (selectedIngredients.contains(data)) {
                  // If the data is already selected, remove it
                  selectedIngredients.remove(data);
                } else {
                  if (selectedIngredients.length < 5) {
                    // If the data is not selected, add it
                    selectedIngredients.add(data);
                  }
                }
                atomInputContainerController.text =
                    selectedIngredients.join("  ");
              });
            },
            child: Text(data,
                textAlign: TextAlign.center,
                softWrap: true,
                style: TextStyle(
                  fontFamily: "Outfit",
                )),
          );
        }
      },
    );
  }

  Widget _buildButtonOthers(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: ingredients_others.length + 1, // Add 1 for the "Add" button
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisExtent: 40.v,
          crossAxisCount: 3,
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0),
      itemBuilder: (context, index) {
        if (index == ingredients_others.length) {
          // This is the "Add" button
          currentIngredientList = ingredients_others;
          return SizedBox(
              height: 5,
              width: 5,
              child: FittedBox(
                  fit: BoxFit.contain,
                  child: FloatingActionButton(
                    heroTag: null,
                    tooltip: "Add",
                    onPressed: () {
                      currentIngredientList = ingredients_others;
                      addIngredientItem();
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
                padding: EdgeInsets.symmetric(horizontal: 1),
                textStyle: TextStyle(fontFamily: "Outfit", fontSize: 12),
                foregroundColor: Colors.white,
                backgroundColor:
                    isSelected ? Colors.grey : appTheme.green_primary),
            onPressed: () {
              setState(() {
                if (selectedIngredients.contains(data)) {
                  // If the data is already selected, remove it
                  selectedIngredients.remove(data);
                } else {
                  if (selectedIngredients.length < 5) {
                    // If the data is not selected, add it
                    selectedIngredients.add(data);
                  }
                }
                atomInputContainerController.text =
                    selectedIngredients.join("  ");
              });
            },
            child: Text(data,
                textAlign: TextAlign.center,
                softWrap: true,
                style: TextStyle(
                  fontFamily: "Outfit",
                )),
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
    OpenAI.apiKey = azapiKey;
    final systemMessage = OpenAIChatCompletionChoiceMessageModel(
      content: "I want to provide delicious recipe for users by using their leftover ingredients. You act as a professional personal recipe-generating assistant who need to create ONE recipe using provided ingredients. " +
          " To ensure a precise and high-quality response, you should following below rules: 1. please return the response in create a JSON object which enumerates a set of 7 child objects, " +
          " Each objects are respectively named as Title, Ingredient List, Step-by-Step Instructions, Expected Cooking Time, Note, Saving Co2, and Saving Money." +
          " The result JSON objetcs should be in this format: " +
          "{Title: string, Ingredient List: list[String], Step-by-Step Instructions: list[String], Expected Cooking Time: integer, Note: String, Saving Co2: integer, Saving Money: integer}." +
          " 2. the unit of 'Expected Cooking Time' is in minutes; " +
          " 3. make your recipe be as similar to $selectedCuisine authentic known dishes as possible; " +
          " 4. 'Saving Co2' should be an estimated integer of Co2 the user saved from this meal by reducing food waste. Total CO2 emissions=∑(Amount of each food type wasted×Emission factor for that food type); " +
          " 5. 'Saving money' should be estimated integer of money the user saved from not throw those ingredients; " +
          " 6. Do not use any other ingredients that users did not pick, but you can use other pantry or spices." +
          " 7. The recipe output should be in $selectedLangauge language.",
      role: OpenAIChatMessageRole.assistant,
    );

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

      // log(resultCompletion);
      // log(contentUser);
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
        title: const Text('Add Ingredient'),
        content: TextField(
          onChanged: (value) {
            ingredientName = value;
          },
          decoration: InputDecoration(hintText: "Enter ingredient name"),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text(
              'Add',
              style: TextStyle(color: Colors.black),
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
