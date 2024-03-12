import 'dart:convert';

import 'package:astridzhao_s_food_app/Interface/meal_plan_screen/mealplan_calendar.dart';
import 'package:astridzhao_s_food_app/core/utils/size_utils.dart';
import 'package:astridzhao_s_food_app/resources/firebasestore.dart';
import 'package:astridzhao_s_food_app/theme/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:dart_openai/dart_openai.dart';

import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_drop_down.dart';

class MealPlan_customizedScreen extends StatefulWidget {
  const MealPlan_customizedScreen({Key? key}) : super(key: key);

  @override
  MealPlan_customizedScreenState createState() =>
      MealPlan_customizedScreenState();
}

class MealPlan_customizedScreenState extends State<MealPlan_customizedScreen> {
  String resultCompletion = "";
  late Function(Map<String, String>) onSelectionChanged;

// constant candidate values

  List<String> dropdownItemList_eatingStyle = [
    "No Preferences",
    "Keto",
    "Paleo",
    "Vegan",
    "Vegetarian",
    "Mediterranean",
    "No Cook During the Week",
  ];

  List<String> dropdownItemList_calorie = [
    "No Preferences",
    "300-400",
    "400-500",
    "500-600",
    "600-700",
  ];

//selection value
  String selected_calRestriction = "400-500";
  String selected_eatingStyle = "";
  List<String> selectedIngredients = [];
  late List<bool> selected_breakfast;

  late List<bool> selected_lunch;
  late List<bool> selected_dinner;

  late int breakfast_days;
  late int lunch_days;
  late int dinner_days;

  String get contentUser =>
      "I will eat $breakfast_days breakfast, $lunch_days lunch, and  $dinner_days dinner at home this week." +
      "I want to eat ingredients which are denoted by backticks: ```$selectedIngredients```, please include these in my meal plan." +
      "My eating style is $selected_eatingStyle, and for each meal, limited the calorie in $selected_calRestriction, breakfast can be lower. ";

  String get system_prompt =>
      "Create a personalized meal planning tool that allows users to customize the number of breakfasts, lunches, and dinners they need, with a specified calorie restriction for each meal. The output should provide users with a general weekly meal plan. Consider the following guidelines for creating the plan:" +
      "1. User will provide number of breakfasts, lunches, and dinners they require." +
      "2. Ensure that the total calories for each meal do not exceed the specified limits." +
      "3. Beside meal plan, also provide a grocery list." +
      "4. Default serving size is 1 adult. " +
      "5. Present the meal plan in a clear and organized format, showing the meal options along with their respective calorie counts." +
      "6. Consider including nutritional information for each meal, such as protein, carbohydrates, and fats.";

  bool monBreakfastVal = true;
  bool tuBreakfastVal = true;
  bool wedBreakfastVal = true;
  bool thurBreakfastVal = true;
  bool friBreakfastVal = true;
  bool satBreakfastVal = true;
  bool sunBreakfastVal = true;

  bool monLunchVal = true;
  bool tuLunchVal = true;
  bool wedLunchVal = true;
  bool thurLunchVal = true;
  bool friLunchVal = true;
  bool satLunchVal = true;
  bool sunLunchVal = true;

  bool monDinnerVal = true;
  bool tuDinnerVal = true;
  bool wedDinnerVal = true;
  bool thurDinnerVal = true;
  bool friDinnerVal = true;
  bool satDinnerVal = true;
  bool sunDinnerVal = true;

