/// Still WIP favorite screen.
import 'package:astridzhao_s_food_app/database/recipe_dal.dart';
import 'package:astridzhao_s_food_app/model/recipe.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class FavoriteRecipePage extends StatefulWidget {
  const FavoriteRecipePage({Key? key}) : super(key: key);

  @override
  State<FavoriteRecipePage> createState() => FavoriteRecipePageState();
}

class FavoriteRecipePageState extends State<FavoriteRecipePage> {
  Future<List<Recipe>>? futureRecipes;
  final dal = RecipeDal();

  @override
  void initState() {
    super.initState();
    fetchAllFavorite();
  }

  void fetchAllFavorite() {
    setState(() {
      futureRecipes = dal.selectAll();
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
                  : ListView.separated(
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
                      separatorBuilder: (context, i) =>
                          const SizedBox(height: 12),
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
