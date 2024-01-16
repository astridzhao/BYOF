import 'dart:convert';

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
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get ingredients => text().map(const StringListConverter())();
  TextColumn get instructions => text().map(const StringListConverter())();
  IntColumn get cookTime => integer()();
  TextColumn get notes => text()();
  IntColumn get saveAt => integer()();
}
