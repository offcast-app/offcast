import 'package:flutter/material.dart';
import 'ytdlp_runner.dart';
import '../../core/utils/file_utils.dart';

class YtDlpTestScreen extends StatefulWidget {
  const YtDlpTestScreen({super.key});

  @override
  State<YtDlpTestScreen> createState() => _YtDlpTestScreenState();
}

class _YtDlpTestScreenState extends State<YtDlpTestScreen> {
  final YtDlpRunner _runner = YtDlpRunner();
  final List<String> _logs = [];
  bool _isLoading = false;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _initYtDlp();
  }

  void _log(String message) {
    setState(() {
      _logs.add('[${DateTime.now().toIso8601String().substring(11, 19)}] $message');
    });
  }

  Future<void> _initYtDlp() async {
    setState(() => _isLoading = true);
    _log('Initializing yt-dlp binary...');
    try {
      await _runner.initialize();
      setState(() => _initialized = true);
      _log('yt-dlp initialized successfully.');
    } catch (e) {
      _log('Error initializing yt-dlp: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _testAudioDownload() async {
    if (!_initialized) return;
    setState(() => _isLoading = true);
    const videoId = 'dQw4w9WgXcQ';
    _log('Starting audio download test for videoId: $videoId');
    try {
      final outputDir = await FileUtils.getAudioDir();
      _log('Output directory: $outputDir');
      
      final result = await _runner.downloadAudio(
        videoId: videoId,
        outputDir: outputDir,
      );

      if (result.success) {
        _log('SUCCESS: Audio downloaded.');
        _log('Path: ${result.filePath}');
        _log('Size: ${FileUtils.formatFileSize(result.fileSizeBytes ?? 0)}');
      } else {
        _log('FAILED: ${result.error}');
        if (result.stderr != null) {
          _log('Stderr: ${result.stderr}');
        }
      }
    } catch (e) {
      _log('Exception during audio download test: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _testVideoDownload() async {
    if (!_initialized) return;
    setState(() => _isLoading = true);
    const videoId = 'dQw4w9WgXcQ';
    _log('Starting 480p video download test for videoId: $videoId');
    try {
      final outputDir = await FileUtils.getVideoDir();
      _log('Output directory: $outputDir');
      
      final result = await _runner.downloadVideo480p(
        videoId: videoId,
        outputDir: outputDir,
      );

      if (result.success) {
        _log('SUCCESS: Video downloaded.');
        _log('Path: ${result.filePath}');
        _log('Size: ${FileUtils.formatFileSize(result.fileSizeBytes ?? 0)}');
      } else {
        _log('FAILED: ${result.error}');
        if (result.stderr != null) {
          _log('Stderr: ${result.stderr}');
        }
      }
    } catch (e) {
      _log('Exception during video download test: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _testFetchMetadata() async {
    if (!_initialized) return;
    setState(() => _isLoading = true);
    const channelUrl = 'https://www.youtube.com/@lexfridman';
    _log('Starting metadata fetch test for channel: $channelUrl');
    try {
      final videos = await _runner.fetchChannelVideos(
        channelUrl: channelUrl,
        count: 5,
      );

      if (videos.isNotEmpty) {
        _log('SUCCESS: Fetched ${videos.length} videos.');
        for (var i = 0; i < videos.length; i++) {
          final v = videos[i];
          final duration = FileUtils.formatDuration(v.durationSec ?? 0);
          _log('[$i] ID: ${v.videoId} | Duration: $duration | Title: ${v.title}');
        }
      } else {
        _log('FAILED: No videos fetched or error occurred.');
      }
    } catch (e) {
      _log('Exception during metadata fetch test: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _testResolveChannelId() async {
    if (!_initialized) return;
    setState(() => _isLoading = true);
    const handle = 'https://www.youtube.com/@lexfridman';
    _log('Resolving channel ID for: $handle');
    try {
      final channelId = await _runner.resolveChannelId(handle);
      if (channelId != null) {
        _log('SUCCESS: Resolved Channel ID = $channelId');
      } else {
        _log('FAILED: Could not resolve channel ID.');
      }
    } catch (e) {
      _log('Exception during resolveChannelId test: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('yt-dlp Runner Test'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _initYtDlp,
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              if (_isLoading)
                const LinearProgressIndicator()
              else
                const SizedBox(height: 4),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ElevatedButton.icon(
                    onPressed: _isLoading || !_initialized ? null : _testAudioDownload,
                    icon: const Icon(Icons.audiotrack),
                    label: const Text('Audio Download'),
                  ),
                  ElevatedButton.icon(
                    onPressed: _isLoading || !_initialized ? null : _testVideoDownload,
                    icon: const Icon(Icons.video_library),
                    label: const Text('480p Video Download'),
                  ),
                  ElevatedButton.icon(
                    onPressed: _isLoading || !_initialized ? null : _testFetchMetadata,
                    icon: const Icon(Icons.list),
                    label: const Text('Fetch Metadata'),
                  ),
                  ElevatedButton.icon(
                    onPressed: _isLoading || !_initialized ? null : _testResolveChannelId,
                    icon: const Icon(Icons.person),
                    label: const Text('Resolve Channel ID'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Logs:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: _logs.isEmpty
                      ? const Center(child: Text('No logs yet.'))
                      : ListView.builder(
                          itemCount: _logs.length,
                          reverse: true,
                          itemBuilder: (context, index) {
                            final logItem = _logs[_logs.length - 1 - index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2.0),
                              child: Text(
                                logItem,
                                style: const TextStyle(
                                  fontFamily: 'Courier',
                                  fontSize: 12,
                                  color: Colors.lightGreenAccent,
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
