/// Still WIP favorite screen.
import 'dart:core';
import 'dart:io';
import 'dart:math' as math;
import 'package:astridzhao_s_food_app/database/recipesFormatConversion.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:astridzhao_s_food_app/core/app_export.dart';
import 'package:astridzhao_s_food_app/database/database.dart';
import 'package:astridzhao_s_food_app/database/recipes_dao.dart';
import 'package:astridzhao_s_food_app/key/api_key.dart';
import 'package:astridzhao_s_food_app/Interface/Create_Recipe_screen/generation_screen.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:developer';

class FavoriteRecipePage extends StatefulWidget {
  const FavoriteRecipePage({Key? key}) : super(key: key);

  @override
  State<FavoriteRecipePage> createState() => FavoriteRecipePageState();
}

class FavoriteRecipePageState extends State<FavoriteRecipePage> {
  Future<List<Recipe>>? futureRecipes;
  final recipe_dao = RecipesDao(DatabaseService().database);

  Map<int, String?> generatedImageUrls = {};
  String currentUrls_fordisplay = "";

  @override
  void initState() {
    super.initState();
    fetchAllFavorite();
  }

  void fetchAllFavorite() {
    setState(() {
      futureRecipes = recipe_dao.select(recipe_dao.recipes).get();
    });
  }

