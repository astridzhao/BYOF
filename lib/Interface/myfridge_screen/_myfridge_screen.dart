import 'package:flutter/material.dart';
import 'carbslist_item_widget.dart';
import 'fiberlist_item_widget.dart';
import 'proteinlist_item_widget.dart';
import 'package:astridzhao_s_food_app/core/app_export.dart';

enum ItemType { fiber, protein, carbs }

class MyfridgePage extends StatefulWidget {
  const MyfridgePage({Key? key}) : super(key: key);

  @override
  MyfridgePageState createState() => MyfridgePageState();
}

// // decoration: BoxDecoration(
//           //   image: DecorationImage(
//           //     image: AssetImage(ImageConstant.fidgebackground),
//           //     fit: BoxFit.cover,
//           //   ),
//           // ),
class MyfridgePageState extends State<MyfridgePage> {
  List<String> fiberItems = ["califlower", "tomato", "mushroom", "corn"];
  List<String> proteinItems = [];
  List<String> carbsItems = [];

  void addFiberItem() async {
    String? newIngredient = await _showAddIngredientDialog(context);
    if (newIngredient != null && newIngredient.isNotEmpty) {
      // Here you should add the new ingredient to your list of items
      // For example, if you have a list called _ingredients, you would do:
      setState(() {
        fiberItems.add(newIngredient);
      });
    }
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          padding: EdgeInsets.only(top: 20),
          child: Column(
            children: [
              // buildSectionHeader(context, title: "Fiber", seeAllText: "See all"),
              SectionHeader(title: "Fiber", seeAllText: "See all"),
              SizedBox(height: 1.v),
              _buildFiberList(context),
              SizedBox(height: 17.v),

              SectionHeader(title: "Protein", seeAllText: "See all"),
              SizedBox(height: 1.v),
              _buildProteinList(context),
              SizedBox(height: 17.v),

              SectionHeader(title: "Carbs", seeAllText: "See all"),
              SizedBox(height: 1.v),
              _buildCarbsList(context),
              SizedBox(height: 17.v),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSectionHeader(BuildContext context,
      {required String title, required String seeAllText}) {
    return SectionHeader(title: title, seeAllText: seeAllText);
  }

  Widget _buildFiberList(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 200.h,
          child: GridView.builder(
            padding: EdgeInsets.symmetric(horizontal: 12.h),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4, // Number of items per row
              crossAxisSpacing: 12.h, // Horizontal space between items
              mainAxisSpacing: 12.h, // Vertical space between items
            ),
            scrollDirection: Axis.vertical,
            itemCount: fiberItems.length,
            itemBuilder: (context, index) {
              String ingredientName = fiberItems[index];
              return FiberlistItemWidget(ingredient: ingredientName);
            },
          ),
        ),
        Positioned(
          right: 16.h,
          bottom: 16.v,
          child: FloatingActionButton(
            onPressed: addFiberItem,
            child: Icon(Icons.add),
          ),
        ),
      ],
    );
  }

  /// Saving Widget
  // Widget buildFiberList(BuildContext context) {
  //   return SizedBox(
  //     height: 88.v,
  //     child: ListView.separated(
  //       padding: EdgeInsets.only(
  //         left: 24.h,
  //         right: 12.h,
  //       ),
  //       scrollDirection: Axis.horizontal,
  //       separatorBuilder: (
  //         context,
  //         index,
  //       ) {
  //         return SizedBox(
  //           width: 12.h,
  //         );
  //       },
  //       itemCount: 4,
  //       itemBuilder: (context, index) {
  //         return FiberlistItemWidget();
  //       },
  //     ),
  //   );
  // }

  /// Section Widget
  Widget _buildProteinList(BuildContext context) {
    return SizedBox(
      height: 58.v,
      child: ListView.separated(
        padding: EdgeInsets.only(
          left: 24.h,
          right: 12.h,
        ),
        scrollDirection: Axis.horizontal,
        separatorBuilder: (
          context,
          index,
        ) {
          return SizedBox(
            width: 12.h,
          );
        },
        itemCount: 4,
        itemBuilder: (context, index) {
          return ProteinlistItemWidget();
        },
      ),
    );
  }

  /// Section Widget
  Widget _buildCarbsList(BuildContext context) {
    return SizedBox(
      height: 58.v,
      child: ListView.separated(
        padding: EdgeInsets.only(
          left: 25.h,
          right: 11.h,
        ),
        scrollDirection: Axis.horizontal,
        separatorBuilder: (
          context,
          index,
        ) {
          return SizedBox(
            width: 12.h,
          );
        },
        itemCount: 4,
        itemBuilder: (context, index) {
          return CarbslistItemWidget();
        },
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final String seeAllText;

  const SectionHeader({Key? key, required this.title, required this.seeAllText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: appTheme.black900,
              fontSize: 14.fSize,
              fontFamily: 'Outfit',
              fontWeight: FontWeight.w500,
            ),
          ),
          TextButton(
            onPressed: () {},
            child: Text(
              seeAllText,
              style: TextStyle(
                color: appTheme.green_primary,
                fontSize: 12.fSize,
                fontFamily: 'Outfit',
              ),
            ),
          ),
        ],
      ),
    );
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
