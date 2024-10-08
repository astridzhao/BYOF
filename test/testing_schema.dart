// import 'package:astridzhao_s_food_app/database/database.dart';
// import 'package:drift_dev/api/migrations.dart';
// import 'package:test/test.dart';
// // The generated directory from before.

// // Import the generated schema helper to instantiate databases at old versions.
// import 'generated_migrations/schema.dart';
// import 'generated_migrations/schema_v1.dart' as v1;
// import 'generated_migrations/schema_v2.dart' as v2;

// void main() {
//   late SchemaVerifier verifier;

//   setUpAll(() {
//     // GeneratedHelper() was generated by drift, the verifier is an api
//     // provided by drift_dev.
//     verifier = SchemaVerifier(GeneratedHelper());
//   });

//   group('general migration', () {
//     const currentSchema = AppDatabase.latestSchemaVersion;

//     for (var oldVersion = 1; oldVersion < currentSchema; oldVersion++) {
//       group('from v$oldVersion', () {
//         for (var targetVersion = oldVersion + 1;
//             targetVersion <= currentSchema;
//             targetVersion++) {
//           test('to v$targetVersion', () async {
//             final connection = await verifier.startAt(oldVersion);
//             final db = AppDatabase(connnection);
//             addTearDown(db.close);

//             await verifier.migrateAndValidate(db, targetVersion);
//           });
//         }
//       });
//     }
//   });

//   test('upgrade from v1 to v2', () async {
//     final schema = await verifier.schemaAt(1);
//     // Add some data to the users table, which only has an id column at v1
//     final oldDb = v1.DatabaseAtV1(schema.newConnection());
//     await oldDb.into(oldDb.recipes).insert(v1.RecipesCompanion.insert(title: "Egg and Tomato", ingredients: "egg, tomato", instructions: "instructions", cookTime: 20, notes: "notes", saveAt: 2));
//     await oldDb.close();

//     // Use this to run a migration to v2 and then validate that the
//     // database has the expected schema.
//     await verifier.migrateAndValidate(db, 2);
//   });
// }