  Future<void> generateImage(int i, int id, String recipe) async {
    try {
      OpenAI.apiKey = azapiKey;
      final image = await OpenAI.instance.image.create(
        n: 1,
        prompt: "You act as a professional image-generating assistant. By referencing the recipe title $recipe, use your imagination to create a related dish image can put on my restaurant menu. " +
            "The image style should be cute and cartoon, and make it looks tasty to attract customers. " +
            "Do not put any text on the image. ",
      );

      for (int index = 0; index < image.data.length; index++) {
        final currentItem = image.data[index];
        currentUrls_fordisplay = currentItem.url.toString();
        // save image to local --> set generateImageURLS[i]
        var response = await http.get(Uri.parse(currentUrls_fordisplay));
        Directory documentdirectory = await getApplicationDocumentsDirectory();
        String imageName = path.basename(currentUrls_fordisplay);
        File file = new File(path.join(documentdirectory.path, imageName));
        await file.writeAsBytes(response.bodyBytes);
        // print("local directory: " + documentdirectory.path);
        // store image into local directory
        await (recipe_dao.update(recipe_dao.recipes)..where((tbl) => tbl.id.equals(id)))
          ..write(RecipesCompanion(imageURL: drift.Value(imageName)));

        setState(() {
          generatedImageUrls[i] = imageName;
        });
      }
    } catch (e) {
      log('Error in generateImage: $e');
      // Handle the error or show a message to the user
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        // backgroundColor: appTheme.yellow_secondary,
        title: const Text('My Favorites'),
        toolbarHeight: 80,
        titleTextStyle: TextStyle(
            color: Colors.black54,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: "Outfit"),
      ),
      body: FutureBuilder(
          future: futureRecipes,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              // Handling for data state
              final recipes = snapshot.data! as List<Recipe>;

              return recipes.isEmpty
                  ? const Center(
                      child: Text(
                        "No favorites..",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                        ),
                      ),
                    )
                  : GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 5,
                        crossAxisCount: 1, // Number of items per row
                        crossAxisSpacing: 10, // Horizontal space between items
                        mainAxisSpacing: 20, // Vertical space between items
                      ),
                      itemBuilder: (context, i) {
                        // each recipe
                        final recipe = recipes[i];
                        //get the image name saved in the folder
                        generatedImageUrls[i] =
                            recipe.imageURL != null ? recipe.imageURL : null;
//Testing:
                        // log("recipe title: " +
                        //     recipe.title +
                        //     " file path name:" +
                        //     generatedImageUrls[i].toString());

                        // Get a list of local image paths
                        final List<String> localImages = [
                          'assets/images/generate1.png',
                          'assets/images/generate2.png',
                          "assets/images/img_image_23.png"
                        ];
                        // Randomly pick an index from your collection of local images
                        final random = math.Random();
                        final randomImageIndex =
                            random.nextInt(localImages.length);
                        final randomImagePath = localImages[randomImageIndex];

                        return ListTile(
                          // contentPadding: EdgeInsets.symmetric(horizontal: 5),
                          title: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              //Check if the URL is not empty and the list is not empty
                              (generatedImageUrls[i] != null &&
                                      generatedImageUrls.isNotEmpty)
                                  ? FutureBuilder(
                                      future: getFile(generatedImageUrls[i]!),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<File> snapshot) {
                                        // Check if the future is complete
                                        if (snapshot.connectionState ==
                                            ConnectionState.done) {
                                          //Testing:
                                          // print(snapshot.data!);
                                          // Check if the snapshot has data and the file exists
                                          if (snapshot.hasData &&
                                              snapshot.data!.existsSync()) {
                                            return ClipOval(
                                              child: Image.file(
                                                snapshot.data!,
                                                width: 80,
                                                height: 80,
                                                fit: BoxFit.cover,
                                              ),
                                            );
                                          } else {
                                            // If file does not exist or there is no data, show the asset image
                                            return ClipOval(
                                              child: Image.asset(
                                                randomImagePath,
                                                width: 80,
                                                height: 80,
                                                fit: BoxFit.cover,
                                              ),
                                            );
                                          }
                                        } else {
                                          // If the future is not yet complete, show a loading indicator or placeholder
                                          return CircularProgressIndicator();
                                        }
                                      },
                                    )
                                  : ClipOval(
                                      child: Image.asset(
                                        randomImagePath,
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                      ),
                                    ),

                              SizedBox(width: 5),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          recipe.title,
                                          maxLines: 2,
                                          // softWrap: true,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: "Outfit",
                                            color: appTheme.green_primary,
                                            fontSize: 12,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Row(
                                          children: [
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: appTheme
                                                    .green_primary, // Set the button color to red
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 15),
                                              ),
                                              onPressed: () {
                                                // view complete recipe
                                              },
                                              child: Text(
                                                "View",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: "Outfit",
                                                  fontSize: 10,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 15),
                                            // remove button
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: appTheme
                                                    .orange_primary, // Set the button color to red
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 15),
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  (recipe_dao.delete(
                                                          recipe_dao.recipes)
                                                        ..where((tbl) => tbl.id
                                                            .equals(
                                                                recipes[i].id)))
                                                      .go();
                                                  recipes.removeAt(i);
                                                });
                                              },
                                              child: Text(
                                                "Remove",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: "Outfit",
                                                  fontSize: 10,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 15),

                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 15)),
                                              child: Text(
                                                "what it looks like?",
                                                style: TextStyle(
                                                    color:
                                                        appTheme.green_primary,
                                                    fontFamily: "Outfit",
                                                    fontSize: 10),
                                              ),
                                              // if the user already generated a image once, disable the button
                                              onPressed: generatedImageUrls[i]!
                                                      .isEmpty
                                                  ? () async {
                                                      showDialog(
                                                        context: context,
                                                        barrierDismissible:
                                                            false, // User must tap button to close dialog
                                                        builder: (BuildContext
                                                            context) {
                                                          return AlertDialog(
                                                            content: Row(
                                                              children: [
                                                                SizedBox(
                                                                  width: 20,
                                                                  height:
                                                                      20, // Adjust the height as needed
                                                                  child:
                                                                      CircularProgressIndicator(),
                                                                ),
                                                                SizedBox(
                                                                    width: 20),
                                                                Text(
                                                                    "Crafting a delightful dish image..."),
                                                              ],
                                                            ),
                                                          );
                                                        },
                                                      );

                                                      await generateImage(
                                                          i,
                                                          recipe.id,
                                                          recipe.title
                                                              .toString());

                                                      // pop alert waiting box
                                                      Navigator.of(context)
                                                          .pop();

                                                      // show image box
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                                context) =>
                                                            popupDialogImage(
                                                                context),
                                                      );
                                                    }
                                                  : null,
                                            )
                                          ],
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          // subtitle: Text(subtitle),
                        );
                      },
                      itemCount: recipes.length);
            }
          }),
      // floatingActionButton: FloatingActionButton(
      //   child: const Icon(Icons.add),
      //   onPressed: () {},
      // ),
    );
  }

  Future<File> getFile(String imageName) async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    return File(path.join(documentDirectory.path, imageName));
  }

  Widget popupDialogImage(BuildContext context) {
    return new AlertDialog(
      // title: const Text('Your dish looks like...'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.network(currentUrls_fordisplay),
        ],
      ),
      actions: <Widget>[
        new TextButton(
          onPressed: () {},
          child: Text(
            'Save Image',
            style: TextStyle(color: Colors.black54),
          ),
        ),
        new TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'Close',
            style: TextStyle(color: Colors.black54),
          ),
        ),
      ],
    );
  }
}


