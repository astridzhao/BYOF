/// Still WIP favorite screen.
import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'dart:math' as math;
import 'package:astridzhao_s_food_app/widgets/app_bar/custom_app_bar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:astridzhao_s_food_app/core/app_export.dart';
import 'package:astridzhao_s_food_app/database/database.dart';
import 'package:astridzhao_s_food_app/database/recipes_dao.dart';
import 'package:astridzhao_s_food_app/key/api_key.dart';
import 'package:astridzhao_s_food_app/Interface/favorite_page/favorite-recipedetail-screen.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'dart:developer';

class FavoriteRecipePage2 extends StatefulWidget {
  const FavoriteRecipePage2({Key? key}) : super(key: key);

  @override
  State<FavoriteRecipePage2> createState() => FavoriteRecipePageState2();
}

class FavoriteRecipePageState2 extends State<FavoriteRecipePage2> {
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

  Future<void> generateImage(int i, int id, String recipeTitle) async {
    try {
      var params = {
        'title': recipeTitle,
      };
      log(params.toString());

      var uri = Uri.https(
          'http-byof-recipe-gen.azurewebsites.net', '/api/byof_llm_get_image');

      // send request to openAI on Azure
      var response_fromAzure = await http.post(uri, body: jsonEncode(params));
      currentUrls_fordisplay = response_fromAzure.body;
      log("image network by openAI: ${response_fromAzure.body}");
      // download the image from the URL: set to response

      var response = await http.get(Uri.parse(currentUrls_fordisplay));
      if (response.statusCode == 200) {
        Directory documentdirectory = await getApplicationDocumentsDirectory();
        String imageName = path.basename(currentUrls_fordisplay);
        print("Image save name: $imageName");
        File file = new File(path.join(documentdirectory.path, imageName));
        await file.writeAsBytes(response.bodyBytes);
        print("Image saved in local directory: ${documentdirectory.path}");

        // store image into local directory
        await (recipe_dao.update(recipe_dao.recipes)..where((tbl) => tbl.id.equals(id)))
          ..write(RecipesCompanion(imageURL: drift.Value(imageName)));

        setState(() {
          generatedImageUrls[i] = imageName;
        });
      } else {
        throw Exception('Failed to load image');
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
          appBar: CustomAppBar(
            elevation: 0,
            centerTitle: true,
            title: Text(
              'My Favorites',
              style: TextStyle(
                  color: Color.fromARGB(190, 0, 0, 0),
                  fontSize: 18.fSize,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Outfit"),
            ),
            toolbarHeight: screenHeight * 0.1,
            leadingWidth: MediaQuery.of(context).size.width * 0.2,
            leading: Builder(builder: (BuildContext context) {
              return CustomImageView(
                imagePath: ImageConstant.imgLogo2RemovebgPreview,
                fit: BoxFit.contain,
                margin: EdgeInsets.only(left: 10.h),
              );
            }),
          ),
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(
                    "assets/images/favoritescreen_background.png"), // Replace with your image path
                opacity: 0.1,
              ),
            ),
            child: FutureBuilder(
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
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.h,
                            ),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              childAspectRatio:
                                  screenWidth / (screenHeight / 1.75),
                              crossAxisCount: 2, // Number of items per row
                              crossAxisSpacing:
                                  10.h, // Horizontal space between items
                              mainAxisSpacing:
                                  20.v, // Vertical space between items
                            ),
                            itemBuilder: (context, i) {
                              // each recipe
                              final recipe = recipes[i];
                              //get the image name saved in the folder
                              generatedImageUrls[i] = recipe.imageURL != null
                                  ? recipe.imageURL
                                  : null;
                              // Get a list of local image paths
                              final List<String> localImages = [
                                'assets/images/random_image_breakfast.png',
                                'assets/images/random_image_soup.png',
                                "assets/images/random_image_pizza.png",
                                "assets/images/random_image_onepot.png",
                                "assets/images/random_image_pancake.png"
                              ];
                              // Randomly pick an index from your collection of local images
                              final random = math.Random();
                              final randomImageIndex =
                                  random.nextInt(localImages.length);
                              final randomImagePath =
                                  localImages[randomImageIndex];

                              return Dismissible(
                                key: Key('${recipe.id}'),
                                direction: DismissDirection.horizontal,
                                // direction: DismissDirection.endToStart,
                                confirmDismiss: (direction) async {
                                  if (direction ==
                                      DismissDirection.endToStart) {
                                    final bool? confirmDelete =
                                        await showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text("Delete Recipe"),
                                          content: Text(
                                              "Are you sure to delete this recipe?"),
                                          actions: <Widget>[
                                            TextButton(
                                              child: Text(
                                                'Cancel',
                                                style: TextStyle(
                                                    color: Colors.black87,
                                                    fontFamily: "Outfit"),
                                              ),
                                              onPressed: () =>
                                                  Navigator.of(context)
                                                      .pop(false),
                                            ),
                                            TextButton(
                                                child: Text(
                                                  'Delete',
                                                  style: TextStyle(
                                                      color: Colors.black87,
                                                      fontFamily: "Outfit"),
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    (recipe_dao.delete(
                                                            recipe_dao.recipes)
                                                          ..where((tbl) => tbl
                                                              .id
                                                              .equals(recipes[i]
                                                                  .id)))
                                                        .go();
                                                    recipes.removeAt(i);
                                                  });
                                                  Navigator.of(context)
                                                      .pop(true);
                                                }),
                                          ],
                                        );
                                      },
                                    );
                                    return confirmDelete ?? false;
                                  }
                                  // Handle right swipe : upload user image
                                  else if (direction ==
                                      DismissDirection.startToEnd) {
                                    //generate image feature

                                    // send waiting alert
                                    showDialog(
                                      context: context,
                                      barrierDismissible:
                                          false, // User must tap button to close dialog
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          content: Row(
                                            children: [
                                              SizedBox(
                                                width: 20.adaptSize,
                                                height: 20
                                                    .adaptSize, // Adjust the height as needed
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                              SizedBox(width: 20.h),
                                              Text(
                                                  "Crafting a delightful dish image..."),
                                            ],
                                          ),
                                        );
                                      },
                                    );

                                    // execute generate image function
                                    await generateImage(
                                        i, recipe.id, recipe.title.toString());

                                    // pop off alert waiting box
                                    Navigator.of(context).pop();

                                    // show image box
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          popupDialogImage(context),
                                    );
                                  }
                                },

                                //swipe to right background
                                background: Container(
                                  color: appTheme.green_primary,
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10.h),
                                  alignment: AlignmentDirectional.centerStart,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Icon(Icons.add_a_photo,
                                          color: Colors.white),
                                      SizedBox(
                                        width: 5.h,
                                      ),
                                      Text('Create my dish',
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ],
                                  ),
                                ),
                                //swipe to left background
                                secondaryBackground: Container(
                                  color: const Color.fromARGB(255, 165, 44, 36),
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10.h),
                                  alignment: AlignmentDirectional.centerEnd,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Icon(Icons.delete, color: Colors.white),
                                      Text('Remove',
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ],
                                  ),
                                ),

                                // chick: enter recipe page
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                (GenerationScreen_favorite(
                                                    recipe: recipe))));
                                  },

                                  // Use Card to show image
                                  child: Card(
                                    clipBehavior: Clip.antiAlias,
                                    elevation: 4.0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    // contentPadding: EdgeInsets.symmetric(horizontal: 5),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      //Check if the URL is not empty and the list is not empty
                                      children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.all(8),
                                          child: (generatedImageUrls[i] !=
                                                      null &&
                                                  generatedImageUrls.isNotEmpty)
                                              ? FutureBuilder(
                                                  future: getFile(
                                                      generatedImageUrls[i]!),
                                                  builder:
                                                      (BuildContext context,
                                                          AsyncSnapshot<File>
                                                              snapshot) {
                                                    // Check if the future is complete
                                                    if (snapshot
                                                            .connectionState ==
                                                        ConnectionState.done) {
                                                      //Testing:
                                                      print(
                                                          "fetch local image");
                                                      print(snapshot.data!);
                                                      // Check if the snapshot has data and the file exists
                                                      if (snapshot.hasData &&
                                                          snapshot.data!
                                                              .existsSync()) {
                                                        return ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          child: Image.file(
                                                            snapshot.data!,
                                                            width:
                                                                150.adaptSize,
                                                            height:
                                                                120.adaptSize,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        );
                                                      } else {
                                                        // If file does not exist or there is no data, show the asset image
                                                        return ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          child: Image.asset(
                                                            randomImagePath,
                                                            width:
                                                                150.adaptSize,
                                                            height:
                                                                120.adaptSize,
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
                                              : ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: Image.asset(
                                                    randomImagePath,
                                                    width: 150.adaptSize,
                                                    height: 120.adaptSize,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              8.h, 0, 8.h, 0),
                                          child: Column(
                                            children: [
                                              AutoSizeText(
                                                recipe.title,
                                                textAlign: TextAlign.center,
                                                maxLines: 2,
                                                maxFontSize: 14,
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(2.h),
                                          child: Column(
                                            children: [
                                              AutoSizeText(
                                                recipe.cookTime.toString() +
                                                    " mins",
                                                maxFontSize: 12,
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // Container(
                                        //   margin: EdgeInsets.symmetric(
                                        //       horizontal: 20.h),
                                        //   child: ImageGenerationButton(
                                        //       context, i, recipe),
                                        // )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            itemCount: recipes.length);
                  }
                }),
          )),
    );
  }

  Future<File> getFile(String imageName) async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    return File(path.join(documentDirectory.path, imageName));
  }

  Widget popupDialogDelete(
      BuildContext context, List<Recipe> recipes, Recipe recipe, i) {
    return new AlertDialog(
      // title: const Text('Your dish looks like...'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text("Are you sure to delete this recipe?"),
        ],
      ),
      actions: <Widget>[
        new TextButton(
          child: Text(
            'Yes',
            style: TextStyle(color: Colors.black54),
          ),
          onPressed: () {
            // Handle left swipe : delete recipe
            setState(() {
              (recipe_dao.delete(recipe_dao.recipes)
                    ..where((tbl) => tbl.id.equals(recipes[i].id)))
                  .go();
              recipes.removeAt(i);
            });
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                margin: EdgeInsets.only(bottom: 50),
                padding: EdgeInsets.all(20),
                behavior: SnackBarBehavior.floating,
                action: SnackBarAction(
                  label: 'Dismiss',
                  disabledTextColor: Colors.white,
                  textColor: Colors.yellow,
                  onPressed: () {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  },
                ),
                content: Text('Removed ${recipe.title}'),
              ),
            );
          },
        ),
        new TextButton(
          child: Text(
            'Cancel',
            style: TextStyle(color: Colors.black54),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  Widget ImageGenerationButton(BuildContext context, index, Recipe recipe) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 15.h)),
      child: Text(
        "what I can expect?",
        style: TextStyle(
            color: appTheme.green_primary,
            fontFamily: "Outfit",
            fontSize: 10.fSize),
      ),
      // if the user already generated a image once, disable the button
      onPressed: (generatedImageUrls[index] != null &&
              generatedImageUrls[index]!.isEmpty)
          ? () async {
              showDialog(
                context: context,
                barrierDismissible:
                    false, // User must tap button to close dialog
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Center(
                          child: Text(
                            "Crafting a delightful dish image...",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'Outfit', fontSize: 12.fSize),
                          ),
                        ),
                      ],
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 20.h,
                          height: 20.v, // Adjust the height as needed
                          child: CircularProgressIndicator(),
                        ),
                        SizedBox(height: 20.v),
                        Text("Do not exit.",
                            style: TextStyle(
                              fontFamily: 'Outfit',
                              fontWeight: FontWeight.bold,
                              wordSpacing: 0,
                              letterSpacing: 0,
                              fontSize: 10.fSize,
                              color: appTheme.orange_primary,
                            )),
                      ],
                    ),
                  );
                },
              );

              await generateImage(index, recipe.id, recipe.title.toString());

              // pop alert waiting box
              Navigator.of(context).pop();

              // show image box
              showDialog(
                context: context,
                builder: (BuildContext context) => popupDialogImage(context),
              );
            }
          : null,
    );
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
          //TODO: save to user's gallery
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
