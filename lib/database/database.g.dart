// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $RecipesTable extends Recipes with TableInfo<$RecipesTable, Recipe> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecipesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _ingredientsMeta =
      const VerificationMeta('ingredients');
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String>
      ingredients = GeneratedColumn<String>('ingredients', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<List<String>>($RecipesTable.$converteringredients);
  static const VerificationMeta _instructionsMeta =
      const VerificationMeta('instructions');
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String>
      instructions = GeneratedColumn<String>('instructions', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<List<String>>($RecipesTable.$converterinstructions);
  static const VerificationMeta _cookTimeMeta =
      const VerificationMeta('cookTime');
  @override
  late final GeneratedColumn<int> cookTime = GeneratedColumn<int>(
      'cook_time', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _saveAtMeta = const VerificationMeta('saveAt');
  @override
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
  VerificationContext validateIntegrity(Insertable<Recipe> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    context.handle(_ingredientsMeta, const VerificationResult.success());
    context.handle(_instructionsMeta, const VerificationResult.success());
    if (data.containsKey('cook_time')) {
      context.handle(_cookTimeMeta,
          cookTime.isAcceptableOrUnknown(data['cook_time']!, _cookTimeMeta));
    } else if (isInserting) {
      context.missing(_cookTimeMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    } else if (isInserting) {
      context.missing(_notesMeta);
    }
    if (data.containsKey('save_at')) {
      context.handle(_saveAtMeta,
          saveAt.isAcceptableOrUnknown(data['save_at']!, _saveAtMeta));
    } else if (isInserting) {
      context.missing(_saveAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Recipe map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Recipe(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      ingredients: $RecipesTable.$converteringredients.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}ingredients'])!),
      instructions: $RecipesTable.$converterinstructions.fromSql(
          attachedDatabase.typeMapping.read(
              DriftSqlType.string, data['${effectivePrefix}instructions'])!),
      cookTime: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}cook_time'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes'])!,
      saveAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}save_at'])!,
    );
  }

  @override
  $RecipesTable createAlias(String alias) {
    return $RecipesTable(attachedDatabase, alias);
  }

  static TypeConverter<List<String>, String> $converteringredients =
      const StringListConverter();
  static TypeConverter<List<String>, String> $converterinstructions =
      const StringListConverter();
}

class Recipe extends DataClass implements Insertable<Recipe> {
  final int id;
  final String title;
  final List<String> ingredients;
  final List<String> instructions;
  final int cookTime;
  final String notes;
  final int saveAt;
  const Recipe(
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
    {
      map['ingredients'] = Variable<String>(
          $RecipesTable.$converteringredients.toSql(ingredients));
    }
    {
      map['instructions'] = Variable<String>(
          $RecipesTable.$converterinstructions.toSql(instructions));
    }
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

  factory Recipe.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Recipe(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      ingredients: serializer.fromJson<List<String>>(json['ingredients']),
      instructions: serializer.fromJson<List<String>>(json['instructions']),
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
      'ingredients': serializer.toJson<List<String>>(ingredients),
      'instructions': serializer.toJson<List<String>>(instructions),
      'cookTime': serializer.toJson<int>(cookTime),
      'notes': serializer.toJson<String>(notes),
      'saveAt': serializer.toJson<int>(saveAt),
    };
  }

  Recipe copyWith(
          {int? id,
          String? title,
          List<String>? ingredients,
          List<String>? instructions,
          int? cookTime,
          String? notes,
          int? saveAt}) =>
      Recipe(
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
    return (StringBuffer('Recipe(')
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
      (other is Recipe &&
          other.id == this.id &&
          other.title == this.title &&
          other.ingredients == this.ingredients &&
          other.instructions == this.instructions &&
          other.cookTime == this.cookTime &&
          other.notes == this.notes &&
          other.saveAt == this.saveAt);
}

class RecipesCompanion extends UpdateCompanion<Recipe> {
  final Value<int> id;
  final Value<String> title;
  final Value<List<String>> ingredients;
  final Value<List<String>> instructions;
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
    required List<String> ingredients,
    required List<String> instructions,
    required int cookTime,
    required String notes,
    required int saveAt,
  })  : title = Value(title),
        ingredients = Value(ingredients),
        instructions = Value(instructions),
        cookTime = Value(cookTime),
        notes = Value(notes),
        saveAt = Value(saveAt);
  static Insertable<Recipe> custom({
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
      Value<List<String>>? ingredients,
      Value<List<String>>? instructions,
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
      map['ingredients'] = Variable<String>(
          $RecipesTable.$converteringredients.toSql(ingredients.value));
    }
    if (instructions.present) {
      map['instructions'] = Variable<String>(
          $RecipesTable.$converterinstructions.toSql(instructions.value));
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

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  late final $RecipesTable recipes = $RecipesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [recipes];
}