// /// Still WIP favorite screen.
// import 'dart:core';
// import 'dart:io';
// import 'dart:math' as math;
// import 'package:astridzhao_s_food_app/database/recipesFormatConversion.dart';
// import 'package:http/http.dart' as http;
// import 'package:path_provider/path_provider.dart';
// import 'package:path/path.dart' as path;
// import 'package:astridzhao_s_food_app/core/app_export.dart';
// import 'package:astridzhao_s_food_app/database/database.dart';
// import 'package:astridzhao_s_food_app/database/recipes_dao.dart';
// import 'package:astridzhao_s_food_app/key/api_key.dart';
// import 'package:astridzhao_s_food_app/Interface/Create_Recipe_screen/generation_screen.dart';
// import 'package:dart_openai/dart_openai.dart';
// import 'package:drift/drift.dart' as drift;
// import 'package:flutter/material.dart';
// import 'dart:async';
// import 'dart:developer';

// class FavoriteRecipePage extends StatefulWidget {
//   const FavoriteRecipePage({Key? key}) : super(key: key);

//   @override
//   State<FavoriteRecipePage> createState() => FavoriteRecipePageState();
// }

// class FavoriteRecipePageState extends State<FavoriteRecipePage> {
//   Future<List<Recipe>>? futureRecipes;
//   final recipe_dao = RecipesDao(DatabaseService().database);
  
//   Map<int, File?> generatedImageUrls = {};
//   String currentUrls_fordisplay = "";

//   @override
//   void initState() {
//     super.initState();
//     fetchAllFavorite();
//   }

//   void fetchAllFavorite() {
//     setState(() {
//       futureRecipes = recipe_dao.select(recipe_dao.recipes).get();
//     });
//   }

//   Future<void> generateImage(int i, int id, String recipe) async {
//     try {
//       OpenAI.apiKey = azapiKey;
//       final image = await OpenAI.instance.image.create(
//         n: 1,
//         prompt: "You act as a professional image-generating assistant. By referencing the recipe title $recipe, use your imagination to create a related dish image can put on my restaurant menu. " +
//             "The image style should be cute and cartoon, and make it looks tasty to attract customers. " +
//             "Do not put any text on the image. ",
//       );

//       for (int index = 0; index < image.data.length; index++) {
//         final currentItem = image.data[index];
//         currentUrls_fordisplay = currentItem.url.toString();
//         // save image to local --> set generateImageURLS[i]
//         var response = await http.get(Uri.parse(currentUrls_fordisplay));
//         Directory documentdirectory = await getApplicationDocumentsDirectory();
//         String imageName = path.basename(currentUrls_fordisplay);
//         File file = new File(path.join(documentdirectory.path, imageName));
//         await file.writeAsBytes(response.bodyBytes);
//         print("local directory: " + documentdirectory.path);
//         // store image into local directory
//         await (recipe_dao.update(recipe_dao.recipes)..where((tbl) => tbl.id.equals(id)))
//           ..write(RecipesCompanion(imageURL: drift.Value(imageName)));

