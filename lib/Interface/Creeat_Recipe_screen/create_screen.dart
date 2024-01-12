import 'package:astridzhao_s_food_app/core/app_export.dart';
import 'package:astridzhao_s_food_app/Interface/homepage_container_screen/homepage_container_screen.dart';
import 'package:flutter/material.dart';
import 'package:astridzhao_s_food_app/Interface/Creeat_Recipe_screen/generation_screen.dart';
import 'package:astridzhao_s_food_app/Interface/Creeat_Recipe_screen/constant.dart';
import 'package:astridzhao_s_food_app/widgets/custom_drop_down.dart';
import 'package:openai_client/openai_client.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:language_picker/language_picker.dart';
import 'package:language_picker/languages.dart';

/// Flutter code sample for [AppBar].

// ignore_for_file: must_be_immutable
class CreateScreen extends StatefulWidget {
  CreateScreen({Key? key}) : super(key: key);
  @override
  CreateScreenState createState() => CreateScreenState();
}

class CreateScreenState extends State<CreateScreen> {
  TextEditingController atomInputContainerController = TextEditingController();

  String selectedLangauge = Languages.english.name;
  String resultCompletion = "";

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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          tooltip: 'Back to home page',
          color: Colors.blueGrey,
          splashColor: appTheme.orange_primary,
          onPressed: () {
            Navigator.of(context).pop(MaterialPageRoute(
                builder: (context) => HomepageContainerScreen()));
          },
        ),
        backgroundColor: appTheme.yellow_secondary,
        title: const Text('BRING YOUR OWN FRIDGE'),
        toolbarHeight: 80,
        // backgroundColor: Color(0xFF5A7756),
        titleTextStyle: TextStyle(
            color: Colors.black54, fontSize: 14, fontWeight: FontWeight.bold),
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
            onPressed: () {
              sendPrompt();
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => GenerationScreen()));
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
          keyboardType: TextInputType.text,
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
        SizedBox(height: 5),
        _buildButtonProtein(context),
        Text("Choose My Fiber",
            textAlign: TextAlign.center,
            softWrap: true,
            style: TextStyle(
              fontFamily: "Outfit",
            )),
        SizedBox(height: 5),
        _buildButtonVegetable(context),
        Text("Choose My Fiber",
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
          mainAxisExtent: 32.v,
          crossAxisCount: 3,
          mainAxisSpacing: 2.h,
          crossAxisSpacing: 3.h),
      itemBuilder: (context, index) {
        String data = ingredients_protein[index];
        bool isSelected = selectedIngredients.contains(data);
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor:
                  isSelected ? Colors.grey : appTheme.green_primary),
          onPressed: () {
            if (selectedIngredients.contains(data)) {
              // If the data is already selected, remove it
              selectedIngredients.remove(data);
            } else {
              // If the data is not selected, add it
              selectedIngredients.add(data);
            }
            atomInputContainerController.text = selectedIngredients.join(" ");
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
          mainAxisExtent: 32.v,
          crossAxisCount: 3,
          mainAxisSpacing: 2.h,
          crossAxisSpacing: 3.h),
      itemBuilder: (context, index) {
        String data = ingredients_vege[index];
        bool isSelected = selectedIngredients.contains(data);
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor:
                  isSelected ? Colors.grey : appTheme.green_primary),
          onPressed: () {
            if (selectedIngredients.contains(data)) {
              // If the data is already selected, remove it
              selectedIngredients.remove(data);
            } else {
              // If the data is not selected, add it
              selectedIngredients.add(data);
            }
            atomInputContainerController.text = selectedIngredients.join(" ");
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
          mainAxisSpacing: 2.h,
          crossAxisSpacing: 3.h),
      itemBuilder: (context, index) {
        String data = ingredients_carb[index];
        bool isSelected = selectedIngredients.contains(data);
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor:
                  isSelected ? Colors.grey : appTheme.green_primary),
          onPressed: () {
            if (selectedIngredients.contains(data)) {
              // If the data is already selected, remove it
              selectedIngredients.remove(data);
            } else {
              // If the data is not selected, add it
              selectedIngredients.add(data);
            }
            atomInputContainerController.text = selectedIngredients.join(" ");
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
                    onChanged: (value) {}),
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
    final completion = await OpenAI.instance.completion.create(
        model: 'gpt-3.5-turbo',
        temperature: 0.7,
        maxTokens: 500,
        prompt: generatedPrompt.replaceAll(
            "INGREDIENTS", atomInputContainerController.text));

    print(completion.choices[0].text);
    // setState(() {
    //   resultCompletion = completion.choices[0].text;
    //   atomInputContainerController.clear();
    // });
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