  Widget checkbox_breakfast(String title, bool boolValue) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(title,
            style: TextStyle(color: Colors.white, fontFamily: "Outfit")),
        Checkbox(
          value: boolValue,
          onChanged: (bool? value) {
            /// manage the state of each value
            setState(() {
              switch (title) {
                case "Mon":
                  monBreakfastVal = value!;
                  break;
                case "Tu":
                  tuBreakfastVal = value!;
                  break;
                case "Wed":
                  wedBreakfastVal = value!;
                  break;
                case "Thur":
                  thurBreakfastVal = value!;
                  break;
                case "Fri":
                  friBreakfastVal = value!;
                  break;
                case "Sat":
                  satBreakfastVal = value!;
                  break;
                case "Sun":
                  sunBreakfastVal = value!;
                  break;
              }
            });
          },
        ),
      ],
    );
  }

  Widget checkbox_lunch(String title, bool boolValue) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(title,
            style: TextStyle(color: Colors.white, fontFamily: "Outfit")),
        Checkbox(
          value: boolValue,
          onChanged: (bool? value) {
            /// manage the state of each value
            setState(() {
              switch (title) {
                case "Mon":
                  monLunchVal = value!;
                  break;
                case "Tu":
                  tuLunchVal = value!;
                  break;
                case "Wed":
                  wedLunchVal = value!;
                  break;
                case "Thur":
                  thurLunchVal = value!;
                  break;
                case "Fri":
                  friLunchVal = value!;
                  break;
                case "Sat":
                  satLunchVal = value!;
                  break;
                case "Sun":
                  sunLunchVal = value!;
                  break;
              }
            });
          },
        ),
      ],
    );
  }

  Widget checkbox_dinner(String title, bool boolValue) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(title,
            style: TextStyle(color: Colors.white, fontFamily: "Outfit")),
        Checkbox(
          value: boolValue,
          onChanged: (bool? value) {
            /// manage the state of each value
            setState(() {
              switch (title) {
                case "Mon":
                  monDinnerVal = value!;
                  break;
                case "Tu":
                  tuDinnerVal = value!;
                  break;
                case "Wed":
                  wedDinnerVal = value!;
                  break;
                case "Thur":
                  thurDinnerVal = value!;
                  break;
                case "Fri":
                  friDinnerVal = value!;
                  break;
                case "Sat":
                  satDinnerVal = value!;
                  break;
                case "Sun":
                  sunDinnerVal = value!;
                  break;
              }
            });
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
// screen size setting:
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    final daysAmountChooseWidget =
        containers(context, daysAmountChoose(context));
    final calRestrictionChooseWidget =
        containers(context, calRestrictionChoose(context));
    final mealTypeChooseWidget = containers(context, mealTypeChoose(context));
    return SafeArea(
      child: Scaffold(
        // backgroundColor: appTheme.yellow5001,
        resizeToAvoidBottomInset: false,
        appBar: _appbar(),
        body: ScrollConfiguration(
          behavior: ScrollBehavior(),
          child: SingleChildScrollView(
              child: Column(children: <Widget>[
            Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                height: screenHeight * 0.46,
                child: daysAmountChooseWidget),
            Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                height: screenHeight * 0.15,
                child: calRestrictionChooseWidget),
            Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                height: screenHeight * 0.15,
                child: mealTypeChooseWidget),
          ])),
        ),
      ),
    );
  }

