import 'dart:convert';
import 'dart:ffi';

import 'package:astridzhao_s_food_app/database/database.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';

class StringListConverter extends drift.TypeConverter<List<String>, String> {
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

@drift.DataClassName('Recipe')
class Recipes extends drift.Table {
  // columns from v1
  drift.IntColumn get id => integer().autoIncrement()();
  drift.TextColumn get title => text()();
  drift.TextColumn get ingredients => text().map(const StringListConverter())();
  drift.TextColumn get instructions =>
      text().map(const StringListConverter())();
  drift.IntColumn get cookTime => integer()();
  drift.TextColumn get notes => text()();
  drift.IntColumn get saveAt => integer()();

  // column from v2 + update in v3, making imageURL be nullable
  drift.TextColumn get imageURL => text().nullable()();

  // column from v3 + v4 change column type
  drift.RealColumn get savingSummary_CO2 => real()();
  drift.RealColumn get savingSummary_money => real()();
}

/// Parses a LLM generated recipe into an insertable Recipe Dataclass.
RecipesCompanion? RecipeFromLLMJson(String llmResult) {
  try {
    final decoded = jsonDecode(llmResult) as Map<String, dynamic>;
    if (decoded.containsKey('error')) {
      throw Exception(decoded['error']);
    }
    print("decoded success");
    return RecipesCompanion.insert(
      title: decoded['Title'] as String,
      ingredients: List<String>.from(decoded['Ingredient List']),
      instructions: List<String>.from(decoded['Step-by-Step Instructions']),
      cookTime: decoded['Expected Cooking Time'] as int,
      notes: decoded['Note'] as String,
      saveAt: DateTime.now().millisecondsSinceEpoch,
      savingSummary_CO2: decoded['Saving Co2'] as double,
      savingSummary_money: decoded['Saving Money'] as double,
    );
  } catch (e) {
    print(e);
    Fluttertoast.showToast(
        msg: "Error! Please try again.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }
  return null;
}

String recipeToCopyableMarkdown(Recipe recipe) {
  final title = "# ${recipe.title}";
  final cookTime = "**Estimated cook time:** ${recipe.cookTime} min.";
  final ingredients =
      "## Ingredients\n${recipe.ingredients.map((s) => "- ${s}").join("\n")}";
  final instructions = "## Ingredients\n${recipe.instructions.join("\n")}";
  final notes = "## Notes\n${recipe.notes}";

  return [title, cookTime, ingredients, instructions, notes].join("\n\n");
}

String recipeCompanionToCopyableMarkdown(RecipesCompanion recipe) {
  final title = "# ${recipe.title.value}";
  final cookTime = "**Estimated cook time:** ${recipe.cookTime.value} min.";
  final ingredients =
      "## Ingredients\n${recipe.ingredients.value.map((s) => "- ${s}").join("\n")}";
  final instructions =
      "## Ingredients\n${recipe.instructions.value.join("\n")}";
  final notes = "## Notes\n${recipe.notes.value}";

  return [title, cookTime, ingredients, instructions, notes].join("\n\n");
}
