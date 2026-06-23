import 'package:drift/drift.dart';

class Episodes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get videoId => text().unique()();
  TextColumn get channelId => text()();
  TextColumn get title => text()();
  TextColumn get thumbnailUrl => text().nullable()();
  IntColumn get durationSec => integer().nullable()();
  IntColumn get publishedAt => integer().nullable()();
  TextColumn get audioPath => text().nullable()();
  TextColumn get videoPath => text().nullable()();
  TextColumn get downloadMode => text().withDefault(const Constant('none'))();
  IntColumn get downloadedAt => integer().nullable()();
  IntColumn get playbackPositionSec => integer().withDefault(const Constant(0))();
  IntColumn get isPlayed => integer().withDefault(const Constant(0))();
  IntColumn get fileSizeBytes => integer().nullable()();
}
