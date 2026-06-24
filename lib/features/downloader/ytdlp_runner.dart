import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart' as p;
import '../../core/utils/file_utils.dart';

class DownloadResult {
  final bool success;
  final String? filePath;
  final int? fileSizeBytes;
  final String? error;
  final String? stderr;

  DownloadResult({
    required this.success,
    this.filePath,
    this.fileSizeBytes,
    this.error,
    this.stderr,
  });
}

class VideoMetadata {
  final String videoId;
  final String title;
  final String? thumbnailUrl;
  final int? durationSec;
  final int? publishedAtMs;

  VideoMetadata({
    required this.videoId,
    required this.title,
    this.thumbnailUrl,
    this.durationSec,
    this.publishedAtMs,
  });
}

class YtDlpRunner {
  Future<void> initialize() async {
    try {
      final ytDlpPath = await FileUtils.getYtDlpPath();
      final file = File(ytDlpPath);
      
      if (await file.exists() && await file.length() > 0) {
        debugPrint('yt-dlp binary already exists at: $ytDlpPath');
        return;
      }

      debugPrint('Copying yt-dlp binary from assets to: $ytDlpPath');
      final byteData = await rootBundle.load('assets/binaries/yt-dlp');
      await file.writeAsBytes(
        byteData.buffer.asUint8List(
          byteData.offsetInBytes,
          byteData.lengthInBytes,
        ),
        flush: true,
      );

      debugPrint('Applying executable permissions to: $ytDlpPath');
      final result = await Process.run('chmod', ['+x', ytDlpPath]);
      if (result.exitCode != 0) {
        debugPrint('Failed to chmod +x: ${result.stderr}');
      } else {
        debugPrint('chmod +x successful');
      }
    } catch (e) {
      debugPrint('Error initializing yt-dlp: $e');
    }
  }

  Future<DownloadResult> downloadAudio({
    required String videoId,
    required String outputDir,
  }) async {
    try {
      final ytDlpPath = await FileUtils.getYtDlpPath();
      final videoUrl = 'https://www.youtube.com/watch?v=$videoId';
      
      debugPrint('Starting audio download for $videoId using $ytDlpPath');
      
      final result = await Process.run(
        ytDlpPath,
        [
          '-f', 'bestaudio',
          '-x',
          '--audio-format', 'opus',
          '--no-playlist',
          '--no-warnings',
          '-o', p.join(outputDir, '$videoId.%(ext)s'),
          videoUrl,
        ],
      );

      if (result.exitCode == 0) {
        final expectedPath = p.join(outputDir, '$videoId.opus');
        final file = File(expectedPath);
        if (await file.exists()) {
          final size = await file.length();
          debugPrint('Audio download success: $expectedPath ($size bytes)');
          return DownloadResult(
            success: true,
            filePath: expectedPath,
            fileSizeBytes: size,
          );
        } else {
          final dir = Directory(outputDir);
          final files = dir.listSync();
          for (final f in files) {
            if (f is File && p.basename(f.path).startsWith(videoId)) {
              final size = await f.length();
              debugPrint('Audio download success (fallback search): ${f.path}');
              return DownloadResult(
                success: true,
                filePath: f.path,
                fileSizeBytes: size,
              );
            }
          }
          return DownloadResult(
            success: false,
            error: 'Expected file not found in output directory',
            stderr: result.stderr.toString(),
          );
        }
      } else {
        debugPrint('yt-dlp process returned exit code ${result.exitCode}');
        debugPrint('stderr: ${result.stderr}');
        debugPrint('stdout: ${result.stdout}');
        return DownloadResult(
          success: false,
          error: 'yt-dlp exit code ${result.exitCode}',
          stderr: result.stderr.toString(),
        );
      }
    } catch (e) {
      debugPrint('Exception in downloadAudio: $e');
      return DownloadResult(
        success: false,
        error: e.toString(),
      );
    }
  }