//         setState(() {
//           generatedImageUrls[i] = file;
//         });
//       }
//     } catch (e) {
//       log('Error in generateImage: $e');
//       // Handle the error or show a message to the user
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         // backgroundColor: appTheme.yellow_secondary,
//         title: const Text('My Favorites'),
//         toolbarHeight: 80,
//         titleTextStyle: TextStyle(
//             color: Colors.black54,
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//             fontFamily: "Outfit"),
//       ),
//       body: FutureBuilder(
//           future: futureRecipes,
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(child: CircularProgressIndicator());
//             } else {
//               // Handling for data state
//               final recipes = snapshot.data! as List<Recipe>;
              

//               return recipes.isEmpty
//                   ? const Center(
//                       child: Text(
//                         "No favorites..",
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 28,
//                         ),
//                       ),
//                     )
//                   : GridView.builder(
//                       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                         childAspectRatio: 5,
//                         crossAxisCount: 1, // Number of items per row
//                         crossAxisSpacing: 10, // Horizontal space between items
//                         mainAxisSpacing: 20, // Vertical space between items
//                       ),
//                       itemBuilder: (context, i) {
//                         // each recipe
//                         final recipe = recipes[i];
//                         generatedImageUrls[i] = recipe.imageURL != null
//                             ? File(recipe.imageURL!)
//                             : null;
//                         // Get a list of local image paths
//                         final List<String> localImages = [
//                           'assets/images/generate1.png',
//                           'assets/images/generate2.png',
//                           "assets/images/img_image_23.png"
//                         ];
//                         // Randomly pick an index from your collection of local images
//                         final random = math.Random();
//                         final randomImageIndex =
//                             random.nextInt(localImages.length);
//                         final randomImagePath = localImages[randomImageIndex];

//                         return ListTile(
//                           // contentPadding: EdgeInsets.symmetric(horizontal: 5),
//                           title: Row(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: <Widget>[
//                               //Check if the URL is not empty and the list is not empty
//                               (generatedImageUrls[i] != null &&
//                                       generatedImageUrls.isNotEmpty)
//                                   ? FutureBuilder(
//                                       future: generatedImageUrls[i]!.exists(),
//                                       builder: (BuildContext context,
//                                           AsyncSnapshot<bool> snapshot) {
//                                         // Check if the future is completed and the file exists
//                                         if (snapshot.connectionState ==
//                                                 ConnectionState.done &&
//                                             snapshot.data == true) {
//                                           return ClipOval(
//                                             child: Image.file(
//                                               generatedImageUrls[i]!,
//                                               width: 80,
//                                               height: 80,
//                                               fit: BoxFit.cover,
//                                             ),
//                                           );
//                                         } else {
//                                           // If file does not exist, show the asset image
//                                           return ClipOval(
//                                             child: Image.asset(
//                                               randomImagePath,
//                                               width: 80,
//                                               height: 80,
//                                               fit: BoxFit.cover,
//                                             ),
//                                           );
//                                         }
//                                       },
//                                     )
//                                   : ClipOval(
//                                       child: Image.asset(
//                                         randomImagePath,
//                                         width: 80,
//                                         height: 80,
//                                         fit: BoxFit.cover,
//                                       ),
//                                     ),

