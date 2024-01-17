import 'package:astridzhao_s_food_app/core/app_export.dart';
import 'package:flutter/material.dart';
import 'package:astridzhao_s_food_app/widgets/custom_drop_down.dart';

class RecipeSettingBottomSheet extends StatefulWidget {
  final Map<String, String> initialSelections;
  final Function(Map<String, String>) onSelectionChanged;

  const RecipeSettingBottomSheet({
    Key? key,
    required this.initialSelections,
    required this.onSelectionChanged,
  }) : super(key: key);

  @override
  _RecipeSettingBottomSheetState createState() =>
      _RecipeSettingBottomSheetState();
}

class _RecipeSettingBottomSheetState extends State<RecipeSettingBottomSheet> {
  late String selectedCuisine;
  late String selectedCookingMethod;
  late String selectedDishType;
  late String selectedDietaryRestriction;
  late String selectedServingSize;
  List<String> dropdownItemList1_cuisine = [
    "Asian",
    "Italian",
    "Mexican",
    "Chinese",
    "Thai",
  ];

  List<String> dropdownItemList2_cooking_ethod = [
    "No Preference",
    "Pan Fry",
    "Air Fry",
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
  @override
  void initState() {
    super.initState();
    selectedCuisine = widget.initialSelections['cuisine'] ?? '';
    selectedCookingMethod = widget.initialSelections['cookingMethod'] ?? '';
    selectedDishType = widget.initialSelections['dishType'] ?? '';
    selectedDietaryRestriction =
        widget.initialSelections['dietaryRestriction'] ?? '';
    selectedServingSize = widget.initialSelections['servingsize'] ?? '';
  }

  void _updateSelections() {
    widget.onSelectionChanged({
      'cuisine': selectedCuisine,
      'cookingMethod': selectedCookingMethod,
      'dishType': selectedDishType,
      'dietaryRestriction': selectedDietaryRestriction,
      'servingsize': selectedServingSize,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.60,
      color: appTheme.green_primary,
      child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Row(children: <Widget>[
            Text("Set My Cooking Preference",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'Outfit',
                    fontWeight: FontWeight.w600)),
            Spacer(),
            IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.arrow_drop_down_circle, color: Colors.white)),
          ]),
        ),
        CustomDropDown(
          hintText: "Cuisine Style",
          width: MediaQuery.of(context).size.width * 0.60,
          hintStyle: TextStyle(fontSize: 12, fontFamily: "Outfit"),
          items: dropdownItemList1_cuisine,
          onChanged: (value) {
            setState(() {
              selectedCuisine = value;
            });
            _updateSelections();
          },
        ),
        SizedBox(height: 24),
        CustomDropDown(
          hintText: "Cooking Method",
          width: MediaQuery.of(context).size.width * 0.60,
          hintStyle: TextStyle(fontSize: 12, fontFamily: "Outfit"),
          items: dropdownItemList2_cooking_ethod,
          onChanged: (value) {
            setState(() {
              selectedCookingMethod = value;
            });
            _updateSelections();
          },
        ),
        SizedBox(height: 24),
        CustomDropDown(
          hintText: "Dish Type",
          width: MediaQuery.of(context).size.width * 0.60,
          hintStyle: TextStyle(fontSize: 12, fontFamily: "Outfit"),
          items: dropdownItemList3_dish_type,
          onChanged: (value) {
            setState(() {
              selectedDishType = value;
            });
            _updateSelections();
          },
        ),
        SizedBox(height: 24),
        CustomDropDown(
          hintText: "Dietary Restriction",
          width: MediaQuery.of(context).size.width * 0.60,
          hintStyle: TextStyle(fontSize: 12, fontFamily: "Outfit"),
          items: dropdownItemList4_restriction,
          onChanged: (value) {
            setState(() {
              selectedDietaryRestriction = value;
            });
            _updateSelections();
          },
        ),
        SizedBox(height: 24),
        CustomDropDown(
          hintText: "Serving Size",
          width: MediaQuery.of(context).size.width * 0.60,
          hintStyle: TextStyle(fontSize: 12, fontFamily: "Outfit"),
          items: dropdownItemList5_servingsize,
          onChanged: (value) {
            setState(() {
              selectedServingSize = value;
            });
            _updateSelections();
          },
        ),
      ]),
    );
  }
}
