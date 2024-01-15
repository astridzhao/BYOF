import 'package:astridzhao_s_food_app/core/app_export.dart';
import 'package:flutter/material.dart';
import 'package:astridzhao_s_food_app/Interface/Create_Recipe_screen/generation_screen.dart';
import 'package:astridzhao_s_food_app/Interface/Create_Recipe_screen/constant.dart';
import 'package:astridzhao_s_food_app/widgets/custom_drop_down.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
// import 'package:openai_client/openai_client.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:language_picker/language_picker.dart';
import 'package:language_picker/languages.dart';

/// Flutter code sample for [AppBar].

// ignore_for_file: must_be_immutable
class CreateScreen extends StatefulWidget {
  CreateScreen({
    Key? key,
  }) : super(key: key);

  @override
  CreateScreenState createState() => CreateScreenState();
}

class CreateScreenState extends State<CreateScreen> {
  TextEditingController atomInputContainerController = TextEditingController();
  late SingleValueDropDownController cuisineController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  void initState() {
    cuisineController = SingleValueDropDownController();
    super.initState();
  }

  @override
  void dispose() {
    cuisineController.dispose();
    super.dispose();
  }

  String selectedLangauge = Languages.english.name;
  String resultCompletion = "";

  // Variables to hold the selected preferences
  String selectedCuisine = "";
  String selectedCookingMethod = "";
  String selectedDishType = "";
  String selectedDietaryRestriction = "";

  List<String> dropdownItemList1_cuisine = ["Asian", "Italian", "Mexican"];

  List<String> dropdownItemList2_cooking_ethod = [
    "No Preference",
    "Pan Fry",
    "Oven"
  ];

  List<String> dropdownItemList3_dish_type = [
    "No Preference",
    "Breakfast",
    "Lunch",
    "Dinner",
    "Quick Meal"
  ];

  List<String> dropdownItemList4_restriction = [
    "No Restriction",
    "Vegetarian",
    "Low-Carb/Keto"
  ];

