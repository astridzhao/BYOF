// GENERATED CODE, DO NOT EDIT BY HAND.
// ignore_for_file: type=lint
//@dart=2.12
import 'package:drift/drift.dart';

class Recipes extends Table with TableInfo<Recipes, RecipesData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Recipes(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> ingredients = GeneratedColumn<String>(
      'ingredients', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> instructions = GeneratedColumn<String>(
      'instructions', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<int> cookTime = GeneratedColumn<int>(
      'cook_time', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<int> saveAt = GeneratedColumn<int>(
      'save_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, title, ingredients, instructions, cookTime, notes, saveAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recipes';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RecipesData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecipesData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      ingredients: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}ingredients'])!,
      instructions: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}instructions'])!,
      cookTime: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}cook_time'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes'])!,
      saveAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}save_at'])!,
    );
  }

  @override
  Recipes createAlias(String alias) {
    return Recipes(attachedDatabase, alias);
  }
}

class RecipesData extends DataClass implements Insertable<RecipesData> {
  final int id;
  final String title;
  final String ingredients;
  final String instructions;
  final int cookTime;
  final String notes;
  final int saveAt;
  const RecipesData(
      {required this.id,
      required this.title,
      required this.ingredients,
      required this.instructions,
      required this.cookTime,
      required this.notes,
      required this.saveAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['ingredients'] = Variable<String>(ingredients);
    map['instructions'] = Variable<String>(instructions);
    map['cook_time'] = Variable<int>(cookTime);
    map['notes'] = Variable<String>(notes);
    map['save_at'] = Variable<int>(saveAt);
    return map;
  }

  RecipesCompanion toCompanion(bool nullToAbsent) {
    return RecipesCompanion(
      id: Value(id),
      title: Value(title),
      ingredients: Value(ingredients),
      instructions: Value(instructions),
      cookTime: Value(cookTime),
      notes: Value(notes),
      saveAt: Value(saveAt),
    );
  }

  factory RecipesData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecipesData(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      ingredients: serializer.fromJson<String>(json['ingredients']),
      instructions: serializer.fromJson<String>(json['instructions']),
      cookTime: serializer.fromJson<int>(json['cookTime']),
      notes: serializer.fromJson<String>(json['notes']),
      saveAt: serializer.fromJson<int>(json['saveAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'ingredients': serializer.toJson<String>(ingredients),
      'instructions': serializer.toJson<String>(instructions),
      'cookTime': serializer.toJson<int>(cookTime),
      'notes': serializer.toJson<String>(notes),
      'saveAt': serializer.toJson<int>(saveAt),
    };
  }

  RecipesData copyWith(
          {int? id,
          String? title,
          String? ingredients,
          String? instructions,
          int? cookTime,
          String? notes,
          int? saveAt}) =>
      RecipesData(
        id: id ?? this.id,
        title: title ?? this.title,
        ingredients: ingredients ?? this.ingredients,
        instructions: instructions ?? this.instructions,
        cookTime: cookTime ?? this.cookTime,
        notes: notes ?? this.notes,
        saveAt: saveAt ?? this.saveAt,
      );
  @override
  String toString() {
    return (StringBuffer('RecipesData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('ingredients: $ingredients, ')
          ..write('instructions: $instructions, ')
          ..write('cookTime: $cookTime, ')
          ..write('notes: $notes, ')
          ..write('saveAt: $saveAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, title, ingredients, instructions, cookTime, notes, saveAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecipesData &&
          other.id == this.id &&
          other.title == this.title &&
          other.ingredients == this.ingredients &&
          other.instructions == this.instructions &&
          other.cookTime == this.cookTime &&
          other.notes == this.notes &&
          other.saveAt == this.saveAt);
}

class RecipesCompanion extends UpdateCompanion<RecipesData> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> ingredients;
  final Value<String> instructions;
  final Value<int> cookTime;
  final Value<String> notes;
  final Value<int> saveAt;
  const RecipesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.ingredients = const Value.absent(),
    this.instructions = const Value.absent(),
    this.cookTime = const Value.absent(),
    this.notes = const Value.absent(),
    this.saveAt = const Value.absent(),
  });
  RecipesCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required String ingredients,
    required String instructions,
    required int cookTime,
    required String notes,
    required int saveAt,
  })  : title = Value(title),
        ingredients = Value(ingredients),
        instructions = Value(instructions),
        cookTime = Value(cookTime),
        notes = Value(notes),
        saveAt = Value(saveAt);
  static Insertable<RecipesData> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? ingredients,
    Expression<String>? instructions,
    Expression<int>? cookTime,
    Expression<String>? notes,
    Expression<int>? saveAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (ingredients != null) 'ingredients': ingredients,
      if (instructions != null) 'instructions': instructions,
      if (cookTime != null) 'cook_time': cookTime,
      if (notes != null) 'notes': notes,
      if (saveAt != null) 'save_at': saveAt,
    });
  }

  RecipesCompanion copyWith(
      {Value<int>? id,
      Value<String>? title,
      Value<String>? ingredients,
      Value<String>? instructions,
      Value<int>? cookTime,
      Value<String>? notes,
      Value<int>? saveAt}) {
    return RecipesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      ingredients: ingredients ?? this.ingredients,
      instructions: instructions ?? this.instructions,
      cookTime: cookTime ?? this.cookTime,
      notes: notes ?? this.notes,
      saveAt: saveAt ?? this.saveAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (ingredients.present) {
      map['ingredients'] = Variable<String>(ingredients.value);
    }
    if (instructions.present) {
      map['instructions'] = Variable<String>(instructions.value);
    }
    if (cookTime.present) {
      map['cook_time'] = Variable<int>(cookTime.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (saveAt.present) {
      map['save_at'] = Variable<int>(saveAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecipesCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('ingredients: $ingredients, ')
          ..write('instructions: $instructions, ')
          ..write('cookTime: $cookTime, ')
          ..write('notes: $notes, ')
          ..write('saveAt: $saveAt')
          ..write(')'))
        .toString();
  }
}

class DatabaseAtV1 extends GeneratedDatabase {
  DatabaseAtV1(QueryExecutor e) : super(e);
  late final Recipes recipes = Recipes(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [recipes];
  @override
  int get schemaVersion => 1;
}
