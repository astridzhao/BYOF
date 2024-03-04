import 'dart:core';
import 'dart:io';
import 'dart:typed_data';
import 'package:astridzhao_s_food_app/resources/firebasestore.dart';
import 'package:astridzhao_s_food_app/widgets/slideDirection.dart';
import 'package:dio/dio.dart';
import 'dart:math' as math;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:astridzhao_s_food_app/Interface/homepage_screen/homepage-container.dart';
import 'package:astridzhao_s_food_app/widgets/app_bar/custom_app_bar.dart';
import 'package:astridzhao_s_food_app/core/app_export.dart';
import 'package:astridzhao_s_food_app/database/database.dart';
import 'package:astridzhao_s_food_app/database/recipes_dao.dart';
import 'package:astridzhao_s_food_app/Interface/favorite_page/favorite-recipedetail-screen.dart';
import 'package:astridzhao_s_food_app/widgets/generation_azure/RecipeImageGenerator.dart';
import 'package:url_launcher/url_launcher.dart';

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
    RecipeImageGenerator generator = RecipeImageGenerator();
    try {
      List<String> result =
          await generator.generateImage_favoriteScreen(i, id, recipeTitle);
      String imageName = result[0];
      currentUrls_fordisplay = result[1];
      // store image into db for future fetch
      await (recipe_dao.update(recipe_dao.recipes)..where((tbl) => tbl.id.equals(id)))
        ..write(RecipesCompanion(imageURL: drift.Value(imageName)));
      setState(() {
        generatedImageUrls[i] = imageName;
      });
    } catch (e) {
      // Handle the exception, perhaps by showing an error message to the user.
      print("Error fetch image: $e");
    }
  }

  void saveNetworkImage(String generatedImageUrls) async {
    String path = generatedImageUrls;
    await requestGalleryPermission();
    var response = await Dio()
        .get(path, options: Options(responseType: ResponseType.bytes));

    final result = await ImageGallerySaver.saveImage(
      Uint8List.fromList(response.data),
      quality: 60,
    );

    print(result);

    Fluttertoast.showToast(
        msg: "Image is saved",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: appTheme.green_primary,
        textColor: Colors.white,
        fontSize: 14.fSize);
  }

  Future<bool> requestGalleryPermission() async {
    PermissionStatus status;
    // Determine whether you're targeting iOS or Android to request appropriate permission
    if (Platform.isIOS) {
      status = await Permission.photos.request();
    } else {
      // For Android, requesting storage permission
      status = await Permission.storage.request();
    }
    // Check if permission was granted
    return status.isGranted;
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
              return IconButton(
                  onPressed: () {
                    Navigator.of(context)
                        .push(CustomPageRoute(page: HomepageContainerScreen()));
                  },
                  icon: Icon(Icons.arrow_back_ios_new));
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
                                          title: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: <Widget>[
                                              Center(
                                                child: Text(
                                                  "Crafting a delightful dish image...",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontFamily: 'Outfit',
                                                      fontSize: 12.fSize),
                                                ),
                                              ),
                                            ],
                                          ),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              SizedBox(
                                                width: 20.h,
                                                height: 20
                                                    .v, // Adjust the height as needed
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                              SizedBox(height: 20.v),
                                              Text("Do not exit.",
                                                  style: TextStyle(
                                                    fontFamily: 'Outfit',
                                                    fontWeight: FontWeight.bold,
                                                    wordSpacing: 0,
                                                    letterSpacing: 0,
                                                    fontSize: 10.fSize,
                                                    color:
                                                        appTheme.orange_primary,
                                                  )),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                    var storeData = await Storedata(
                                        FirebaseAuth.instance.currentUser!.uid);
                                    final canGenerate =
                                        storeData.decrementGenerationLimit();
                                    if (canGenerate == UsageStatus.Success) {
                                      // execute generate image function
                                      await generateImage(i, recipe.id,
                                          recipe.title.toString());

                                      // pop off alert waiting box
                                      Navigator.of(context).pop();

                                      // show image box
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            popupDialogImage(context),
                                      );
                                    } else if (canGenerate ==
                                        UsageStatus.BetaSurveyNeeded) {
                                      // --- BETA ONLY SECTION BEGIN ---
                                      print("You need to fill a survey");
                                      // showDialog(context: context, builder: builder)
                                      showDialog(
                                        context: context,
                                        barrierDismissible:
                                            false, // User must tap button to close dialog
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            content: Row(
                                              children: [
                                                Text(
                                                    "Could you help us to fill out a survey?"),
                                              ],
                                            ),
                                            actions: <Widget>[
                                              new TextButton(
                                                onPressed: () async {
                                                  final Uri surveyUrl = Uri.parse(
                                                      "https://forms.gle/PZQBwYZwD7hUMCzq8");
                                                  if (!await launchUrl(
                                                      surveyUrl)) {
                                                    print(
                                                        "error launching survey url");
                                                  }
                                                  storeData.setBetaSurveyFilled(
                                                      filled: true);
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text(
                                                  'Proceed',
                                                  style: TextStyle(
                                                      color: Colors.black54,
                                                      fontSize: 14.fSize),
                                                ),
                                              ),
                                              new TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text(
                                                  'Close',
                                                  style: TextStyle(
                                                      color: Colors.black54,
                                                      fontSize: 14.fSize),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                      // --- BETA ONLY SECTION END   ---
                                    } else {
                                      print(
                                          "You've reached your generation limit.");
                                      Fluttertoast.showToast(
                                        msg:
                                            "You've reached your generation limit.",
                                        fontSize: 14.fSize,
                                        toastLength: Toast.LENGTH_LONG,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 2,
                                        backgroundColor:
                                            appTheme.orange_primary,
                                        textColor: Colors.black,
                                      );
                                    }
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
    log("where saved image " + documentDirectory.path);
    log("saved image name " + imageName);
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
          onPressed: () {
            saveNetworkImage(currentUrls_fordisplay);
          },
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
