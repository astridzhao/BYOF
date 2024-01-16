import 'package:astridzhao_s_food_app/database/database.dart';
import 'package:astridzhao_s_food_app/database/recipes.dart';
import 'package:drift/drift.dart';

part 'recipes_dao.g.dart';

@DriftAccessor(tables: [Recipes])
class RecipesDao extends DatabaseAccessor<AppDatabase> with _$RecipesDaoMixin {
  RecipesDao(AppDatabase db) : super(db);
}

