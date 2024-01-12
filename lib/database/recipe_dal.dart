import 'package:astridzhao_s_food_app/database/database_service.dart';
import 'package:astridzhao_s_food_app/model/recipe.dart';
import 'package:sqflite/sqflite.dart';

/// Recipe Data Access Layer
class RecipeDal {
  final tableName = 'recipes';

  Future<void> createTable(Database database) async {
    await database.execute(
      'CREATE TABLE IF NOT EXISTS $tableName (id INTEGER PRIMARY KEY, title TEXT, ingredients TEXT, instructions TEXT, saveAt INTEGER)',
    );
  }

  Future<void> insert(Recipe recipe) async {
    final db = await DatabaseService().database;
    db.insert(
      tableName,
      recipe.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Recipe>> selectAll() async {
    final db = await DatabaseService().database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);

    return List.generate(maps.length, (i) => Recipe.fromMap(maps[i]));
  }

  Future<void> update(Recipe recipe) async {
    final db = await DatabaseService().database;
    await db.update(
      tableName,
      recipe.toMap(),
      where: 'id = ?',
      whereArgs: [recipe.id],
    );
  }

  Future<void> delete(int id) async {
    final db = await DatabaseService().database;
    await db.delete(
      'recipes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