  Future<DownloadResult> downloadVideo480p({
    required String videoId,
    required String outputDir,
  }) async {
    try {
      final ytDlpPath = await FileUtils.getYtDlpPath();
      final videoUrl = 'https://www.youtube.com/watch?v=$videoId';
      
      debugPrint('Starting 480p video download for $videoId');
      
      final result = await Process.run(
        ytDlpPath,
        [
          '-f', 'best[height<=480]',
          '--no-playlist',
          '--no-warnings',
          '-o', p.join(outputDir, '$videoId.%(ext)s'),
          videoUrl,
        ],
      );

      if (result.exitCode == 0) {
        final dir = Directory(outputDir);
        final files = dir.listSync();
        for (final f in files) {
          if (f is File && p.basename(f.path).startsWith(videoId)) {
            final size = await f.length();
            debugPrint('Video download success: ${f.path} ($size bytes)');
            return DownloadResult(
              success: true,
              filePath: f.path,
              fileSizeBytes: size,
            );
          }
        }
        return DownloadResult(
          success: false,
          error: 'Video file not found after successful download',
          stderr: result.stderr.toString(),
        );
      } else {
        debugPrint('yt-dlp video download failed. exit: ${result.exitCode}, stderr: ${result.stderr}');
        return DownloadResult(
          success: false,
          error: 'yt-dlp exit code ${result.exitCode}',
          stderr: result.stderr.toString(),
        );
      }
    } catch (e) {
      debugPrint('Exception in downloadVideo480p: $e');
      return DownloadResult(
        success: false,
        error: e.toString(),
      );
    }
  }

  Future<List<VideoMetadata>> fetchChannelVideos({
    required String channelUrl,
    int count = 15,
  }) async {
    try {
      final ytDlpPath = await FileUtils.getYtDlpPath();
      debugPrint('Fetching videos for channel: $channelUrl (count: $count)');
      
      final result = await Process.run(
        ytDlpPath,
        [
          '--flat-playlist',
          '--playlist-items', '1:$count',
          '--dump-json',
          '--no-warnings',
          channelUrl,
        ],
      );

      if (result.exitCode != 0) {
        debugPrint('yt-dlp fetchChannelVideos failed. exit: ${result.exitCode}, stderr: ${result.stderr}');
        return [];
      }

      final lines = result.stdout.toString().split('\n');
      final List<VideoMetadata> list = [];
      
      for (final line in lines) {
        if (line.trim().isEmpty) continue;
        try {
          final map = jsonDecode(line) as Map<String, dynamic>;
          final id = map['id'] as String?;
          final title = map['title'] as String?;
          if (id != null && title != null) {
            final thumbnail = map['thumbnail'] as String? ?? 
                              (map['thumbnails'] is List && (map['thumbnails'] as List).isNotEmpty
                               ? (map['thumbnails'] as List).last['url'] as String?
                               : null);
            final durationSec = map['duration'] != null ? (map['duration'] as num).toInt() : null;
            final uploadDate = map['upload_date'] as String?;
            
            list.add(VideoMetadata(
              videoId: id,
              title: title,
              thumbnailUrl: thumbnail,
              durationSec: durationSec,
              publishedAtMs: _parseUploadDate(uploadDate),
            ));
          }
        } catch (e) {
          debugPrint('Error parsing video metadata line: $e');
        }
      }
      return list;
    } catch (e) {
      debugPrint('Exception in fetchChannelVideos: $e');
      return [];
    }
  }

  Future<String?> resolveChannelId(String handleOrUrl) async {
    try {
      final ytDlpPath = await FileUtils.getYtDlpPath();
      debugPrint('Resolving channel URL/handle: $handleOrUrl');
      
      final result = await Process.run(
        ytDlpPath,
        [
          '--flat-playlist',
          '--playlist-items', '0',
          '--dump-json',
          '--no-warnings',
          handleOrUrl,
        ],
      );

      if (result.exitCode != 0) {
        debugPrint('yt-dlp resolveChannelId failed. exit: ${result.exitCode}, stderr: ${result.stderr}');
        return null;
      }

      final output = result.stdout.toString().trim();
      if (output.isEmpty) return null;
      
      final map = jsonDecode(output) as Map<String, dynamic>;
      final channelId = map['channel_id'] as String? ?? map['id'] as String?;
      if (channelId != null && channelId.startsWith('UC')) {
        return channelId;
      }
      
      return null;
    } catch (e) {
      debugPrint('Exception in resolveChannelId: $e');
      return null;
    }
  }

  int? _parseUploadDate(String? uploadDate) {
    if (uploadDate == null || uploadDate.length != 8) return null;
    try {
      final year = int.parse(uploadDate.substring(0, 4));
      final month = int.parse(uploadDate.substring(4, 6));
      final day = int.parse(uploadDate.substring(6, 8));
      return DateTime(year, month, day).millisecondsSinceEpoch;
    } catch (_) {
      return null;
    }
  }
}
