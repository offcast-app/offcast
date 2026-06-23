// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ChannelsTable extends Channels with TableInfo<$ChannelsTable, Channel> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChannelsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _channelIdMeta =
      const VerificationMeta('channelId');
  @override
  late final GeneratedColumn<String> channelId = GeneratedColumn<String>(
      'channel_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _thumbnailUrlMeta =
      const VerificationMeta('thumbnailUrl');
  @override
  late final GeneratedColumn<String> thumbnailUrl = GeneratedColumn<String>(
      'thumbnail_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _addedAtMeta =
      const VerificationMeta('addedAt');
  @override
  late final GeneratedColumn<int> addedAt = GeneratedColumn<int>(
      'added_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _autoDownloadMeta =
      const VerificationMeta('autoDownload');
  @override
  late final GeneratedColumn<int> autoDownload = GeneratedColumn<int>(
      'auto_download', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _maxEpisodesMeta =
      const VerificationMeta('maxEpisodes');
  @override
  late final GeneratedColumn<int> maxEpisodes = GeneratedColumn<int>(
      'max_episodes', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(10));
  static const VerificationMeta _downloadModeMeta =
      const VerificationMeta('downloadMode');
  @override
  late final GeneratedColumn<String> downloadMode = GeneratedColumn<String>(
      'download_mode', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('audio'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        channelId,
        name,
        thumbnailUrl,
        addedAt,
        autoDownload,
        maxEpisodes,
        downloadMode
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'channels';
  @override
  VerificationContext validateIntegrity(Insertable<Channel> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('channel_id')) {
      context.handle(_channelIdMeta,
          channelId.isAcceptableOrUnknown(data['channel_id']!, _channelIdMeta));
    } else if (isInserting) {
      context.missing(_channelIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('thumbnail_url')) {
      context.handle(
          _thumbnailUrlMeta,
          thumbnailUrl.isAcceptableOrUnknown(
              data['thumbnail_url']!, _thumbnailUrlMeta));
    }
    if (data.containsKey('added_at')) {
      context.handle(_addedAtMeta,
          addedAt.isAcceptableOrUnknown(data['added_at']!, _addedAtMeta));
    } else if (isInserting) {
      context.missing(_addedAtMeta);
    }
    if (data.containsKey('auto_download')) {
      context.handle(
          _autoDownloadMeta,
          autoDownload.isAcceptableOrUnknown(
              data['auto_download']!, _autoDownloadMeta));
    }
    if (data.containsKey('max_episodes')) {
      context.handle(
          _maxEpisodesMeta,
          maxEpisodes.isAcceptableOrUnknown(
              data['max_episodes']!, _maxEpisodesMeta));
    }
    if (data.containsKey('download_mode')) {
      context.handle(
          _downloadModeMeta,
          downloadMode.isAcceptableOrUnknown(
              data['download_mode']!, _downloadModeMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Channel map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Channel(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      channelId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}channel_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      thumbnailUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}thumbnail_url']),
      addedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}added_at'])!,
      autoDownload: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}auto_download'])!,
      maxEpisodes: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}max_episodes'])!,
      downloadMode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}download_mode'])!,
    );
  }

  @override
  $ChannelsTable createAlias(String alias) {
    return $ChannelsTable(attachedDatabase, alias);
  }
}

class Channel extends DataClass implements Insertable<Channel> {
  final int id;
  final String channelId;
  final String name;
  final String? thumbnailUrl;
  final int addedAt;
  final int autoDownload;
  final int maxEpisodes;
  final String downloadMode;
  const Channel(
      {required this.id,
      required this.channelId,
      required this.name,
      this.thumbnailUrl,
      required this.addedAt,
      required this.autoDownload,
      required this.maxEpisodes,
      required this.downloadMode});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['channel_id'] = Variable<String>(channelId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || thumbnailUrl != null) {
      map['thumbnail_url'] = Variable<String>(thumbnailUrl);
    }
    map['added_at'] = Variable<int>(addedAt);
    map['auto_download'] = Variable<int>(autoDownload);
    map['max_episodes'] = Variable<int>(maxEpisodes);
    map['download_mode'] = Variable<String>(downloadMode);
    return map;
  }

  ChannelsCompanion toCompanion(bool nullToAbsent) {
    return ChannelsCompanion(
      id: Value(id),
      channelId: Value(channelId),
      name: Value(name),
      thumbnailUrl: thumbnailUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(thumbnailUrl),
      addedAt: Value(addedAt),
      autoDownload: Value(autoDownload),
      maxEpisodes: Value(maxEpisodes),
      downloadMode: Value(downloadMode),
    );
  }

  factory Channel.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Channel(
      id: serializer.fromJson<int>(json['id']),
      channelId: serializer.fromJson<String>(json['channelId']),
      name: serializer.fromJson<String>(json['name']),
      thumbnailUrl: serializer.fromJson<String?>(json['thumbnailUrl']),
      addedAt: serializer.fromJson<int>(json['addedAt']),
      autoDownload: serializer.fromJson<int>(json['autoDownload']),
      maxEpisodes: serializer.fromJson<int>(json['maxEpisodes']),
      downloadMode: serializer.fromJson<String>(json['downloadMode']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'channelId': serializer.toJson<String>(channelId),
      'name': serializer.toJson<String>(name),
      'thumbnailUrl': serializer.toJson<String?>(thumbnailUrl),
      'addedAt': serializer.toJson<int>(addedAt),
      'autoDownload': serializer.toJson<int>(autoDownload),
      'maxEpisodes': serializer.toJson<int>(maxEpisodes),
      'downloadMode': serializer.toJson<String>(downloadMode),
    };
  }

  Channel copyWith(
          {int? id,
          String? channelId,
          String? name,
          Value<String?> thumbnailUrl = const Value.absent(),
          int? addedAt,
          int? autoDownload,
          int? maxEpisodes,
          String? downloadMode}) =>
      Channel(
        id: id ?? this.id,
        channelId: channelId ?? this.channelId,
        name: name ?? this.name,
        thumbnailUrl:
            thumbnailUrl.present ? thumbnailUrl.value : this.thumbnailUrl,
        addedAt: addedAt ?? this.addedAt,
        autoDownload: autoDownload ?? this.autoDownload,
        maxEpisodes: maxEpisodes ?? this.maxEpisodes,
        downloadMode: downloadMode ?? this.downloadMode,
      );
  Channel copyWithCompanion(ChannelsCompanion data) {
    return Channel(
      id: data.id.present ? data.id.value : this.id,
      channelId: data.channelId.present ? data.channelId.value : this.channelId,
      name: data.name.present ? data.name.value : this.name,
      thumbnailUrl: data.thumbnailUrl.present
          ? data.thumbnailUrl.value
          : this.thumbnailUrl,
      addedAt: data.addedAt.present ? data.addedAt.value : this.addedAt,
      autoDownload: data.autoDownload.present
          ? data.autoDownload.value
          : this.autoDownload,
      maxEpisodes:
          data.maxEpisodes.present ? data.maxEpisodes.value : this.maxEpisodes,
      downloadMode: data.downloadMode.present
          ? data.downloadMode.value
          : this.downloadMode,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Channel(')
          ..write('id: $id, ')
          ..write('channelId: $channelId, ')
          ..write('name: $name, ')
          ..write('thumbnailUrl: $thumbnailUrl, ')
          ..write('addedAt: $addedAt, ')
          ..write('autoDownload: $autoDownload, ')
          ..write('maxEpisodes: $maxEpisodes, ')
          ..write('downloadMode: $downloadMode')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, channelId, name, thumbnailUrl, addedAt,
      autoDownload, maxEpisodes, downloadMode);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Channel &&
          other.id == this.id &&
          other.channelId == this.channelId &&
          other.name == this.name &&
          other.thumbnailUrl == this.thumbnailUrl &&
          other.addedAt == this.addedAt &&
          other.autoDownload == this.autoDownload &&
          other.maxEpisodes == this.maxEpisodes &&
          other.downloadMode == this.downloadMode);
}

class ChannelsCompanion extends UpdateCompanion<Channel> {
  final Value<int> id;
  final Value<String> channelId;
  final Value<String> name;
  final Value<String?> thumbnailUrl;
  final Value<int> addedAt;
  final Value<int> autoDownload;
  final Value<int> maxEpisodes;
  final Value<String> downloadMode;
  const ChannelsCompanion({
    this.id = const Value.absent(),
    this.channelId = const Value.absent(),
    this.name = const Value.absent(),
    this.thumbnailUrl = const Value.absent(),
    this.addedAt = const Value.absent(),
    this.autoDownload = const Value.absent(),
    this.maxEpisodes = const Value.absent(),
    this.downloadMode = const Value.absent(),
  });
  ChannelsCompanion.insert({
    this.id = const Value.absent(),
    required String channelId,
    required String name,
    this.thumbnailUrl = const Value.absent(),
    required int addedAt,
    this.autoDownload = const Value.absent(),
    this.maxEpisodes = const Value.absent(),
    this.downloadMode = const Value.absent(),
  })  : channelId = Value(channelId),
        name = Value(name),
        addedAt = Value(addedAt);
  static Insertable<Channel> custom({
    Expression<int>? id,
    Expression<String>? channelId,
    Expression<String>? name,
    Expression<String>? thumbnailUrl,
    Expression<int>? addedAt,
    Expression<int>? autoDownload,
    Expression<int>? maxEpisodes,
    Expression<String>? downloadMode,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (channelId != null) 'channel_id': channelId,
      if (name != null) 'name': name,
      if (thumbnailUrl != null) 'thumbnail_url': thumbnailUrl,
      if (addedAt != null) 'added_at': addedAt,
      if (autoDownload != null) 'auto_download': autoDownload,
      if (maxEpisodes != null) 'max_episodes': maxEpisodes,
      if (downloadMode != null) 'download_mode': downloadMode,
    });
  }

  ChannelsCompanion copyWith(
      {Value<int>? id,
      Value<String>? channelId,
      Value<String>? name,
      Value<String?>? thumbnailUrl,
      Value<int>? addedAt,
      Value<int>? autoDownload,
      Value<int>? maxEpisodes,
      Value<String>? downloadMode}) {
    return ChannelsCompanion(
      id: id ?? this.id,
      channelId: channelId ?? this.channelId,
      name: name ?? this.name,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      addedAt: addedAt ?? this.addedAt,
      autoDownload: autoDownload ?? this.autoDownload,
      maxEpisodes: maxEpisodes ?? this.maxEpisodes,
      downloadMode: downloadMode ?? this.downloadMode,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (channelId.present) {
      map['channel_id'] = Variable<String>(channelId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (thumbnailUrl.present) {
      map['thumbnail_url'] = Variable<String>(thumbnailUrl.value);
    }
    if (addedAt.present) {
      map['added_at'] = Variable<int>(addedAt.value);
    }
    if (autoDownload.present) {
      map['auto_download'] = Variable<int>(autoDownload.value);
    }
    if (maxEpisodes.present) {
      map['max_episodes'] = Variable<int>(maxEpisodes.value);
    }
    if (downloadMode.present) {
      map['download_mode'] = Variable<String>(downloadMode.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChannelsCompanion(')
          ..write('id: $id, ')
          ..write('channelId: $channelId, ')
          ..write('name: $name, ')
          ..write('thumbnailUrl: $thumbnailUrl, ')
          ..write('addedAt: $addedAt, ')
          ..write('autoDownload: $autoDownload, ')
          ..write('maxEpisodes: $maxEpisodes, ')
          ..write('downloadMode: $downloadMode')
          ..write(')'))
        .toString();
  }
}

class $EpisodesTable extends Episodes with TableInfo<$EpisodesTable, Episode> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EpisodesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _videoIdMeta =
      const VerificationMeta('videoId');
  @override
  late final GeneratedColumn<String> videoId = GeneratedColumn<String>(
      'video_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _channelIdMeta =
      const VerificationMeta('channelId');
  @override
  late final GeneratedColumn<String> channelId = GeneratedColumn<String>(
      'channel_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _thumbnailUrlMeta =
      const VerificationMeta('thumbnailUrl');
  @override
  late final GeneratedColumn<String> thumbnailUrl = GeneratedColumn<String>(
      'thumbnail_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _durationSecMeta =
      const VerificationMeta('durationSec');
  @override
  late final GeneratedColumn<int> durationSec = GeneratedColumn<int>(
      'duration_sec', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _publishedAtMeta =
      const VerificationMeta('publishedAt');
  @override
  late final GeneratedColumn<int> publishedAt = GeneratedColumn<int>(
      'published_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _audioPathMeta =
      const VerificationMeta('audioPath');
  @override
  late final GeneratedColumn<String> audioPath = GeneratedColumn<String>(
      'audio_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _videoPathMeta =
      const VerificationMeta('videoPath');
  @override
  late final GeneratedColumn<String> videoPath = GeneratedColumn<String>(
      'video_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _downloadModeMeta =
      const VerificationMeta('downloadMode');
  @override
  late final GeneratedColumn<String> downloadMode = GeneratedColumn<String>(
      'download_mode', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('none'));
  static const VerificationMeta _downloadedAtMeta =
      const VerificationMeta('downloadedAt');
  @override
  late final GeneratedColumn<int> downloadedAt = GeneratedColumn<int>(
      'downloaded_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _playbackPositionSecMeta =
      const VerificationMeta('playbackPositionSec');
  @override
  late final GeneratedColumn<int> playbackPositionSec = GeneratedColumn<int>(
      'playback_position_sec', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _isPlayedMeta =
      const VerificationMeta('isPlayed');
  @override
  late final GeneratedColumn<int> isPlayed = GeneratedColumn<int>(
      'is_played', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _fileSizeBytesMeta =
      const VerificationMeta('fileSizeBytes');
  @override
  late final GeneratedColumn<int> fileSizeBytes = GeneratedColumn<int>(
      'file_size_bytes', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        videoId,
        channelId,
        title,
        thumbnailUrl,
        durationSec,
        publishedAt,
        audioPath,
        videoPath,
        downloadMode,
        downloadedAt,
        playbackPositionSec,
        isPlayed,
        fileSizeBytes
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'episodes';
  @override
  VerificationContext validateIntegrity(Insertable<Episode> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('video_id')) {
      context.handle(_videoIdMeta,
          videoId.isAcceptableOrUnknown(data['video_id']!, _videoIdMeta));
    } else if (isInserting) {
      context.missing(_videoIdMeta);
    }
    if (data.containsKey('channel_id')) {
      context.handle(_channelIdMeta,
          channelId.isAcceptableOrUnknown(data['channel_id']!, _channelIdMeta));
    } else if (isInserting) {
      context.missing(_channelIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('thumbnail_url')) {
      context.handle(
          _thumbnailUrlMeta,
          thumbnailUrl.isAcceptableOrUnknown(
              data['thumbnail_url']!, _thumbnailUrlMeta));
    }
    if (data.containsKey('duration_sec')) {
      context.handle(
          _durationSecMeta,
          durationSec.isAcceptableOrUnknown(
              data['duration_sec']!, _durationSecMeta));
    }
    if (data.containsKey('published_at')) {
      context.handle(
          _publishedAtMeta,
          publishedAt.isAcceptableOrUnknown(
              data['published_at']!, _publishedAtMeta));
    }
    if (data.containsKey('audio_path')) {
      context.handle(_audioPathMeta,
          audioPath.isAcceptableOrUnknown(data['audio_path']!, _audioPathMeta));
    }
    if (data.containsKey('video_path')) {
      context.handle(_videoPathMeta,
          videoPath.isAcceptableOrUnknown(data['video_path']!, _videoPathMeta));
    }
    if (data.containsKey('download_mode')) {
      context.handle(
          _downloadModeMeta,
          downloadMode.isAcceptableOrUnknown(
              data['download_mode']!, _downloadModeMeta));
    }
    if (data.containsKey('downloaded_at')) {
      context.handle(
          _downloadedAtMeta,
          downloadedAt.isAcceptableOrUnknown(
              data['downloaded_at']!, _downloadedAtMeta));
    }
    if (data.containsKey('playback_position_sec')) {
      context.handle(
          _playbackPositionSecMeta,
          playbackPositionSec.isAcceptableOrUnknown(
              data['playback_position_sec']!, _playbackPositionSecMeta));
    }
    if (data.containsKey('is_played')) {
      context.handle(_isPlayedMeta,
          isPlayed.isAcceptableOrUnknown(data['is_played']!, _isPlayedMeta));
    }
    if (data.containsKey('file_size_bytes')) {
      context.handle(
          _fileSizeBytesMeta,
          fileSizeBytes.isAcceptableOrUnknown(
              data['file_size_bytes']!, _fileSizeBytesMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Episode map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Episode(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      videoId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}video_id'])!,
      channelId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}channel_id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      thumbnailUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}thumbnail_url']),
      durationSec: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}duration_sec']),
      publishedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}published_at']),
      audioPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}audio_path']),
      videoPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}video_path']),
      downloadMode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}download_mode'])!,
      downloadedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}downloaded_at']),
      playbackPositionSec: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}playback_position_sec'])!,
      isPlayed: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}is_played'])!,
      fileSizeBytes: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}file_size_bytes']),
    );
  }

  @override
  $EpisodesTable createAlias(String alias) {
    return $EpisodesTable(attachedDatabase, alias);
  }
}

class Episode extends DataClass implements Insertable<Episode> {
  final int id;
  final String videoId;
  final String channelId;
  final String title;
  final String? thumbnailUrl;
  final int? durationSec;
  final int? publishedAt;
  final String? audioPath;
  final String? videoPath;
  final String downloadMode;
  final int? downloadedAt;
  final int playbackPositionSec;
  final int isPlayed;
  final int? fileSizeBytes;
  const Episode(
      {required this.id,
      required this.videoId,
      required this.channelId,
      required this.title,
      this.thumbnailUrl,
      this.durationSec,
      this.publishedAt,
      this.audioPath,
      this.videoPath,
      required this.downloadMode,
      this.downloadedAt,
      required this.playbackPositionSec,
      required this.isPlayed,
      this.fileSizeBytes});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['video_id'] = Variable<String>(videoId);
    map['channel_id'] = Variable<String>(channelId);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || thumbnailUrl != null) {
      map['thumbnail_url'] = Variable<String>(thumbnailUrl);
    }
    if (!nullToAbsent || durationSec != null) {
      map['duration_sec'] = Variable<int>(durationSec);
    }
    if (!nullToAbsent || publishedAt != null) {
      map['published_at'] = Variable<int>(publishedAt);
    }
    if (!nullToAbsent || audioPath != null) {
      map['audio_path'] = Variable<String>(audioPath);
    }
    if (!nullToAbsent || videoPath != null) {
      map['video_path'] = Variable<String>(videoPath);
    }
    map['download_mode'] = Variable<String>(downloadMode);
    if (!nullToAbsent || downloadedAt != null) {
      map['downloaded_at'] = Variable<int>(downloadedAt);
    }
    map['playback_position_sec'] = Variable<int>(playbackPositionSec);
    map['is_played'] = Variable<int>(isPlayed);
    if (!nullToAbsent || fileSizeBytes != null) {
      map['file_size_bytes'] = Variable<int>(fileSizeBytes);
    }
    return map;
  }

  EpisodesCompanion toCompanion(bool nullToAbsent) {
    return EpisodesCompanion(
      id: Value(id),
      videoId: Value(videoId),
      channelId: Value(channelId),
      title: Value(title),
      thumbnailUrl: thumbnailUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(thumbnailUrl),
      durationSec: durationSec == null && nullToAbsent
          ? const Value.absent()
          : Value(durationSec),
      publishedAt: publishedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(publishedAt),
      audioPath: audioPath == null && nullToAbsent
          ? const Value.absent()
          : Value(audioPath),
      videoPath: videoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(videoPath),
      downloadMode: Value(downloadMode),
      downloadedAt: downloadedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(downloadedAt),
      playbackPositionSec: Value(playbackPositionSec),
      isPlayed: Value(isPlayed),
      fileSizeBytes: fileSizeBytes == null && nullToAbsent
          ? const Value.absent()
          : Value(fileSizeBytes),
    );
  }

  factory Episode.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Episode(
      id: serializer.fromJson<int>(json['id']),
      videoId: serializer.fromJson<String>(json['videoId']),
      channelId: serializer.fromJson<String>(json['channelId']),
      title: serializer.fromJson<String>(json['title']),
      thumbnailUrl: serializer.fromJson<String?>(json['thumbnailUrl']),
      durationSec: serializer.fromJson<int?>(json['durationSec']),
      publishedAt: serializer.fromJson<int?>(json['publishedAt']),
      audioPath: serializer.fromJson<String?>(json['audioPath']),
      videoPath: serializer.fromJson<String?>(json['videoPath']),
      downloadMode: serializer.fromJson<String>(json['downloadMode']),
      downloadedAt: serializer.fromJson<int?>(json['downloadedAt']),
      playbackPositionSec:
          serializer.fromJson<int>(json['playbackPositionSec']),
      isPlayed: serializer.fromJson<int>(json['isPlayed']),
      fileSizeBytes: serializer.fromJson<int?>(json['fileSizeBytes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'videoId': serializer.toJson<String>(videoId),
      'channelId': serializer.toJson<String>(channelId),
      'title': serializer.toJson<String>(title),
      'thumbnailUrl': serializer.toJson<String?>(thumbnailUrl),
      'durationSec': serializer.toJson<int?>(durationSec),
      'publishedAt': serializer.toJson<int?>(publishedAt),
      'audioPath': serializer.toJson<String?>(audioPath),
      'videoPath': serializer.toJson<String?>(videoPath),
      'downloadMode': serializer.toJson<String>(downloadMode),
      'downloadedAt': serializer.toJson<int?>(downloadedAt),
      'playbackPositionSec': serializer.toJson<int>(playbackPositionSec),
      'isPlayed': serializer.toJson<int>(isPlayed),
      'fileSizeBytes': serializer.toJson<int?>(fileSizeBytes),
    };
  }

  Episode copyWith(
          {int? id,
          String? videoId,
          String? channelId,
          String? title,
          Value<String?> thumbnailUrl = const Value.absent(),
          Value<int?> durationSec = const Value.absent(),
          Value<int?> publishedAt = const Value.absent(),
          Value<String?> audioPath = const Value.absent(),
          Value<String?> videoPath = const Value.absent(),
          String? downloadMode,
          Value<int?> downloadedAt = const Value.absent(),
          int? playbackPositionSec,
          int? isPlayed,
          Value<int?> fileSizeBytes = const Value.absent()}) =>
      Episode(
        id: id ?? this.id,
        videoId: videoId ?? this.videoId,
        channelId: channelId ?? this.channelId,
        title: title ?? this.title,
        thumbnailUrl:
            thumbnailUrl.present ? thumbnailUrl.value : this.thumbnailUrl,
        durationSec: durationSec.present ? durationSec.value : this.durationSec,
        publishedAt: publishedAt.present ? publishedAt.value : this.publishedAt,
        audioPath: audioPath.present ? audioPath.value : this.audioPath,
        videoPath: videoPath.present ? videoPath.value : this.videoPath,
        downloadMode: downloadMode ?? this.downloadMode,
        downloadedAt:
            downloadedAt.present ? downloadedAt.value : this.downloadedAt,
        playbackPositionSec: playbackPositionSec ?? this.playbackPositionSec,
        isPlayed: isPlayed ?? this.isPlayed,
        fileSizeBytes:
            fileSizeBytes.present ? fileSizeBytes.value : this.fileSizeBytes,
      );
  Episode copyWithCompanion(EpisodesCompanion data) {
    return Episode(
      id: data.id.present ? data.id.value : this.id,
      videoId: data.videoId.present ? data.videoId.value : this.videoId,
      channelId: data.channelId.present ? data.channelId.value : this.channelId,
      title: data.title.present ? data.title.value : this.title,
      thumbnailUrl: data.thumbnailUrl.present
          ? data.thumbnailUrl.value
          : this.thumbnailUrl,
      durationSec:
          data.durationSec.present ? data.durationSec.value : this.durationSec,
      publishedAt:
          data.publishedAt.present ? data.publishedAt.value : this.publishedAt,
      audioPath: data.audioPath.present ? data.audioPath.value : this.audioPath,
      videoPath: data.videoPath.present ? data.videoPath.value : this.videoPath,
      downloadMode: data.downloadMode.present
          ? data.downloadMode.value
          : this.downloadMode,
      downloadedAt: data.downloadedAt.present
          ? data.downloadedAt.value
          : this.downloadedAt,
      playbackPositionSec: data.playbackPositionSec.present
          ? data.playbackPositionSec.value
          : this.playbackPositionSec,
      isPlayed: data.isPlayed.present ? data.isPlayed.value : this.isPlayed,
      fileSizeBytes: data.fileSizeBytes.present
          ? data.fileSizeBytes.value
          : this.fileSizeBytes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Episode(')
          ..write('id: $id, ')
          ..write('videoId: $videoId, ')
          ..write('channelId: $channelId, ')
          ..write('title: $title, ')
          ..write('thumbnailUrl: $thumbnailUrl, ')
          ..write('durationSec: $durationSec, ')
          ..write('publishedAt: $publishedAt, ')
          ..write('audioPath: $audioPath, ')
          ..write('videoPath: $videoPath, ')
          ..write('downloadMode: $downloadMode, ')
          ..write('downloadedAt: $downloadedAt, ')
          ..write('playbackPositionSec: $playbackPositionSec, ')
          ..write('isPlayed: $isPlayed, ')
          ..write('fileSizeBytes: $fileSizeBytes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      videoId,
      channelId,
      title,
      thumbnailUrl,
      durationSec,
      publishedAt,
      audioPath,
      videoPath,
      downloadMode,
      downloadedAt,
      playbackPositionSec,
      isPlayed,
      fileSizeBytes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Episode &&
          other.id == this.id &&
          other.videoId == this.videoId &&
          other.channelId == this.channelId &&
          other.title == this.title &&
          other.thumbnailUrl == this.thumbnailUrl &&
          other.durationSec == this.durationSec &&
          other.publishedAt == this.publishedAt &&
          other.audioPath == this.audioPath &&
          other.videoPath == this.videoPath &&
          other.downloadMode == this.downloadMode &&
          other.downloadedAt == this.downloadedAt &&
          other.playbackPositionSec == this.playbackPositionSec &&
          other.isPlayed == this.isPlayed &&
          other.fileSizeBytes == this.fileSizeBytes);
}

class EpisodesCompanion extends UpdateCompanion<Episode> {
  final Value<int> id;
  final Value<String> videoId;
  final Value<String> channelId;
  final Value<String> title;
  final Value<String?> thumbnailUrl;
  final Value<int?> durationSec;
  final Value<int?> publishedAt;
  final Value<String?> audioPath;
  final Value<String?> videoPath;
  final Value<String> downloadMode;
  final Value<int?> downloadedAt;
  final Value<int> playbackPositionSec;
  final Value<int> isPlayed;
  final Value<int?> fileSizeBytes;
  const EpisodesCompanion({
    this.id = const Value.absent(),
    this.videoId = const Value.absent(),
    this.channelId = const Value.absent(),
    this.title = const Value.absent(),
    this.thumbnailUrl = const Value.absent(),
    this.durationSec = const Value.absent(),
    this.publishedAt = const Value.absent(),
    this.audioPath = const Value.absent(),
    this.videoPath = const Value.absent(),
    this.downloadMode = const Value.absent(),
    this.downloadedAt = const Value.absent(),
    this.playbackPositionSec = const Value.absent(),
    this.isPlayed = const Value.absent(),
    this.fileSizeBytes = const Value.absent(),
  });
  EpisodesCompanion.insert({
    this.id = const Value.absent(),
    required String videoId,
    required String channelId,
    required String title,
    this.thumbnailUrl = const Value.absent(),
    this.durationSec = const Value.absent(),
    this.publishedAt = const Value.absent(),
    this.audioPath = const Value.absent(),
    this.videoPath = const Value.absent(),
    this.downloadMode = const Value.absent(),
    this.downloadedAt = const Value.absent(),
    this.playbackPositionSec = const Value.absent(),
    this.isPlayed = const Value.absent(),
    this.fileSizeBytes = const Value.absent(),
  })  : videoId = Value(videoId),
        channelId = Value(channelId),
        title = Value(title);
  static Insertable<Episode> custom({
    Expression<int>? id,
    Expression<String>? videoId,
    Expression<String>? channelId,
    Expression<String>? title,
    Expression<String>? thumbnailUrl,
    Expression<int>? durationSec,
    Expression<int>? publishedAt,
    Expression<String>? audioPath,
    Expression<String>? videoPath,
    Expression<String>? downloadMode,
    Expression<int>? downloadedAt,
    Expression<int>? playbackPositionSec,
    Expression<int>? isPlayed,
    Expression<int>? fileSizeBytes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (videoId != null) 'video_id': videoId,
      if (channelId != null) 'channel_id': channelId,
      if (title != null) 'title': title,
      if (thumbnailUrl != null) 'thumbnail_url': thumbnailUrl,
      if (durationSec != null) 'duration_sec': durationSec,
      if (publishedAt != null) 'published_at': publishedAt,
      if (audioPath != null) 'audio_path': audioPath,
      if (videoPath != null) 'video_path': videoPath,
      if (downloadMode != null) 'download_mode': downloadMode,
      if (downloadedAt != null) 'downloaded_at': downloadedAt,
      if (playbackPositionSec != null)
        'playback_position_sec': playbackPositionSec,
      if (isPlayed != null) 'is_played': isPlayed,
      if (fileSizeBytes != null) 'file_size_bytes': fileSizeBytes,
    });
  }

  EpisodesCompanion copyWith(
      {Value<int>? id,
      Value<String>? videoId,
      Value<String>? channelId,
      Value<String>? title,
      Value<String?>? thumbnailUrl,
      Value<int?>? durationSec,
      Value<int?>? publishedAt,
      Value<String?>? audioPath,
      Value<String?>? videoPath,
      Value<String>? downloadMode,
      Value<int?>? downloadedAt,
      Value<int>? playbackPositionSec,
      Value<int>? isPlayed,
      Value<int?>? fileSizeBytes}) {
    return EpisodesCompanion(
      id: id ?? this.id,
      videoId: videoId ?? this.videoId,
      channelId: channelId ?? this.channelId,
      title: title ?? this.title,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      durationSec: durationSec ?? this.durationSec,
      publishedAt: publishedAt ?? this.publishedAt,
      audioPath: audioPath ?? this.audioPath,
      videoPath: videoPath ?? this.videoPath,
      downloadMode: downloadMode ?? this.downloadMode,
      downloadedAt: downloadedAt ?? this.downloadedAt,
      playbackPositionSec: playbackPositionSec ?? this.playbackPositionSec,
      isPlayed: isPlayed ?? this.isPlayed,
      fileSizeBytes: fileSizeBytes ?? this.fileSizeBytes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (videoId.present) {
      map['video_id'] = Variable<String>(videoId.value);
    }
    if (channelId.present) {
      map['channel_id'] = Variable<String>(channelId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (thumbnailUrl.present) {
      map['thumbnail_url'] = Variable<String>(thumbnailUrl.value);
    }
    if (durationSec.present) {
      map['duration_sec'] = Variable<int>(durationSec.value);
    }
    if (publishedAt.present) {
      map['published_at'] = Variable<int>(publishedAt.value);
    }
    if (audioPath.present) {
      map['audio_path'] = Variable<String>(audioPath.value);
    }
    if (videoPath.present) {
      map['video_path'] = Variable<String>(videoPath.value);
    }
    if (downloadMode.present) {
      map['download_mode'] = Variable<String>(downloadMode.value);
    }
    if (downloadedAt.present) {
      map['downloaded_at'] = Variable<int>(downloadedAt.value);
    }
    if (playbackPositionSec.present) {
      map['playback_position_sec'] = Variable<int>(playbackPositionSec.value);
    }
    if (isPlayed.present) {
      map['is_played'] = Variable<int>(isPlayed.value);
    }
    if (fileSizeBytes.present) {
      map['file_size_bytes'] = Variable<int>(fileSizeBytes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EpisodesCompanion(')
          ..write('id: $id, ')
          ..write('videoId: $videoId, ')
          ..write('channelId: $channelId, ')
          ..write('title: $title, ')
          ..write('thumbnailUrl: $thumbnailUrl, ')
          ..write('durationSec: $durationSec, ')
          ..write('publishedAt: $publishedAt, ')
          ..write('audioPath: $audioPath, ')
          ..write('videoPath: $videoPath, ')
          ..write('downloadMode: $downloadMode, ')
          ..write('downloadedAt: $downloadedAt, ')
          ..write('playbackPositionSec: $playbackPositionSec, ')
          ..write('isPlayed: $isPlayed, ')
          ..write('fileSizeBytes: $fileSizeBytes')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ChannelsTable channels = $ChannelsTable(this);
  late final $EpisodesTable episodes = $EpisodesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [channels, episodes];
}

typedef $$ChannelsTableCreateCompanionBuilder = ChannelsCompanion Function({
  Value<int> id,
  required String channelId,
  required String name,
  Value<String?> thumbnailUrl,
  required int addedAt,
  Value<int> autoDownload,
  Value<int> maxEpisodes,
  Value<String> downloadMode,
});
typedef $$ChannelsTableUpdateCompanionBuilder = ChannelsCompanion Function({
  Value<int> id,
  Value<String> channelId,
  Value<String> name,
  Value<String?> thumbnailUrl,
  Value<int> addedAt,
  Value<int> autoDownload,
  Value<int> maxEpisodes,
  Value<String> downloadMode,
});

class $$ChannelsTableFilterComposer
    extends Composer<_$AppDatabase, $ChannelsTable> {
  $$ChannelsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get channelId => $composableBuilder(
      column: $table.channelId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get thumbnailUrl => $composableBuilder(
      column: $table.thumbnailUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get addedAt => $composableBuilder(
      column: $table.addedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get autoDownload => $composableBuilder(
      column: $table.autoDownload, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get maxEpisodes => $composableBuilder(
      column: $table.maxEpisodes, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get downloadMode => $composableBuilder(
      column: $table.downloadMode, builder: (column) => ColumnFilters(column));
}

class $$ChannelsTableOrderingComposer
    extends Composer<_$AppDatabase, $ChannelsTable> {
  $$ChannelsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get channelId => $composableBuilder(
      column: $table.channelId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get thumbnailUrl => $composableBuilder(
      column: $table.thumbnailUrl,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get addedAt => $composableBuilder(
      column: $table.addedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get autoDownload => $composableBuilder(
      column: $table.autoDownload,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get maxEpisodes => $composableBuilder(
      column: $table.maxEpisodes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get downloadMode => $composableBuilder(
      column: $table.downloadMode,
      builder: (column) => ColumnOrderings(column));
}

class $$ChannelsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChannelsTable> {
  $$ChannelsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get channelId =>
      $composableBuilder(column: $table.channelId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get thumbnailUrl => $composableBuilder(
      column: $table.thumbnailUrl, builder: (column) => column);

  GeneratedColumn<int> get addedAt =>
      $composableBuilder(column: $table.addedAt, builder: (column) => column);

  GeneratedColumn<int> get autoDownload => $composableBuilder(
      column: $table.autoDownload, builder: (column) => column);

  GeneratedColumn<int> get maxEpisodes => $composableBuilder(
      column: $table.maxEpisodes, builder: (column) => column);

  GeneratedColumn<String> get downloadMode => $composableBuilder(
      column: $table.downloadMode, builder: (column) => column);
}

class $$ChannelsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ChannelsTable,
    Channel,
    $$ChannelsTableFilterComposer,
    $$ChannelsTableOrderingComposer,
    $$ChannelsTableAnnotationComposer,
    $$ChannelsTableCreateCompanionBuilder,
    $$ChannelsTableUpdateCompanionBuilder,
    (Channel, BaseReferences<_$AppDatabase, $ChannelsTable, Channel>),
    Channel,
    PrefetchHooks Function()> {
  $$ChannelsTableTableManager(_$AppDatabase db, $ChannelsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChannelsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChannelsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChannelsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> channelId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> thumbnailUrl = const Value.absent(),
            Value<int> addedAt = const Value.absent(),
            Value<int> autoDownload = const Value.absent(),
            Value<int> maxEpisodes = const Value.absent(),
            Value<String> downloadMode = const Value.absent(),
          }) =>
              ChannelsCompanion(
            id: id,
            channelId: channelId,
            name: name,
            thumbnailUrl: thumbnailUrl,
            addedAt: addedAt,
            autoDownload: autoDownload,
            maxEpisodes: maxEpisodes,
            downloadMode: downloadMode,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String channelId,
            required String name,
            Value<String?> thumbnailUrl = const Value.absent(),
            required int addedAt,
            Value<int> autoDownload = const Value.absent(),
            Value<int> maxEpisodes = const Value.absent(),
            Value<String> downloadMode = const Value.absent(),
          }) =>
              ChannelsCompanion.insert(
            id: id,
            channelId: channelId,
            name: name,
            thumbnailUrl: thumbnailUrl,
            addedAt: addedAt,
            autoDownload: autoDownload,
            maxEpisodes: maxEpisodes,
            downloadMode: downloadMode,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ChannelsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ChannelsTable,
    Channel,
    $$ChannelsTableFilterComposer,
    $$ChannelsTableOrderingComposer,
    $$ChannelsTableAnnotationComposer,
    $$ChannelsTableCreateCompanionBuilder,
    $$ChannelsTableUpdateCompanionBuilder,
    (Channel, BaseReferences<_$AppDatabase, $ChannelsTable, Channel>),
    Channel,
    PrefetchHooks Function()>;
typedef $$EpisodesTableCreateCompanionBuilder = EpisodesCompanion Function({
  Value<int> id,
  required String videoId,
  required String channelId,
  required String title,
  Value<String?> thumbnailUrl,
  Value<int?> durationSec,
  Value<int?> publishedAt,
  Value<String?> audioPath,
  Value<String?> videoPath,
  Value<String> downloadMode,
  Value<int?> downloadedAt,
  Value<int> playbackPositionSec,
  Value<int> isPlayed,
  Value<int?> fileSizeBytes,
});
typedef $$EpisodesTableUpdateCompanionBuilder = EpisodesCompanion Function({
  Value<int> id,
  Value<String> videoId,
  Value<String> channelId,
  Value<String> title,
  Value<String?> thumbnailUrl,
  Value<int?> durationSec,
  Value<int?> publishedAt,
  Value<String?> audioPath,
  Value<String?> videoPath,
  Value<String> downloadMode,
  Value<int?> downloadedAt,
  Value<int> playbackPositionSec,
  Value<int> isPlayed,
  Value<int?> fileSizeBytes,
});

class $$EpisodesTableFilterComposer
    extends Composer<_$AppDatabase, $EpisodesTable> {
  $$EpisodesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get videoId => $composableBuilder(
      column: $table.videoId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get channelId => $composableBuilder(
      column: $table.channelId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get thumbnailUrl => $composableBuilder(
      column: $table.thumbnailUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get durationSec => $composableBuilder(
      column: $table.durationSec, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get publishedAt => $composableBuilder(
      column: $table.publishedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get audioPath => $composableBuilder(
      column: $table.audioPath, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get videoPath => $composableBuilder(
      column: $table.videoPath, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get downloadMode => $composableBuilder(
      column: $table.downloadMode, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get downloadedAt => $composableBuilder(
      column: $table.downloadedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get playbackPositionSec => $composableBuilder(
      column: $table.playbackPositionSec,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get isPlayed => $composableBuilder(
      column: $table.isPlayed, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get fileSizeBytes => $composableBuilder(
      column: $table.fileSizeBytes, builder: (column) => ColumnFilters(column));
}

class $$EpisodesTableOrderingComposer
    extends Composer<_$AppDatabase, $EpisodesTable> {
  $$EpisodesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get videoId => $composableBuilder(
      column: $table.videoId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get channelId => $composableBuilder(
      column: $table.channelId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get thumbnailUrl => $composableBuilder(
      column: $table.thumbnailUrl,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get durationSec => $composableBuilder(
      column: $table.durationSec, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get publishedAt => $composableBuilder(
      column: $table.publishedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get audioPath => $composableBuilder(
      column: $table.audioPath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get videoPath => $composableBuilder(
      column: $table.videoPath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get downloadMode => $composableBuilder(
      column: $table.downloadMode,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get downloadedAt => $composableBuilder(
      column: $table.downloadedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get playbackPositionSec => $composableBuilder(
      column: $table.playbackPositionSec,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get isPlayed => $composableBuilder(
      column: $table.isPlayed, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get fileSizeBytes => $composableBuilder(
      column: $table.fileSizeBytes,
      builder: (column) => ColumnOrderings(column));
}

class $$EpisodesTableAnnotationComposer
    extends Composer<_$AppDatabase, $EpisodesTable> {
  $$EpisodesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get videoId =>
      $composableBuilder(column: $table.videoId, builder: (column) => column);

  GeneratedColumn<String> get channelId =>
      $composableBuilder(column: $table.channelId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get thumbnailUrl => $composableBuilder(
      column: $table.thumbnailUrl, builder: (column) => column);

  GeneratedColumn<int> get durationSec => $composableBuilder(
      column: $table.durationSec, builder: (column) => column);

  GeneratedColumn<int> get publishedAt => $composableBuilder(
      column: $table.publishedAt, builder: (column) => column);

  GeneratedColumn<String> get audioPath =>
      $composableBuilder(column: $table.audioPath, builder: (column) => column);

  GeneratedColumn<String> get videoPath =>
      $composableBuilder(column: $table.videoPath, builder: (column) => column);

  GeneratedColumn<String> get downloadMode => $composableBuilder(
      column: $table.downloadMode, builder: (column) => column);

  GeneratedColumn<int> get downloadedAt => $composableBuilder(
      column: $table.downloadedAt, builder: (column) => column);

  GeneratedColumn<int> get playbackPositionSec => $composableBuilder(
      column: $table.playbackPositionSec, builder: (column) => column);

  GeneratedColumn<int> get isPlayed =>
      $composableBuilder(column: $table.isPlayed, builder: (column) => column);

  GeneratedColumn<int> get fileSizeBytes => $composableBuilder(
      column: $table.fileSizeBytes, builder: (column) => column);
}

class $$EpisodesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $EpisodesTable,
    Episode,
    $$EpisodesTableFilterComposer,
    $$EpisodesTableOrderingComposer,
    $$EpisodesTableAnnotationComposer,
    $$EpisodesTableCreateCompanionBuilder,
    $$EpisodesTableUpdateCompanionBuilder,
    (Episode, BaseReferences<_$AppDatabase, $EpisodesTable, Episode>),
    Episode,
    PrefetchHooks Function()> {
  $$EpisodesTableTableManager(_$AppDatabase db, $EpisodesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EpisodesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EpisodesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EpisodesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> videoId = const Value.absent(),
            Value<String> channelId = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String?> thumbnailUrl = const Value.absent(),
            Value<int?> durationSec = const Value.absent(),
            Value<int?> publishedAt = const Value.absent(),
            Value<String?> audioPath = const Value.absent(),
            Value<String?> videoPath = const Value.absent(),
            Value<String> downloadMode = const Value.absent(),
            Value<int?> downloadedAt = const Value.absent(),
            Value<int> playbackPositionSec = const Value.absent(),
            Value<int> isPlayed = const Value.absent(),
            Value<int?> fileSizeBytes = const Value.absent(),
          }) =>
              EpisodesCompanion(
            id: id,
            videoId: videoId,
            channelId: channelId,
            title: title,
            thumbnailUrl: thumbnailUrl,
            durationSec: durationSec,
            publishedAt: publishedAt,
            audioPath: audioPath,
            videoPath: videoPath,
            downloadMode: downloadMode,
            downloadedAt: downloadedAt,
            playbackPositionSec: playbackPositionSec,
            isPlayed: isPlayed,
            fileSizeBytes: fileSizeBytes,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String videoId,
            required String channelId,
            required String title,
            Value<String?> thumbnailUrl = const Value.absent(),
            Value<int?> durationSec = const Value.absent(),
            Value<int?> publishedAt = const Value.absent(),
            Value<String?> audioPath = const Value.absent(),
            Value<String?> videoPath = const Value.absent(),
            Value<String> downloadMode = const Value.absent(),
            Value<int?> downloadedAt = const Value.absent(),
            Value<int> playbackPositionSec = const Value.absent(),
            Value<int> isPlayed = const Value.absent(),
            Value<int?> fileSizeBytes = const Value.absent(),
          }) =>
              EpisodesCompanion.insert(
            id: id,
            videoId: videoId,
            channelId: channelId,
            title: title,
            thumbnailUrl: thumbnailUrl,
            durationSec: durationSec,
            publishedAt: publishedAt,
            audioPath: audioPath,
            videoPath: videoPath,
            downloadMode: downloadMode,
            downloadedAt: downloadedAt,
            playbackPositionSec: playbackPositionSec,
            isPlayed: isPlayed,
            fileSizeBytes: fileSizeBytes,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$EpisodesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $EpisodesTable,
    Episode,
    $$EpisodesTableFilterComposer,
    $$EpisodesTableOrderingComposer,
    $$EpisodesTableAnnotationComposer,
    $$EpisodesTableCreateCompanionBuilder,
    $$EpisodesTableUpdateCompanionBuilder,
    (Episode, BaseReferences<_$AppDatabase, $EpisodesTable, Episode>),
    Episode,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ChannelsTableTableManager get channels =>
      $$ChannelsTableTableManager(_db, _db.channels);
  $$EpisodesTableTableManager get episodes =>
      $$EpisodesTableTableManager(_db, _db.episodes);
}
