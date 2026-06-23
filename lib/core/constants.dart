class AppConstants {
  // yt-dlp
  static const String ytDlpAssetPath = 'assets/binaries/yt-dlp';
  static const String ytDlpFileName = 'yt-dlp';
  
  // 다운로드 설정
  static const String defaultAudioFormat = 'opus';
  static const int maxVideoHeight = 480;
  
  // 자동 다운로드
  static const int autoDownloadIntervalMinutes = 15;
  static const int defaultMaxEpisodes = 10;
  
  // 재생
  static const List<double> playbackSpeeds = [0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0, 2.5, 3.0];
  static const double defaultPlaybackSpeed = 1.0;
  static const int positionSaveIntervalSeconds = 30;
  static const double completionThresholdPercent = 0.95; // 95% 재생 시 완료 처리
  
  // WorkManager
  static const String downloadWorkName = 'offcast_auto_download';
  static const String downloadWorkTag = 'offcast_download';
}
