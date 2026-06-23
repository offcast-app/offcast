import 'package:drift/drift.dart';

class Channels extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get channelId => text().unique()();
  TextColumn get name => text()();
  TextColumn get thumbnailUrl => text().nullable()();
  IntColumn get addedAt => integer()();
  IntColumn get autoDownload => integer().withDefault(const Constant(1))();
  IntColumn get maxEpisodes => integer().withDefault(const Constant(10))();
  TextColumn get downloadMode => text().withDefault(const Constant('audio'))();
}