// generation button:
  Widget _generateButton() {
    return TextButton(
        child: Text(
          "Make Plan",
          style: TextStyle(
              fontSize: 15.fSize,
              fontFamily: "Outfit",
              color: appTheme.green_primary),
        ),
        onPressed: () async {
          // add boolean selected eating days
          selected_breakfast = [
            monBreakfastVal,
            tuBreakfastVal,
            wedBreakfastVal,
            thurBreakfastVal,
            friBreakfastVal,
            satBreakfastVal,
            sunBreakfastVal
          ];
          breakfast_days =
              selected_breakfast.where((item) => item == true).length;
          print("days eat breakfast $breakfast_days");

          selected_lunch = [
            monLunchVal,
            tuLunchVal,
            wedLunchVal,
            thurLunchVal,
            friLunchVal,
            satLunchVal,
            sunLunchVal
          ];
          lunch_days = selected_lunch.where((item) => item == true).length;
          print("days eat lunch $lunch_days");

          selected_dinner = [
            monDinnerVal,
            tuDinnerVal,
            wedDinnerVal,
            thurDinnerVal,
            friDinnerVal,
            satDinnerVal,
            sunDinnerVal
          ];
          dinner_days = selected_dinner.where((item) => item == true).length;
          print("days eat dinner $dinner_days");

          await sendPrompt();

          print(resultCompletion);
        });
  }

  CustomAppBar _appbar() {
    return CustomAppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: appTheme.green_primary),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      toolbarHeight: MediaQuery.of(context).size.height * 0.1,
      backgroundColor: Colors.transparent,
      actions: <Widget>[
        _generateButton(),
      ],
    );
  }

  Widget containers(BuildContext context, Widget questions) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 20.v),
      decoration: BoxDecoration(
        color: appTheme.gray700,
        borderRadius: BorderRadius.circular(
          20.h,
        ),
      ),
      child: Container(child: questions),
    );
  }

  Widget daysAmountChoose(BuildContext context) {
    return SizedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //title
          Text(
            "Estimated MEALS you will eat at home?",
            style: TextStyle(
                color: Colors.white, fontSize: 14.fSize, fontFamily: "Outfit"),
          ),
          SizedBox(height: 20.v),

          //breakfast Session
          breakfast_block(context),

          //lunch Session
          lunch_block(context),

          //dinner Session
          dinner_block(context),
        ],
      ),
    );
  }

  Widget breakfast_block(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Text(
            "Breakfast",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w500, fontSize: 16),
          ),
          SizedBox(height: 10),
          //breakfast checkbox
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              checkbox_breakfast("Mon", monBreakfastVal),
              checkbox_breakfast("Tu", tuBreakfastVal),
              checkbox_breakfast("Wed", wedBreakfastVal),
              checkbox_breakfast("Thur", thurBreakfastVal),
              checkbox_breakfast("Fri", friBreakfastVal),
              checkbox_breakfast("Sat", satBreakfastVal),
              checkbox_breakfast("Sun", sunBreakfastVal),
            ],
          ),
          SizedBox(height: 15.v),
        ],
      ),
    );
  }

  Widget lunch_block(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Text(
            "Lunch",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w500, fontSize: 16),
          ),
          SizedBox(height: 10),
          //breakfast checkbox
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              checkbox_lunch("Mon", monBreakfastVal),
              checkbox_lunch("Tu", tuBreakfastVal),
              checkbox_lunch("Wed", wedBreakfastVal),
              checkbox_lunch("Thur", thurBreakfastVal),
              checkbox_lunch("Fri", friBreakfastVal),
              checkbox_lunch("Sat", satBreakfastVal),
              checkbox_lunch("Sun", sunBreakfastVal),
            ],
          ),
          SizedBox(height: 15.v),
        ],
      ),
    );
  }

  Widget dinner_block(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Text(
            "Dinner",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w500, fontSize: 16),
          ),
          SizedBox(height: 10),
          //breakfast checkbox
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              checkbox_dinner("Mon", monDinnerVal),
              checkbox_dinner("Tu", tuDinnerVal),
              checkbox_dinner("Wed", wedDinnerVal),
              checkbox_dinner("Thur", thurDinnerVal),
              checkbox_dinner("Fri", friDinnerVal),
              checkbox_dinner("Sat", satDinnerVal),
              checkbox_dinner("Sun", sunDinnerVal),
            ],
          ),
          SizedBox(height: 15.v),
        ],
      ),
    );
  }

  Widget calRestrictionChoose(BuildContext context) {
    return SizedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Do you have Calorie Restriction for Each Meal?",
            style: TextStyle(
                color: Colors.white, fontSize: 14.fSize, fontFamily: "Outfit"),
          ),
          SizedBox(height: 10.v),
          CustomDropDown(
            hintText: dropdownItemList_calorie.first,
            // initialValue: selectedCuisine,
            // width: MediaQuery.of(context).size.width * 0.60,
            hintStyle: TextStyle(fontSize: 12, fontFamily: "Outfit"),
            items: dropdownItemList_calorie,
            onChanged: (value) {
              setState(() {
                selected_calRestriction = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget mealTypeChoose(BuildContext context) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "What's your eating style?",
            style: TextStyle(
                color: Colors.white, fontSize: 14.fSize, fontFamily: "Outfit"),
          ),
          SizedBox(height: 10.v),
          CustomDropDown(
            hintText: dropdownItemList_eatingStyle.first,
            // width: MediaQuery.of(context).size.width * 0.60,
            hintStyle: TextStyle(fontSize: 12, fontFamily: "Outfit"),
            items: dropdownItemList_eatingStyle,
            onChanged: (value) {
              setState(() {
                selected_eatingStyle = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Future<void> sendPrompt() async {
    OpenAI.apiKey = "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";
    // the system message that will be sent to the request.
    final systemMessage = OpenAIChatCompletionChoiceMessageModel(
      content: system_prompt,
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

    print(requestMessages);

    // // Start using!
    final chatCompletion = await OpenAI.instance.chat.create(
      model: "gpt-3.5-turbo",
      messages: requestMessages,
    );

    // Printing the output to the console
    print(chatCompletion.choices.first.message);

    setState(() {
      resultCompletion = chatCompletion.choices.first.message.content;
    });
  }
}
