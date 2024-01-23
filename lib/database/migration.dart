import 'package:astridzhao_s_food_app/database/schema_versions.dart';
import 'package:drift/drift.dart';

MigrationStrategy get migration {
  return MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    onUpgrade: stepByStep(
      from1To2: (m, schema) async {
        // we added the dueDate property in the change from version 1 to
        // version 2
        await m.addColumn(schema.recipes, schema.recipes.imageURL);
      },
      from2To3: (m, schema) async {
        await m.addColumn(schema.recipes, schema.recipes.savingSummary_CO2);
        await m.addColumn(schema.recipes, schema.recipes.savingSummary_money);
      },
    ),
  );
}
