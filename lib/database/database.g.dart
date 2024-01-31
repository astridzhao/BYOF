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
  static const VerificationMeta _imageURLMeta =
      const VerificationMeta('imageURL');
  @override
  late final GeneratedColumn<String> imageURL = GeneratedColumn<String>(
      'image_u_r_l', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _savingSummary_CO2Meta =
      const VerificationMeta('savingSummary_CO2');
  @override
  late final GeneratedColumn<double> savingSummary_CO2 =
      GeneratedColumn<double>('saving_summary_c_o2', aliasedName, false,
          type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _savingSummary_moneyMeta =
      const VerificationMeta('savingSummary_money');
  @override
  late final GeneratedColumn<double> savingSummary_money =
      GeneratedColumn<double>('saving_summary_money', aliasedName, false,
          type: DriftSqlType.double, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        title,
        ingredients,
        instructions,
        cookTime,
        notes,
        saveAt,
        imageURL,
        savingSummary_CO2,
        savingSummary_money
      ];
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
    if (data.containsKey('image_u_r_l')) {
      context.handle(_imageURLMeta,
          imageURL.isAcceptableOrUnknown(data['image_u_r_l']!, _imageURLMeta));
    }
    if (data.containsKey('saving_summary_c_o2')) {
      context.handle(
          _savingSummary_CO2Meta,
          savingSummary_CO2.isAcceptableOrUnknown(
              data['saving_summary_c_o2']!, _savingSummary_CO2Meta));
    } else if (isInserting) {
      context.missing(_savingSummary_CO2Meta);
    }
    if (data.containsKey('saving_summary_money')) {
      context.handle(
          _savingSummary_moneyMeta,
          savingSummary_money.isAcceptableOrUnknown(
              data['saving_summary_money']!, _savingSummary_moneyMeta));
    } else if (isInserting) {
      context.missing(_savingSummary_moneyMeta);
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
      imageURL: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image_u_r_l']),
      savingSummary_CO2: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}saving_summary_c_o2'])!,
      savingSummary_money: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}saving_summary_money'])!,
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
  final String? imageURL;
  final double savingSummary_CO2;
  final double savingSummary_money;
  const Recipe(
      {required this.id,
      required this.title,
      required this.ingredients,
      required this.instructions,
      required this.cookTime,
      required this.notes,
      required this.saveAt,
      this.imageURL,
      required this.savingSummary_CO2,
      required this.savingSummary_money});
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
    if (!nullToAbsent || imageURL != null) {
      map['image_u_r_l'] = Variable<String>(imageURL);
    }
    map['saving_summary_c_o2'] = Variable<double>(savingSummary_CO2);
    map['saving_summary_money'] = Variable<double>(savingSummary_money);
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
      imageURL: imageURL == null && nullToAbsent
          ? const Value.absent()
          : Value(imageURL),
      savingSummary_CO2: Value(savingSummary_CO2),
      savingSummary_money: Value(savingSummary_money),
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
      imageURL: serializer.fromJson<String?>(json['imageURL']),
      savingSummary_CO2: serializer.fromJson<double>(json['savingSummary_CO2']),
      savingSummary_money:
          serializer.fromJson<double>(json['savingSummary_money']),
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
      'imageURL': serializer.toJson<String?>(imageURL),
      'savingSummary_CO2': serializer.toJson<double>(savingSummary_CO2),
      'savingSummary_money': serializer.toJson<double>(savingSummary_money),
    };
  }

  Recipe copyWith(
          {int? id,
          String? title,
          List<String>? ingredients,
          List<String>? instructions,
          int? cookTime,
          String? notes,
          int? saveAt,
          Value<String?> imageURL = const Value.absent(),
          double? savingSummary_CO2,
          double? savingSummary_money}) =>
      Recipe(
        id: id ?? this.id,
        title: title ?? this.title,
        ingredients: ingredients ?? this.ingredients,
        instructions: instructions ?? this.instructions,
        cookTime: cookTime ?? this.cookTime,
        notes: notes ?? this.notes,
        saveAt: saveAt ?? this.saveAt,
        imageURL: imageURL.present ? imageURL.value : this.imageURL,
        savingSummary_CO2: savingSummary_CO2 ?? this.savingSummary_CO2,
        savingSummary_money: savingSummary_money ?? this.savingSummary_money,
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
          ..write('saveAt: $saveAt, ')
          ..write('imageURL: $imageURL, ')
          ..write('savingSummary_CO2: $savingSummary_CO2, ')
          ..write('savingSummary_money: $savingSummary_money')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      title,
      ingredients,
      instructions,
      cookTime,
      notes,
      saveAt,
      imageURL,
      savingSummary_CO2,
      savingSummary_money);
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
          other.saveAt == this.saveAt &&
          other.imageURL == this.imageURL &&
          other.savingSummary_CO2 == this.savingSummary_CO2 &&
          other.savingSummary_money == this.savingSummary_money);
}