//                               SizedBox(width: 5),
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Column(
//                                       children: [
//                                         Text(
//                                           recipe.title,
//                                           maxLines: 2,
//                                           // softWrap: true,
//                                           textAlign: TextAlign.center,
//                                           style: TextStyle(
//                                             fontFamily: "Outfit",
//                                             color: appTheme.green_primary,
//                                             fontSize: 12,
//                                             fontWeight: FontWeight.normal,
//                                           ),
//                                         ),
//                                         SizedBox(height: 5),
//                                         Row(
//                                           children: [
//                                             ElevatedButton(
//                                               style: ElevatedButton.styleFrom(
//                                                 backgroundColor: appTheme
//                                                     .green_primary, // Set the button color to red
//                                                 padding: EdgeInsets.symmetric(
//                                                     horizontal: 15),
//                                               ),
//                                               onPressed: () {
//                                                 // view complete recipe
//                                               },
//                                               child: Text(
//                                                 "View",
//                                                 style: TextStyle(
//                                                   color: Colors.white,
//                                                   fontFamily: "Outfit",
//                                                   fontSize: 10,
//                                                 ),
//                                               ),
//                                             ),
//                                             SizedBox(width: 15),
//                                             // remove button
//                                             ElevatedButton(
//                                               style: ElevatedButton.styleFrom(
//                                                 backgroundColor: appTheme
//                                                     .orange_primary, // Set the button color to red
//                                                 padding: EdgeInsets.symmetric(
//                                                     horizontal: 15),
//                                               ),
//                                               onPressed: () {
//                                                 setState(() {
//                                                   (recipe_dao.delete(
//                                                           recipe_dao.recipes)
//                                                         ..where((tbl) => tbl.id
//                                                             .equals(
//                                                                 recipes[i].id)))
//                                                       .go();
//                                                   recipes.removeAt(i);
//                                                 });
//                                               },
//                                               child: Text(
//                                                 "Remove",
//                                                 style: TextStyle(
//                                                   color: Colors.white,
//                                                   fontFamily: "Outfit",
//                                                   fontSize: 10,
//                                                 ),
//                                               ),
//                                             ),
//                                             SizedBox(width: 15),
//                                             ElevatedButton(
//                                               style: ElevatedButton.styleFrom(
//                                                   padding: EdgeInsets.symmetric(
//                                                       horizontal: 15)),
//                                               child: Text(
//                                                 "what it looks like?",
//                                                 style: TextStyle(
//                                                     color:
//                                                         appTheme.green_primary,
//                                                     fontFamily: "Outfit",
//                                                     fontSize: 10),
//                                               ),
//                                               onPressed: () async {
//                                                 showDialog(
//                                                   context: context,
//                                                   barrierDismissible:
//                                                       false, // User must tap button to close dialog
//                                                   builder:
//                                                       (BuildContext context) {
//                                                     return AlertDialog(
//                                                       content: Row(
//                                                         children: [
//                                                           SizedBox(
//                                                             width: 20,
//                                                             height:
//                                                                 20, // Adjust the height as needed
//                                                             child:
//                                                                 CircularProgressIndicator(),
//                                                           ),
//                                                           SizedBox(width: 20),
//                                                           Text(
//                                                               "Crafting a delightful dish image..."),
//                                                         ],
//                                                       ),
//                                                     );
//                                                   },
//                                                 );

//                                                 await generateImage(
//                                                     i,
//                                                     recipe.id,
//                                                     recipe.title.toString());

//                                                 // pop alert waiting box
//                                                 Navigator.of(context).pop();

//                                                 // show image box
//                                                 showDialog(
//                                                   context: context,
//                                                   builder: (BuildContext
//                                                           context) =>
//                                                       popupDialogImage(context),
//                                                 );
//                                               },
//                                             )
//                                           ],
//                                         )
//                                       ],
//                                     )
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                           // subtitle: Text(subtitle),
//                         );
//                       },
//                       itemCount: recipes.length);
//             }
//           }),
//       // floatingActionButton: FloatingActionButton(
//       //   child: const Icon(Icons.add),
//       //   onPressed: () {},
//       // ),
//     );
//   }

//   Future<File> getFile(String imageName) async {
//     Directory documentDirectory = await getApplicationDocumentsDirectory();
//     return File(path.join(documentDirectory.path, imageName));
//   }

//   Widget popupDialogImage(BuildContext context) {
//     return new AlertDialog(
//       // title: const Text('Your dish looks like...'),
//       content: new Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: <Widget>[
//           Image.network(currentUrls_fordisplay),
//         ],
//       ),
//       actions: <Widget>[
//         new TextButton(
//           onPressed: () {},
//           child: Text(
//             'Save Image',
//             style: TextStyle(color: Colors.black54),
//           ),
//         ),
//         new TextButton(
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//           child: Text(
//             'Close',
//             style: TextStyle(color: Colors.black54),
//           ),
//         ),
//       ],
//     );
//   }

//   Future<bool> _checkFileExists(String path) async {
//     if (path.startsWith('assets/')) {
//       // Assuming asset paths start with 'assets/', no need to check file existence
//       return true;
//     } else {
//       final file = File(path);
//       return file.exists();
//     }
//   }
// }


