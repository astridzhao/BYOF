import 'package:astridzhao_s_food_app/database/recipe_dal.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


/// Database Service for the recipe app.
class DatabaseService {
  Database? _database;

  Future<Database> get database async {
    _database ??= await _initialize();
    return _database!;
  }

  Future<String> get fullPath async {
    const name = "recipe_app.db";
    final path = await getDatabasesPath();
    return join(path, name);
  }

  Future<Database> _initialize() async {
    final path = await fullPath;
    var database = await openDatabase(
      path,
      version: 1,
      onCreate: create,
      singleInstance: true,
    );
    return database;
  }

  Future<void> create(Database database, int version) async {
    await RecipeDal().createTable(database);
  }
}
