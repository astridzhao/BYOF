import 'dart:convert';

import 'package:astridzhao_s_food_app/database/database.dart';
import 'package:drift/drift.dart';

class StringListConverter extends TypeConverter<List<String>, String> {
  const StringListConverter();

  @override
  List<String> fromSql(String fromDb) {
    return List<String>.from(jsonDecode(fromDb));
  }

  @override
  String toSql(List<String> value) {
    return jsonEncode(value);
  }
}

@DataClassName('Recipe')
class Recipes extends Table {
  // columns from v1
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get ingredients => text().map(const StringListConverter())();
  TextColumn get instructions => text().map(const StringListConverter())();
  IntColumn get cookTime => integer()();
  TextColumn get notes => text()();
  IntColumn get saveAt => integer()();

  // column from v2 + update in v3, making imageURL be nullable
  TextColumn get imageURL => text().nullable()();

  // column from v3
  IntColumn get savingSummary_CO2 => integer()();
  IntColumn get savingSummary_money => integer()();
}

/// Parses a LLM generated recipe into an insertable Recipe Dataclass.
RecipesCompanion RecipeFromLLMJson(String llmResult) {
  print(llmResult);
  final decoded = jsonDecode(llmResult) as Map<String, dynamic>;
  return RecipesCompanion.insert(
    title: decoded['Title'] as String,
    ingredients: List<String>.from(decoded['Ingredient List']),
    instructions: List<String>.from(decoded['Step-by-Step Instructions']),
    cookTime: decoded['Expected Cooking Time'] as int,
    notes: decoded['Note'] as String,
    saveAt: DateTime.now().millisecondsSinceEpoch,
    savingSummary_CO2: decoded['Saving Co2'] as int,
    savingSummary_money: decoded['Saving Money'] as int,
  );
}
