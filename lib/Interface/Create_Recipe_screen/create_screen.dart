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

  // // Variables to hold the selected preferences
  // String selectedCuisine = "";
  // String selectedCookingMethod = "";
  // String selectedDishType = "";
  // String selectedDietaryRestriction = "";
  // String selectedServingSize = "";

  List<String> ingredients_protein = [
    "chicken breast",
    "chicken thigh",
    "beef brisket",
    "beef tendor",
    "turkey bacon",
    "pork ribs",
    "pork belly",
    "shrimp",
    "fish fillet",
    "smocked salmon",
    "egg",
    "tofu(firmed)",
  ];
  List<String> ingredients_vege = [
    "tomato",
    "onion",
    "brocolli",
    "mushroom",
    "cabbage",
    "lettuce",
    "pepper",
    "cucumber",
    "califlower",
    "zuchinni",
    "eggplant",
  ];
  List<String> ingredients_carb = [
    "egg noodle",
    "white rice",
    "rice cake",
    "pasta",
    "potato",
    "corn",
    "sweet potato",
    "pumpkin",
    "gnocchi",
    "bread",
    "bagel",
    "baguette",
    "pie crust",
  ];

  List<String> selectedIngredients = [];
  List<String> dropdownItemList1_cuisine = [
    "No Preference",
    "Asian",
    "Italian",
    "Mexican",
    "Chinese",
    "Korean",
    "Thai",
  ];

  List<String> dropdownItemList2_cooking_ethod = [
    "No Preference",
    "Pan Fry",
    "Steam",
    "Air Fry",
    "Oven"
  ];

  List<String> dropdownItemList3_dish_type = [
    "No Preference",
    "Breakfast",
    "Lunch",
    "Dinner",
    "Dessert",
    "Quick Meal"
  ];

  List<String> dropdownItemList4_restriction = [
    "No Restriction",
    "Vegetarian",
    "Low-Carb/Keto",
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
      "Give me a Recipe following these cooking preferences: "
      "\n1. Cuisine style should be $selectedCuisine, so use some special sauce/spice. "
      "\n2. Dish type should be $selectedDishType. And the cooking method should be $selectedCookingMethod"
      "\n3. Be mindful of the user have $selectedDietaryRestriction diet restriction."
      "\n4. The serving size is $selectedServingSize";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      backgroundColor: appTheme.yellow_secondary,
      resizeToAvoidBottomInset: false,
      // appBar: MyAppBar(),
      appBar: AppBar(
        // leading: Text(
        //   'BRING YOUR OWN FRIDGE',
        //   style: TextStyle(
        //       color: Colors.black54,
        //       fontSize: 14,
        //       fontWeight: FontWeight.bold,
        //       fontFamily: "Outfit"),
        // ),
        elevation: 0,
        backgroundColor: appTheme.yellow_secondary,
        title: const Text('BRING YOUR OWN FRIDGE'),
        toolbarHeight: 80,
        // backgroundColor: Color(0xFF5A7756),
        titleTextStyle: TextStyle(
            color: Colors.black54,
            fontSize: 14,
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
                margin: EdgeInsets.only(bottom: 6.v),
                child: Stack(children: [
                  Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                          padding: EdgeInsets.only(left: 30.h, right: 30.h),
                          child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                // Container(
                                //   alignment: Alignment.topRight,
                                //   child: (_buildLanguagePicker(context)),
                                // ),

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
            // hintText: "Cuisine Style",
            hintText: dropdownItemList1_cuisine.first,
            // width: MediaQuery.of(context).size.width *
            //     0.40,

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
          left: 20.0, right: 40.0, top: 10.0, bottom: 10.0),
      child: Row(
        children: [
          const Text(
            "Language",
            style: TextStyle(fontSize: 14),
          ),
          // const Spacer(),
          SizedBox(width: 20),
          SizedBox(
            width: 100,
            child: LanguagePickerDropdown(
              initialValue: Languages.english,
              itemBuilder: ((language) => DropdownMenuItem(
                      child: Text(
                    language.name,
                    style: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
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
              labelText: 'Add your ingredients (max 5)',
              labelStyle: TextStyle(
                fontFamily: "Outfit",
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
      ],
    );
  }

  Widget _buildButtonProtein(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: ingredients_protein.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisExtent: 40.v,
          crossAxisCount: 3,
          // childAspectRatio: MediaQuery.of(context).size.width *0.2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10),
      itemBuilder: (context, index) {
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
      },
    );
  }

  Widget _buildButtonVegetable(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: ingredients_vege.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisExtent: 40.v,
          crossAxisCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10),
      itemBuilder: (context, index) {
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
      },
    );
  }

  Widget _buildButtonCarb(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: ingredients_carb.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisExtent: 40.v,
          crossAxisCount: 3,
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0),
      itemBuilder: (context, index) {
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
    // else {
    //   setState(() {
    //     selectedCuisine = 'Asian';
    //     selectedCookingMethod = 'Pan Fry';
    //     selectedDishType = 'Dinner';
    //     selectedDietaryRestriction = 'No Restriction';
    //     selectedServingSize = '2';
    //   });
    // }
  }

  // void _updateSelections() {
  //   widget.onSelectionChanged({
  //     'cuisine': selectedCuisine,
  //     'cookingMethod': selectedCookingMethod,
  //     'dishType': selectedDishType,
  //     'dietaryRestriction': selectedDietaryRestriction,
  //     'servingsize': selectedServingSize,
  //   });
  // }

  sendPrompt() async {
    OpenAI.apiKey = azapiKey;
    final systemMessage = OpenAIChatCompletionChoiceMessageModel(
      content: "As a recipe-generating assistant, create a recipe by using " +
          selectedIngredients.join() +
          " provided by the user. To ensure a precise and high-quality response, please return the response in create a JSON object which enumerates a set of 5 child objects." +
          " Each objects are respectively named as Title, Ingredient List, Step-by-Step Instructions, Expected Cooking Time, and Note." +
          " The result JSON objetcs should be in this format: " +
          "{Title: string, Ingredient List: list, Step-by-Step Instructions: list, Expected Cooking Time: integer, Note: String}." +
          " Additionally, the unit of Expected Cooking Time is minutes." +
          " Also, make your recipe can be as similar as to some known dishes. ",
      role: OpenAIChatMessageRole.assistant,
    );

    // the user message that will be sent to the request.
    final userMessage = OpenAIChatCompletionChoiceMessageModel(
      // content: "Give me a Recipe following these cooking preference: " +
      //     "\1. Cuisine style should be " +
      //     selectedCuisine +
      //     ", so use some special sauce/spice. " +
      //     "\2. Dish type should be " +
      //     selectedDishType +
      //     ". And the cooking method should be " +
      //     selectedCookingMethod +
      //     "\3. Be mindful of the user have " +
      //     selectedDietaryRestriction +
      //     " diet restriction." +
      //     "\4. The serving size is " +
      //     selectedServingSize,
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
      log(contentUser);
      // atomInputContainerController.clear();
      // selectedIngredients.clear();
    });
  }
}


// class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
//   MyAppBar({Key? key}) : super(key: key);
//   Size get preferredSize => Size.fromHeight(kToolbarHeight);
//   List<String> dropdownItemList1_cuisine = ["Asian", "Italian", "Mexican"];

//   List<String> dropdownItemList2_cooking_ethod = [
//     "No Preference",
//     "Pan Fry",
//     "Oven"
//   ];

//   List<String> dropdownItemList3_dish_type = [
//     "No Preference",
//     "Breakfast",
//     "Lunch",
//     "Dinner",
//     "Quick Meal"
//   ];

//   List<String> dropdownItemList4_restriction = [
//     "No Restriction",
//     "Vegetarian",
//     "Low-Carb/Keto"
//   ];

//   Widget build(BuildContext context) {
//     return AppBar(
//       leading: IconButton(
//         icon: const Icon(Icons.arrow_back_ios_new_rounded),
//         tooltip: 'Back to home page',
//         color: Colors.blueGrey,
//         splashColor: appTheme.orange_primary,
//         onPressed: () {
//           Navigator.of(context).pop(MaterialPageRoute(
//               builder: (context) => HomepageContainerScreen()));
//         },
//       ),
//       backgroundColor: appTheme.yellow_secondary,
//       title: const Text('BRING YOUR OWN FRIDGE'),
//       toolbarHeight: 80,
//       // backgroundColor: Color(0xFF5A7756),
//       titleTextStyle: TextStyle(
//           color: Colors.black54, fontSize: 14, fontWeight: FontWeight.bold),
//       actions: <Widget>[
//         IconButton(
//           icon: const Icon(Icons.more_horiz),
//           color: Colors.blueGrey,
//           splashColor: appTheme.orange_primary,
//           tooltip: 'More Recipe Settings',
//           onPressed: () {
//             _buildRecipeSetting(context);
//           },
//         ),
//         TextButton(
//           child: Text(
//             "Generate",
//             style:
//                 TextStyle(fontFamily: "Outfit", color: appTheme.green_primary),
//           ),
//           // style: ButtonStyle(
//           //   fixedSize: MaterialStateProperty.all<Size>(Size(80, 2)),
//           //   backgroundColor:
//           //   MaterialStateProperty.all<Color>(appTheme.orange_primary),
//           // ),
//           onPressed: () {
//             sendPrompt();
//             Navigator.of(context).push(
//                 MaterialPageRoute(builder: (context) => GenerationScreen()));
//           },
//         ),
//       ],
//     );
//   }