class RecipesCompanion extends UpdateCompanion<Recipe> {
  final Value<int> id;
  final Value<String> title;
  final Value<List<String>> ingredients;
  final Value<List<String>> instructions;
  final Value<int> cookTime;
  final Value<String> notes;
  final Value<int> saveAt;
  final Value<String?> imageURL;
  final Value<double> savingSummary_CO2;
  final Value<double> savingSummary_money;
  const RecipesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.ingredients = const Value.absent(),
    this.instructions = const Value.absent(),
    this.cookTime = const Value.absent(),
    this.notes = const Value.absent(),
    this.saveAt = const Value.absent(),
    this.imageURL = const Value.absent(),
    this.savingSummary_CO2 = const Value.absent(),
    this.savingSummary_money = const Value.absent(),
  });
  RecipesCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required List<String> ingredients,
    required List<String> instructions,
    required int cookTime,
    required String notes,
    required int saveAt,
    this.imageURL = const Value.absent(),
    required double savingSummary_CO2,
    required double savingSummary_money,
  })  : title = Value(title),
        ingredients = Value(ingredients),
        instructions = Value(instructions),
        cookTime = Value(cookTime),
        notes = Value(notes),
        saveAt = Value(saveAt),
        savingSummary_CO2 = Value(savingSummary_CO2),
        savingSummary_money = Value(savingSummary_money);
  static Insertable<Recipe> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? ingredients,
    Expression<String>? instructions,
    Expression<int>? cookTime,
    Expression<String>? notes,
    Expression<int>? saveAt,
    Expression<String>? imageURL,
    Expression<double>? savingSummary_CO2,
    Expression<double>? savingSummary_money,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (ingredients != null) 'ingredients': ingredients,
      if (instructions != null) 'instructions': instructions,
      if (cookTime != null) 'cook_time': cookTime,
      if (notes != null) 'notes': notes,
      if (saveAt != null) 'save_at': saveAt,
      if (imageURL != null) 'image_u_r_l': imageURL,
      if (savingSummary_CO2 != null) 'saving_summary_c_o2': savingSummary_CO2,
      if (savingSummary_money != null)
        'saving_summary_money': savingSummary_money,
    });
  }

  RecipesCompanion copyWith(
      {Value<int>? id,
      Value<String>? title,
      Value<List<String>>? ingredients,
      Value<List<String>>? instructions,
      Value<int>? cookTime,
      Value<String>? notes,
      Value<int>? saveAt,
      Value<String?>? imageURL,
      Value<double>? savingSummary_CO2,
      Value<double>? savingSummary_money}) {
    return RecipesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      ingredients: ingredients ?? this.ingredients,
      instructions: instructions ?? this.instructions,
      cookTime: cookTime ?? this.cookTime,
      notes: notes ?? this.notes,
      saveAt: saveAt ?? this.saveAt,
      imageURL: imageURL ?? this.imageURL,
      savingSummary_CO2: savingSummary_CO2 ?? this.savingSummary_CO2,
      savingSummary_money: savingSummary_money ?? this.savingSummary_money,
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
    if (imageURL.present) {
      map['image_u_r_l'] = Variable<String>(imageURL.value);
    }
    if (savingSummary_CO2.present) {
      map['saving_summary_c_o2'] = Variable<double>(savingSummary_CO2.value);
    }
    if (savingSummary_money.present) {
      map['saving_summary_money'] = Variable<double>(savingSummary_money.value);
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
          ..write('saveAt: $saveAt, ')
          ..write('imageURL: $imageURL, ')
          ..write('savingSummary_CO2: $savingSummary_CO2, ')
          ..write('savingSummary_money: $savingSummary_money')
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
