import 'package:astridzhao_s_food_app/database/recipe_dal.dart';
import 'package:astridzhao_s_food_app/model/recipe.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// Testing database-related functionalities.
void main() {
  setUpAll(()  {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
  });
  test('Recipe Table Routine, ', () async {
    var gardenSalad = Recipe(
      id: 1,
      title: 'Garden salad',
      ingredients: ["lettuce", "cherry tomatos"],
      instructions: [
        "Cut all ingredient into slices.",
        "Put them in the same bowl.",
        "Add your favoriate dressing",
        "Shake well and serve."
      ],
      saveAt: DateTime.now(),
    );

    var scrabbleEggs = Recipe(
      id: 0,
      title: 'Scrable eggs',
      ingredients: ["eggs", "black pepper"],
      instructions: [
        "Cook the eggs.",
        "Add black pepper.",
      ],
      saveAt: DateTime.now(),
    );

    final dal = RecipeDal();

    expect("recipes", dal.tableName);
    
    dal.insert(scrabbleEggs);
    dal.insert(gardenSalad);

    var recipes = await dal.selectAll();
    expect(recipes.length, 2);

    dal.delete(scrabbleEggs.id);

    recipes = await dal.selectAll();
    expect(recipes.length, 1);
    expect(recipes[0].id, gardenSalad.id);

    gardenSalad.ingredients.add("Ranch");
    dal.update(gardenSalad);

    recipes = await dal.selectAll();
    expect(recipes[0].ingredients.last, "Ranch");
  });
}