  List<String> ingredients_protein = [
    "chicken",
    "beef",
    "bacon",
    "turkey",
  ];
  List<String> ingredients_vege = ["tomato", "onion", "brocolli"];
  List<String> ingredients_carb = ["egg noodle", "white rice", "gnocchi"];
  List<String> selectedIngredients = [];

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
          IconButton(
            icon: const Icon(Icons.more_horiz),
            color: Colors.blueGrey,
            splashColor: appTheme.orange_primary,
            tooltip: 'More Recipe Settings',
            onPressed: () {
              _buildRecipeSetting(context);
            },
          ),
          TextButton(
            child: Text(
              "Generate",
              style: TextStyle(
                  fontFamily: "Outfit", color: appTheme.green_primary),
            ),
            // style: ButtonStyle(
            //   fixedSize: MaterialStateProperty.all<Size>(Size(80, 2)),
            //   backgroundColor:
            //   MaterialStateProperty.all<Color>(appTheme.orange_primary),
            // ),
            onPressed: () async {
              await sendPrompt();
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      GenerationScreen(resultCompletion: resultCompletion)));
            },
          ),
        ],
      ),
      body: Stack(children: [
        Container(
          alignment: Alignment.topLeft,
          child: (_buildLanguagePicker(context)),
        ),
        SingleChildScrollView(
            child: Container(
                height: 1108.v,
                width: double.maxFinite,
                margin: EdgeInsets.only(bottom: 6.v),
                child: Stack(alignment: Alignment.bottomCenter, children: [
                  Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                          padding: EdgeInsets.only(left: 30.h, right: 30.h),
                          child:
                              Column(mainAxisSize: MainAxisSize.min, children: [
                            SizedBox(height: 40.v),
                            _buildIngredientInputSection(context),

                            // SizedBox(height: 40.v),
                            // _buildCreateTwoGridSection(context),
                          ]))),
                ]))),
      ]),
    ));
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
          mainAxisSpacing: 10,
          crossAxisSpacing: 10),
      itemBuilder: (context, index) {
        String data = ingredients_protein[index];
        bool isSelected = selectedIngredients.contains(data);
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
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
              atomInputContainerController.text = selectedIngredients.join(" ");
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
              atomInputContainerController.text = selectedIngredients.join(" ");
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
              atomInputContainerController.text = selectedIngredients.join(" ");
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

  void _buildRecipeSetting(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.60,
              color: appTheme.green_primary,
              child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 16.0), // Adjust the value as needed
                  child: Row(children: <Widget>[
                    Text("Set My Cooking Preference",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.fSize,
                            fontFamily: 'Outfit',
                            fontWeight: FontWeight.w600)),
                    Spacer(),
                    IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: Icon(Icons.arrow_drop_down_circle,
                            color: Colors.white)),
                  ]),
                ),
                SizedBox(height: 24.v),
                CustomDropDown(
                    width: MediaQuery.of(context).size.width * 0.60,
                    hintText: "Cuisine Style",
                    hintStyle:
                        TextStyle(fontSize: 12.fSize, fontFamily: "Outfit"),
                    items: dropdownItemList1_cuisine,
                    onChanged: (value) {
                      setState(() {
                        selectedCuisine = value;
                      });
                    }),
                SizedBox(height: 24.v),
                CustomDropDown(
                    hintText: "Cooking Method",
                    hintStyle:
                        TextStyle(fontSize: 12.fSize, fontFamily: "Outfit"),
                    width: MediaQuery.of(context).size.width * 0.60,
                    items: dropdownItemList2_cooking_ethod,
                    onChanged: (value) {}),
                SizedBox(height: 24.v),
                CustomDropDown(
                    hintText: "Dish Type",
                    width: MediaQuery.of(context).size.width * 0.60,
                    hintStyle:
                        TextStyle(fontSize: 12.fSize, fontFamily: "Outfit"),
                    items: dropdownItemList3_dish_type,
                    onChanged: (value) {}),
                SizedBox(height: 24.v),
                CustomDropDown(
                    hintText: "Dietary Restriction",
                    width: MediaQuery.of(context).size.width * 0.60,
                    hintStyle:
                        TextStyle(fontSize: 12.fSize, fontFamily: "Outfit"),
                    items: dropdownItemList4_restriction,
                    onChanged: (value) {}),
                SizedBox(height: 24.v)
              ]),
            ),
          );
        });
  }

  sendPrompt() async {
    OpenAI.apiKey = apiKey;
    final systemMessage = OpenAIChatCompletionChoiceMessageModel(
      content: "As a recipe-generating assistant, create a recipe by using " +
          selectedIngredients.join() +
          " provided by the user. To ensure a precise and high-quality response, please follow these guidelines:\1. The response should include 5 sections: Title, Ingredient List, Step-by-Step Instructions, Expected Cooking Time, and Note. Limit your response to 150-200 words. \2. Return any message you are given as JSON.",
      role: OpenAIChatMessageRole.assistant,
    );

    // the user message that will be sent to the request.
    final userMessage = OpenAIChatCompletionChoiceMessageModel(
      content: "Give me a Asian Style Recipe",
      role: OpenAIChatMessageRole.user,
    );

    // all messages to be sent.
    final requestMessages = [
      systemMessage,
      userMessage,
    ];
    final completion = await OpenAI.instance.chat
        .create(model: 'gpt-3.5-turbo', messages: requestMessages);
    print(completion);
    setState(() {
      resultCompletion = completion.choices.first.message.content;
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

//   void _buildRecipeSetting(BuildContext context) {
//     showModalBottomSheet(
//         context: context,
//         builder: (BuildContext bc) {
//           return Container(
//             child: Container(
//               height: MediaQuery.of(context).size.height * 0.60,
//               color: appTheme.green_primary,
//               child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
//                 Padding(
//                   padding: EdgeInsets.symmetric(
//                       horizontal: 16.0,
//                       vertical: 16.0), // Adjust the value as needed
//                   child: Row(children: <Widget>[
//                     Text("Set My Cooking Preference",
//                         style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 16.fSize,
//                             fontFamily: 'Outfit',
//                             fontWeight: FontWeight.w600)),
//                     Spacer(),
//                     IconButton(
//                         onPressed: () {
//                           Navigator.of(context).pop();
//                         },
//                         icon: Icon(Icons.arrow_drop_down_circle,
//                             color: Colors.white)),
//                   ]),
//                 ),
//                 SizedBox(height: 24.v),
//                 CustomDropDown(
//                     width: MediaQuery.of(context).size.width * 0.60,
//                     hintText: "Cuisine Style",
//                     hintStyle:
//                         TextStyle(fontSize: 12.fSize, fontFamily: "Outfit"),
//                     items: dropdownItemList1_cuisine,
//                     onChanged: (value) {}),
//                 SizedBox(height: 24.v),
//                 CustomDropDown(
//                     hintText: "Cooking Method",
//                     hintStyle:
//                         TextStyle(fontSize: 12.fSize, fontFamily: "Outfit"),
//                     width: MediaQuery.of(context).size.width * 0.60,
//                     items: dropdownItemList2_cooking_ethod,
//                     onChanged: (value) {}),
//                 SizedBox(height: 24.v),
//                 CustomDropDown(
//                     hintText: "Dish Type",
//                     width: MediaQuery.of(context).size.width * 0.60,
//                     hintStyle:
//                         TextStyle(fontSize: 12.fSize, fontFamily: "Outfit"),
//                     items: dropdownItemList3_dish_type,
//                     onChanged: (value) {}),
//                 SizedBox(height: 24.v),
//                 CustomDropDown(
//                     hintText: "Dietary Restriction",
//                     width: MediaQuery.of(context).size.width * 0.60,
//                     hintStyle:
//                         TextStyle(fontSize: 12.fSize, fontFamily: "Outfit"),
//                     items: dropdownItemList4_restriction,
//                     onChanged: (value) {}),
//                 SizedBox(height: 24.v)
//               ]),
//             ),
//           );
//         });
//   }
// }
