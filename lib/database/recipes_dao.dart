import 'package:astridzhao_s_food_app/database/database.dart';
import 'package:astridzhao_s_food_app/database/recipes.dart';
import 'package:drift/drift.dart';

part 'recipes_dao.g.dart';


/// Usage:
/// ```dart
/// // Inserts
/// // ...
/// final llmJson = <...>
/// final recipe = RecipeFromLLMJson(llmJson);
/// // do whatever
/// ...
/// // on save:
/// await recipes_dao.into(recipes_dao.recipes).insert();
/// 
/// // Select all recipes
/// List<Recipe> allRecipes = await recipes_dao.select(recipes_dao.recipes).get();
/// 
/// ```
@DriftAccessor(tables: [Recipes])
class RecipesDao extends DatabaseAccessor<AppDatabase> with _$RecipesDaoMixin {
  RecipesDao(AppDatabase db) : super(db);
}

