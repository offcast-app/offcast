import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'tables/channels_table.dart';
import 'tables/episodes_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Channels, Episodes])
class AppDatabase extends _$AppDatabase {
  static AppDatabase? _instance;

  static AppDatabase get instance => _instance ??= AppDatabase();

  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (Migrator m, int from, int to) async {
          // Destructive migration for development
          for (final TableInfo table in allTables) {
            await m.drop(table);
          }
          await m.createAll();
        },
      );
}

QueryExecutor _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'offcast.db'));
    return NativeDatabase.createInBackground(file);
  });
}
