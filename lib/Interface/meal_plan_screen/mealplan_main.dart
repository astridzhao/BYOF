import 'package:astridzhao_s_food_app/Interface/meal_plan_screen/mealplan_calendar.dart';
import 'package:astridzhao_s_food_app/Interface/meal_plan_screen/mealplan_customized.dart';
import 'package:astridzhao_s_food_app/theme/theme_helper.dart';
import 'package:flutter/material.dart';

class MealPlan_mainScreen extends StatefulWidget {
  const MealPlan_mainScreen({Key? key}) : super(key: key);

  @override
  _MealPlan_mainScreenState createState() => _MealPlan_mainScreenState();
}

class _MealPlan_mainScreenState extends State<MealPlan_mainScreen> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          title: Text('My Meal Plan'),
        ),
        body: SizedBox(
          width: screenWidth,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                _MealMakeButton(),
                MealPlanCalendar(),
              ],
            ),
          ),
        ));
  }

  Widget _MealMakeButton() {
    return SizedBox(
        height: MediaQuery.of(context).size.width * 0.1,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 15),
            textStyle: TextStyle(fontFamily: "Outfit", fontSize: 13),
            foregroundColor: Colors.white,
            backgroundColor: appTheme.orange_primary, // background
          ),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return MealPlan_customizedScreen();
            }));
          },
          child: Text("Make This Week Meal Plan"),
        ));
  }
}
