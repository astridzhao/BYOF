/// Still WIP favorite screen.
import 'package:astridzhao_s_food_app/database/database.dart';
import 'package:astridzhao_s_food_app/database/recipes_dao.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class FavoriteRecipePage extends StatefulWidget {
  const FavoriteRecipePage({Key? key}) : super(key: key);

  @override
  State<FavoriteRecipePage> createState() => FavoriteRecipePageState();
}

class FavoriteRecipePageState extends State<FavoriteRecipePage> {
  Future<List<Recipe>>? futureRecipes;
  final recipe_dao = RecipesDao(DatabaseService().database);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
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
                        childAspectRatio: 6,
                        crossAxisCount: 1, // Number of items per row
                        crossAxisSpacing: 12, // Horizontal space between items
                        mainAxisSpacing: 12, // Vertical space between items
                      ),
                      itemBuilder: (context, i) {
                        final recipe = recipes[i];
                        final subtitle = recipe.ingredients.join(', ');
                        return ListTile(
                          title: Text(recipe.title,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(subtitle),
                        );
                      },
                      itemCount: recipes.length);
            }
          }),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {},
      ),
    );
  }
}
