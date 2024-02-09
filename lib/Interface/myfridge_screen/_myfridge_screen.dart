import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'carbslist_item_widget.dart';
import 'fiberlist_item_widget.dart';
import 'proteinlist_item_widget.dart';
import 'package:astridzhao_s_food_app/core/app_export.dart';

class MyfridgePage extends StatefulWidget {
  const MyfridgePage({Key? key}) : super(key: key);

  @override
  MyfridgePageState createState() => MyfridgePageState();
}

class MyfridgePageState extends State<MyfridgePage> {
  Map<String, int> carbsItems = {};
  Map<String, int> proteinItems = {};
  Map<String, int> fiberItems = {};

  @override
  void initState() {
    super.initState();
    loadData();
  }

  // Save data as shared preferences
  // Save data as shared preferences
  saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<Map> carbsItemsList = carbsItems.entries
        .map((entry) => {'name': entry.key, 'quantity': entry.value})
        .toList();
    List<Map> proteinItemsList = proteinItems.entries
        .map((entry) => {'name': entry.key, 'quantity': entry.value})
        .toList();
    List<Map> fiberItemsList = fiberItems.entries
        .map((entry) => {'name': entry.key, 'quantity': entry.value})
        .toList();

    // Encode and save as a string
    await prefs.setString('carbsItems', jsonEncode(carbsItemsList));
    await prefs.setString('proteinItems', jsonEncode(proteinItemsList));
    await prefs.setString('fiberItems', jsonEncode(fiberItemsList));
  }

  // Load data
  loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? fiberItemsString = prefs.getString('fiberItems');
    if (fiberItemsString != null) {
      List<dynamic> decodedList = jsonDecode(fiberItemsString);
      setState(() {
        fiberItems = Map.fromIterable(decodedList,
            key: (item) => item['name'], value: (item) => item['quantity']);
      });
      log("fiber" + fiberItems.toString());
    }

    String? proteinItemsString = prefs.getString('proteinItems');
    if (proteinItemsString != null) {
      List<dynamic> decodedList = jsonDecode(proteinItemsString);
      setState(() {
        proteinItems = Map.fromIterable(decodedList,
            key: (item) => item['name'], value: (item) => item['quantity']);
      });
      log("protein" + proteinItems.toString());
    }

    String? carbsItemsString = prefs.getString('carbsItems');
    if (carbsItemsString != null) {
      // Decode the string back into a list of maps
      List<dynamic> decodedList = jsonDecode(carbsItemsString);
      setState(() {
        carbsItems = Map.fromIterable(decodedList,
            key: (item) => item['name'], value: (item) => item['quantity']);
      });
      log("carbs" + carbsItems.toString());
    }
  }

  void addFiberItem() async {
    String? newIngredient = await _showAddIngredientDialog(context);
    if (newIngredient != null && newIngredient.isNotEmpty) {
      setState(() {
        fiberItems[newIngredient] = (fiberItems[newIngredient] ?? 0) + 1;
      });
      saveData();
    }
  }

  void addProteinItem() async {
    String? newIngredient = await _showAddIngredientDialog(context);
    if (newIngredient != null && newIngredient.isNotEmpty) {
      setState(() {
        proteinItems[newIngredient] = (proteinItems[newIngredient] ?? 0) + 1;
      });
      saveData();
    }
  }

  void addCarbItem() async {
    String? newIngredient = await _showAddIngredientDialog(context);
    if (newIngredient != null && newIngredient.isNotEmpty) {
      setState(() {
        carbsItems[newIngredient] = (carbsItems[newIngredient] ?? 0) + 1;
      });
      saveData();
    }
  }

  Widget build(BuildContext context) {
    return  Scaffold(
        body: DecoratedBox(
          // BoxDecoration takes the image
          decoration: BoxDecoration(
            // Image set to background of the body
            image: DecorationImage(
                colorFilter: new ColorFilter.mode(
                    Colors.black.withOpacity(0.15), BlendMode.dstATop),
                image: AssetImage("assets/images/fridge_background.png"),
                fit: BoxFit.fill),
          ),
          child: SingleChildScrollView(
            // padding: EdgeInsets.only(top: 20),
            child: Column(
              children: [
                SizedBox(height: 10.v),
                SectionHeader(title: "Fiber"),
                SizedBox(height: 1.v),
                _buildFiberList(context),
                SizedBox(height: 17.v),
                SectionHeader(title: "Protein"),
                SizedBox(height: 1.v),
                _buildProteinList(context),
                SizedBox(height: 17.v),
                SectionHeader(title: "Carbs"),
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
          height: MediaQuery.of(context).size.height * 0.2,
          child: GridView.builder(
            padding: EdgeInsets.symmetric(horizontal: 12.h),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 6,
              crossAxisCount: 1, // Number of items per row
              crossAxisSpacing: 12.h, // Horizontal space between items
              mainAxisSpacing: 12.h, // Vertical space between items
            ),
            scrollDirection: Axis.vertical,
            itemCount: fiberItems.length,
            itemBuilder: (context, index) {
              // Accessing map keys by index requires converting keys to list
              String ingredientName = fiberItems.keys.elementAt(index);
              int ingredientQuantity = fiberItems[ingredientName] ?? 0;

              log("fridge page " +
                  ingredientName +
                  " is " +
                  ingredientQuantity.toString());
              return FiberlistItemWidget(
                ingredient: ingredientName,
                quantity: ingredientQuantity, // Pass the actual quantity
                onDelete: () => onDeleteItem(ingredientName),
                onQuantityChanged: (ingredient, newQuantity) {
                  setState(() {
                    fiberItems[ingredient] = newQuantity; // Update the quantity
                  });
                  log("fridge page fiber (after updated)" +
                      newQuantity.toString());
                  saveData(); // Save the updated map
                },
              );
            },
          ),
        ),
        Positioned(
          right: 16.h,
          bottom: 16.v,
          child: FloatingActionButton(
            heroTag: null,
            onPressed: addFiberItem,
            child: Icon(Icons.add),
          ),
        ),
      ],
    );
  }

  Widget _buildProteinList(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.2,
          child: GridView.builder(
            padding: EdgeInsets.symmetric(horizontal: 12.h),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 6,
              crossAxisCount: 1, // Number of items per row
              crossAxisSpacing: 12.h, // Horizontal space between items
              mainAxisSpacing: 12.h, // Vertical space between items
            ),
            scrollDirection: Axis.vertical,
            itemCount: proteinItems.length,
            itemBuilder: (context, index) {
              String ingredientName = proteinItems.keys.elementAt(index);
              int quantity = proteinItems[ingredientName] ?? 0;
              return ProteinlistItemWidget(
                ingredient: ingredientName,
                quantity: quantity, // Pass the actual quantity
                onDelete: () => onDeleteItem(ingredientName),
                onQuantityChanged: (ingredient, newQuantity) {
                  setState(() {
                    proteinItems[ingredient] =
                        newQuantity; // Update the quantity
                  });
                  log("fridge page protein" + newQuantity.toString());
                  saveData(); // Save the updated map
                },
              );
            },
          ),
        ),
        Positioned(
          right: 16.h,
          bottom: 16.v,
          child: FloatingActionButton(
            heroTag: null,
            onPressed: addProteinItem,
            child: Icon(Icons.add),
          ),
        ),
      ],
    );
  }

  Widget _buildCarbsList(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.2,
          child: GridView.builder(
            padding: EdgeInsets.symmetric(horizontal: 12.h),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 6,
              crossAxisCount: 1, // Number of items per row
              crossAxisSpacing: 12.h, // Horizontal space between items
              mainAxisSpacing: 12.h, // Vertical space between items
            ),
            scrollDirection: Axis.vertical,
            itemCount: carbsItems.length,
            itemBuilder: (context, index) {
              //get the ingredient name and quantity
              String ingredientName = carbsItems.keys.elementAt(index);
              int quantity = carbsItems[ingredientName] ?? 0;
              return CarblistItemWidget(
                ingredient: ingredientName,
                quantity: quantity, // Pass the actual quantity
                onDelete: () => onDeleteItem(ingredientName),
                onQuantityChanged: (ingredient, newQuantity) {
                  setState(() {
                    carbsItems[ingredient] = newQuantity; // Update the quantity
                  });
                  log("fridge page carbs" + newQuantity.toString());
                  saveData(); // Save the updated map
                },
              );
            },
          ),
        ),
        Positioned(
          right: 16.h,
          bottom: 16.v,
          child: FloatingActionButton(
            heroTag: null,
            onPressed: addCarbItem,
            child: Icon(Icons.add),
          ),
        ),
      ],
    );
  }

  void onDeleteItem(String ingredientName) {
    setState(() {
      // Remove the item from the map
      carbsItems.remove(ingredientName);
      fiberItems.remove(ingredientName);
      proteinItems.remove(ingredientName);
    });

    // Save the updated map to SharedPreferences
    saveData();
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final String seeAllText;

  const SectionHeader({Key? key, required this.title, this.seeAllText = ""})
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


//class FridgeItem {
//   String name;
//   int quantity;

//   FridgeItem({required this.name, required this.quantity});

//   // Convert a FridgeItem into a Map. The keys must correspond to the names of the
//   // JSON attributes in the Flutter app.
//   Map<String, dynamic> toJson() => {
//         'name': name,
//         'quantity': quantity,
//       };

//   // A method to create a FridgeItem from a map.
//   factory FridgeItem.fromJson(Map<String, dynamic> json) => FridgeItem(
//         name: json['name'],
//         quantity: json['quantity'],
//       );
// }

// Future<void> saveData() async {
//   final prefs = await SharedPreferences.getInstance();

//   // Example for fiber items. You can replicate for protein and carbs.
//   List<Map<String, dynamic>> fiberItemsToJson = fiberItems.map((item) => item.toJson()).toList();
//   String encodedFiberItems = jsonEncode(fiberItemsToJson);
//   await prefs.setString('fiberItems', encodedFiberItems);

//   // Repeat similar steps for proteinItems and carbsItems...
// }

// Future<void> loadData() async {
//   final prefs = await SharedPreferences.getInstance();

//   // Example for fiber items. You can replicate for protein and carbs.
//   String? encodedFiberItems = prefs.getString('fiberItems');
//   if (encodedFiberItems != null) {
//     List<dynamic> decodedFiberItems = jsonDecode(encodedFiberItems);
//     List<FridgeItem> fiberItems = decodedFiberItems.map((itemJson) => FridgeItem.fromJson(itemJson)).toList();

//     setState(() {
//       this.fiberItems = fiberItems;
//     });
//   }

  // Repeat similar steps for proteinItems and carbsItems...
// }

