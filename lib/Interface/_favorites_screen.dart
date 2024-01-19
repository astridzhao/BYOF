/// Still WIP favorite screen.
import 'dart:math';

import 'package:astridzhao_s_food_app/core/app_export.dart';
import 'package:astridzhao_s_food_app/database/database.dart';
import 'package:astridzhao_s_food_app/database/recipes_dao.dart';
import 'package:astridzhao_s_food_app/key/api_key.dart';
import 'package:astridzhao_s_food_app/Interface/Create_Recipe_screen/generation_screen.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FavoriteRecipePage extends StatefulWidget {
  const FavoriteRecipePage({Key? key}) : super(key: key);

  @override
  State<FavoriteRecipePage> createState() => FavoriteRecipePageState();
}

class FavoriteRecipePageState extends State<FavoriteRecipePage> {
  Future<List<Recipe>>? futureRecipes;
  final recipe_dao = RecipesDao(DatabaseService().database);
  Map<int, String> generatedImageUrls = {};

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

  Future<void> generateImage(int imageIdex, String recipe) async {
    OpenAI.apiKey = azapiKey;
    final image = await OpenAI.instance.image.create(
      n: 1,
      prompt:
          'Using the $recipe to generate a corresponding dish page. The style should be cute and cartoon.',
    );

    setState(() {
      for (int index = 0; index < image.data.length; index++) {
        final currentItem = image.data[index];
        generatedImageUrls[imageIdex] = currentItem.url.toString();
        print(currentItem.url);
      }
      ;
    });
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
                        final recipe = recipes[i];

                        // Get a list of local image paths
                        final List<String> localImages = [
                          'assets/images/generate1.png',
                          'assets/images/generate2.png',
                          "assets/images/img_image_23.png"
                        ];
                        // Randomly pick an index from your collection of local images
                        final random = Random();
                        final randomImageIndex =
                            random.nextInt(localImages.length);
                        final randomImagePath = localImages[randomImageIndex];

                        return ListTile(
                          // contentPadding: EdgeInsets.symmetric(horizontal: 5),
                          title: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              (generatedImageUrls.isNotEmpty &&
                                      generatedImageUrls[i] != null)
                                  ? ClipOval(
                                      child: Image.network(
                                        generatedImageUrls[i]!,
                                        width:
                                            80, // Set the width to your desired size
                                        height:
                                            80, // Set the height to your desired size
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : ClipOval(
                                      child: Image.asset(
                                        randomImagePath,
                                        width:
                                            80, // Set the width to your desired size
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
                                                // Remove the corresponding grid item
                                                setState(() {
                                                  recipes.removeAt(i);
                                                  recipe_dao.delete(
                                                      recipe_dao.recipes);
                                                });
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
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: appTheme
                                                    .orange_primary, // Set the button color to red
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 15),
                                              ),
                                              onPressed: () {
                                                // Remove the corresponding grid item
                                                setState(() {
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
                                              onPressed: () async {
                                                showDialog(
                                                  context: context,
                                                  barrierDismissible:
                                                      false, // User must tap button to close dialog
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      content: Row(
                                                        children: [
                                                          CircularProgressIndicator(),
                                                          SizedBox(width: 20),
                                                          Text(
                                                              "Busy crafting a delightful dish image..."),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                );

                                                Navigator.of(context).pop();

                                                await generateImage(
                                                    i,
                                                    recipe.instructions
                                                        .join('\n'));
                                              },
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
}
