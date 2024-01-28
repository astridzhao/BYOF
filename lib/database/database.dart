import 'dart:io';

import 'package:astridzhao_s_food_app/database/recipesFormatConversion.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';
import 'package:astridzhao_s_food_app/database/schema_versions.dart';
import 'package:drift/internal/versioned_schema.dart';
import 'package:drift_dev/api/migrations.dart';

import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

part 'database.g.dart';

class DatabaseService {
  static AppDatabase? _database;

  AppDatabase get database {
    _database ??= AppDatabase("recipe_app.db");
    return _database!;
  }
}

const kDebugMode = true;

@DriftDatabase(tables: [Recipes], include: {'recipes_dao.dart'})
class AppDatabase extends _$AppDatabase {
  AppDatabase(String dbName) : super(_openConnection(dbName));

  static const latestSchemaVersion = 3;

  @override
  int get schemaVersion => latestSchemaVersion;

  Future<void> deleteEverything() {
    return transaction(() async {
      for (final table in allTables) {
        await delete(table).go();
      }
    });
  }
  // AppDatabase(super.connection);

  MigrationStrategy get migration {
    return MigrationStrategy(
      onUpgrade: (m, from, to) async {
        // Following the advice from https://drift.simonbinder.eu/docs/advanced-features/migrations/#tips
        await customStatement('PRAGMA foreign_keys = OFF');

        await transaction(
          () => VersionedSchema.runMigrationSteps(
            migrator: m,
            from: from,
            to: to,
            steps: _upgrade,
          ),
        );

        if (kDebugMode) {
          final wrongForeignKeys =
              await customSelect('PRAGMA foreign_key_check').get();
          assert(wrongForeignKeys.isEmpty,
              '${wrongForeignKeys.map((e) => e.data)}');
        }
      },
      beforeOpen: (details) async {
        await customStatement('PRAGMA foreign_keys = ON');
        // For Flutter apps, this should be wrapped in an if (kDebugMode) as
        // suggested here: https://drift.simonbinder.eu/docs/advanced-features/migrations/#verifying-a-database-schema-at-runtime
        await validateDatabaseSchema();
      },
    );
  }

  static final _upgrade = migrationSteps(
    from1To2: (m, schema) async {
      // Migration from 1 to 2: Add imageURL column in recipes, use "" as default.
      await m.alterTable(
        TableMigration(
          schema.recipes,
          columnTransformer: {
            schema.recipes.imageURL: const Constant<String>(""),
          },
          newColumns: [schema.recipes.imageURL],
        ),
      );
    },
    from2To3: (m, schema) async {
      // Migration from 2 to 3: Add savingSummary_CO2+_Money column in recipes.
      await m.addColumn(schema.recipes, schema.recipes.savingSummary_CO2);
      await m.addColumn(schema.recipes, schema.recipes.savingSummary_money);
    },
    from3To4: (m, schema) async {
      //Changing category colum datatype from TextColumn to IntColumn with type cast
      await m.alterTable(TableMigration(
          schema.recipes, //the table where the change is to be made
          columnTransformer: {
            schema.recipes.savingSummary_CO2:
                schema.recipes.savingSummary_CO2.cast<double>(),
            schema.recipes.savingSummary_money:
                schema.recipes.savingSummary_money.cast<double>(),
          }));
    },
  );
}

LazyDatabase _openConnection(String dbName) {
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, dbName));
    // print(file.path);

    // Also work around limitations on old Android versions
    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    }

    // Make sqlite3 pick a more suitable location for temporary files - the
    // one from the system may be inaccessible due to sandboxing.
    final cachebase = (await getTemporaryDirectory()).path;
    // We can't access /tmp on Android, which sqlite3 would try by default.
    // Explicitly tell it about the correct temporary directory.
    sqlite3.tempDirectory = cachebase;

    return NativeDatabase.createInBackground(file);
  });
}
