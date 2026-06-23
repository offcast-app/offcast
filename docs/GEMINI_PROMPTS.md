# Offcast — Gemini 복붙 프롬프트 모음
> 각 Phase 시작 시 해당 섹션의 프롬프트를 **그대로** Gemini에 복붙하세요.
> GEMINI_GUIDE.md와 CODING_SPEC.md를 대화에 첨부하면 더욱 좋습니다.

---

## ✅ 사전 준비 체크

프롬프트 사용 전 반드시 확인:
- [ ] Flutter 설치 완료 (`flutter --version` 동작)
- [ ] `c:\Dev\Offcast\assets\binaries\yt-dlp` 파일 존재 (ARM64 바이너리)
- [ ] Android 기기 또는 에뮬레이터 연결 (`flutter devices` 확인)

---

---

## 🟦 PHASE 0: Flutter 프로젝트 생성 (코딩 최초 1회)

> 터미널에서 직접 실행하는 명령어입니다. Gemini에 붙여넣지 않고, 터미널에서 실행하세요.

```powershell
# c:\Dev\Offcast 폴더에서 실행
flutter create --org com.offcast --project-name offcast --platforms android .

# 의존성 설치
flutter pub get

# 확인
flutter analyze
```

완료 후 → Phase 1 프롬프트로 이동

---

---

## 🟩 PHASE 1 프롬프트: 프로젝트 초기 세팅 + DB

> 아래 내용을 전체 복사해서 Gemini에 붙여넣으세요.

---

```
당신은 Flutter/Dart 전문 시니어 Android 개발자입니다.
우리는 "Offcast"라는 오픈소스 Android 앱을 개발 중입니다.

## 앱 설명
YouTube 채널을 팟캐스트처럼 구독하고, 와이파이 환경에서 자동 다운로드하여 오프라인으로 청취하는 Android 앱.

## 기술 스택
- Flutter (stable)
- Drift (SQLite ORM)
- Riverpod (상태관리)
- go_router (네비게이션)
- just_audio + audio_service (오디오)
- workmanager (백그라운드)

## 코딩 원칙
- Clean Architecture (data/domain/presentation 레이어 분리)
- 파일당 300줄 이하
- print() 사용 금지 → debugPrint() 사용
- 모든 async 함수에 에러 처리 (try-catch)
- const 위젯 최대한 활용
- 완성 코드만 제공 (설명 최소화)

## 지금 구현할 항목 (Phase 1)

다음 파일들의 **완성 코드**를 순서대로 제공해주세요.

### 1. pubspec.yaml
아래 dependencies 포함:
- just_audio: ^0.9.40
- audio_service: ^0.18.15
- workmanager: ^0.5.2
- connectivity_plus: ^6.0.5
- http: ^1.2.2
- xml: ^6.5.0
- drift: ^2.21.0
- drift_flutter: ^0.2.2
- sqlite3_flutter_libs: ^0.5.0
- path_provider: ^2.1.4
- path: ^1.9.0
- receive_sharing_intent: ^1.8.0
- video_player: ^2.9.2
- flutter_riverpod: ^2.5.1
- riverpod_annotation: ^2.3.5
- go_router: ^14.3.0
- intl: ^0.19.0
- cached_network_image: ^3.4.1

dev_dependencies:
- build_runner: ^2.4.12
- drift_dev: ^2.21.0
- riverpod_generator: ^2.4.3

assets:
- assets/binaries/yt-dlp

### 2. lib/core/constants.dart
```dart
class AppConstants {
  // yt-dlp
  static const ytDlpAssetPath = 'assets/binaries/yt-dlp';
  static const ytDlpFileName = 'yt-dlp';
  
  // 다운로드 설정
  static const defaultAudioFormat = 'opus';
  static const maxVideoHeight = 480;
  
  // 자동 다운로드
  static const autoDownloadIntervalMinutes = 15;
  static const defaultMaxEpisodes = 10;
  
  // 재생
  static const playbackSpeeds = [0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0, 2.5, 3.0];
  static const defaultPlaybackSpeed = 1.0;
  static const positionSaveIntervalSeconds = 30;
  static const completionThresholdPercent = 0.95; // 95% 재생 시 완료 처리
  
  // WorkManager
  static const downloadWorkName = 'offcast_auto_download';
  static const downloadWorkTag = 'offcast_download';
}
```

### 3. lib/core/database/tables/channels_table.dart
Drift 테이블 정의. 컬럼:
- id: INTEGER PK AUTOINCREMENT
- channelId: TEXT NOT NULL UNIQUE (YouTube channel ID, UCxxxxxx)
- name: TEXT NOT NULL
- thumbnailUrl: TEXT nullable
- addedAt: INTEGER NOT NULL (Unix timestamp ms)
- autoDownload: INTEGER NOT NULL DEFAULT 1 (0 or 1)
- maxEpisodes: INTEGER NOT NULL DEFAULT 10
- downloadMode: TEXT NOT NULL DEFAULT 'audio' ('audio' or 'video_480p')

### 4. lib/core/database/tables/episodes_table.dart
Drift 테이블 정의. 컬럼:
- id: INTEGER PK AUTOINCREMENT
- videoId: TEXT NOT NULL UNIQUE (YouTube video ID)
- channelId: TEXT NOT NULL
- title: TEXT NOT NULL
- thumbnailUrl: TEXT nullable
- durationSec: INTEGER nullable
- publishedAt: INTEGER nullable (Unix timestamp ms)
- audioPath: TEXT nullable (오디오 파일 경로)
- videoPath: TEXT nullable (480p 영상 파일 경로)
- downloadMode: TEXT NOT NULL DEFAULT 'none' ('none', 'audio', 'video_480p')
- downloadedAt: INTEGER nullable
- playbackPositionSec: INTEGER NOT NULL DEFAULT 0
- isPlayed: INTEGER NOT NULL DEFAULT 0 (0 or 1)
- fileSizeBytes: INTEGER nullable

### 5. lib/core/database/app_database.dart
Drift AppDatabase 설정.
- 위 두 테이블 포함
- schemaVersion: 1
- MigrationStrategy: onUpgrade에서 개발 중엔 destructiveMigration() 사용
- 싱글톤 패턴으로 인스턴스 제공

### 6. lib/main.dart
- ProviderScope로 앱 감싸기
- 앱 시작 시 AppDatabase 초기화
- runApp() 호출

### 7. lib/app.dart
- MaterialApp.router 사용
- go_router 설정 (임시로 빈 화면 라우트만)
- ThemeData: Material 3, 다크 테마 기본
  - colorSchemeSeed: Color(0xFF1DB954) (Spotify 그린과 유사한 포드캐스트 느낌)
  - brightness: Brightness.dark
- 앱 이름: 'Offcast'

### 8. build_runner 실행 명령어
코드 완성 후 실행할 명령어 알려주기:
flutter pub run build_runner build --delete-conflicting-outputs

각 파일의 완성된 전체 코드를 제공해주세요.
```

---

### Phase 1 완료 확인 (터미널에서 실행)

```powershell
flutter pub run build_runner build --delete-conflicting-outputs
flutter analyze
flutter run
```

→ 앱이 실행되면 Phase 2로 이동

---

---

## 🟨 PHASE 2 프롬프트: yt-dlp 바이너리 연동

> 아래 내용을 전체 복사해서 Gemini에 붙여넣으세요.

---

```
당신은 Flutter/Dart 전문 시니어 Android 개발자입니다.
Offcast 앱의 Phase 2를 구현합니다.

## 앱 정보
- YouTube 채널을 팟캐스트처럼 구독/자동다운로드/오프라인 청취하는 Android 앱
- 패키지명: com.offcast.app

## Phase 2 목표
yt-dlp ARM64 바이너리(assets/binaries/yt-dlp)를 앱 내부 저장소에 복사하고,
Dart Process.run()으로 실행하여 오디오 다운로드 및 채널 메타데이터 수집

## 핵심 전제
- yt-dlp는 assets에 번들되어 있음
- 오디오: yt-dlp -f bestaudio -x --audio-format opus (ffmpeg 불필요)
- 480p: yt-dlp -f "best[height<=480]" (ffmpeg 불필요)
- 두 모드 모두 ffmpeg 없이 단일 스트림 다운로드

## 코딩 원칙
- Clean Architecture
- 파일당 300줄 이하
- print() 금지 → debugPrint()
- 모든 async에 try-catch
- 완성 코드만 제공

## 구현할 파일들

### 1. lib/features/downloader/ytdlp_runner.dart

다음 클래스/메서드 구현:

**모델 클래스 (같은 파일에 포함)**:
```
class DownloadResult {
  final bool success;
  final String? filePath;
  final int? fileSizeBytes;
  final String? error;
  final String? stderr;
}

class VideoMetadata {
  final String videoId;
  final String title;
  final String? thumbnailUrl;
  final int? durationSec;
  final int? publishedAtMs;  // Unix timestamp ms
}
```

**YtDlpRunner 클래스**:

1. `Future<void> initialize()`
   - assets/binaries/yt-dlp → 앱 내부 저장소 복사
   - chmod +x 실행
   - 이미 복사된 경우 스킵

2. `Future<DownloadResult> downloadAudio({required String videoId, required String outputDir})`
   - 명령: yt-dlp -f bestaudio -x --audio-format opus --no-playlist --no-warnings -o "{outputDir}/{videoId}.%(ext)s" "https://www.youtube.com/watch?v={videoId}"
   - 결과 파일 경로와 크기 반환

3. `Future<DownloadResult> downloadVideo480p({required String videoId, required String outputDir})`
   - 명령: yt-dlp -f "best[height<=480]" --no-playlist --no-warnings -o "{outputDir}/{videoId}.%(ext)s" "..."
   - 결과 파일 경로와 크기 반환

4. `Future<List<VideoMetadata>> fetchChannelVideos({required String channelUrl, int count = 15})`
   - 명령: yt-dlp --flat-playlist --playlist-items 1:{count} --dump-json --no-warnings "{channelUrl}"
   - 출력이 newline-delimited JSON임 → 각 줄 파싱
   - 파싱 필드: id, title, duration, thumbnail, upload_date (yyyyMMdd → ms 변환)

5. `Future<String?> resolveChannelId(String handleOrUrl)`
   - @handle 또는 /c/name URL을 채널 ID(UCxxxxxx)로 변환
   - yt-dlp --flat-playlist --playlist-items 0 --dump-json 사용

### 2. lib/core/utils/file_utils.dart

```
class FileUtils {
  // 오디오 파일 저장 디렉토리 경로 반환 (없으면 생성)
  static Future<String> getAudioDir() async
  
  // 영상 파일 저장 디렉토리 경로 반환 (없으면 생성)
  static Future<String> getVideoDir() async
  
  // yt-dlp 바이너리 저장 경로 반환
  static Future<String> getYtDlpPath() async
  
  // 파일 크기를 사람이 읽기 쉬운 형태로 변환
  // 예: 31457280 → "30.0 MB"
  static String formatFileSize(int bytes)
  
  // 재생시간(초)을 사람이 읽기 쉬운 형태로 변환
  // 예: 3725 → "1h 2m"
  static String formatDuration(int seconds)
}
```

### 3. 테스트용 임시 코드 (lib/features/downloader/ytdlp_test_screen.dart)

간단한 테스트 화면:
- "오디오 다운로드 테스트" 버튼 → dQw4w9WgXcQ 영상 오디오 다운로드
- "480p 영상 다운로드 테스트" 버튼
- "채널 메타데이터 테스트" 버튼 → Lex Fridman 채널 (@lexfridman)
- 결과를 화면에 텍스트로 표시 (성공/실패, 파일 경로, 크기)
- 진행 중 로딩 인디케이터 표시

이 화면을 앱 시작 시 임시로 홈 화면으로 설정해주세요.

각 파일의 완성된 전체 코드를 제공해주세요.
```

---

### Phase 2 완료 확인

```powershell
flutter run
```

앱 실행 후:
1. "오디오 다운로드 테스트" 버튼 탭
2. 성공 메시지 + 파일 경로 표시되면 Phase 2 완료
3. ADB로 파일 존재 확인:
```powershell
adb shell ls /data/user/0/com.offcast.app/files/audio/
```

---

---

## 🟧 PHASE 3 프롬프트: YouTube RSS 채널 구독

> 아래 내용을 전체 복사해서 Gemini에 붙여넣으세요.

---

```
당신은 Flutter/Dart 전문 시니어 Android 개발자입니다.
Offcast 앱의 Phase 3을 구현합니다.
Phase 1(Drift DB), Phase 2(YtDlpRunner)가 완료된 상태입니다.

## 앱 정보
- YouTube 채널을 팟캐스트처럼 구독/자동다운로드/오프라인 청취하는 Android 앱
- 패키지명: com.offcast.app

## Phase 3 목표
YouTube URL로 채널을 구독하고, RSS로 최신 에피소드를 가져와 DB에 저장

## YouTube RSS 피드
URL: https://www.youtube.com/feeds/videos.xml?channel_id={CHANNEL_ID}
인증: 불필요. Atom XML 형식.
파싱 필드: yt:videoId, title, published, media:thumbnail(url 속성)
주의: 최신 15개만 반환됨

## 코딩 원칙
- Clean Architecture
- 파일당 300줄 이하
- print() 금지 → debugPrint()
- 완성 코드만 제공

## 구현할 파일들

### 1. lib/features/subscriptions/domain/channel_model.dart
```
class ChannelModel {
  final String channelId;    // UCxxxxxx
  final String name;
  final String? thumbnailUrl;
  final int addedAt;         // Unix ms
  final bool autoDownload;
  final int maxEpisodes;
  final String downloadMode; // 'audio' or 'video_480p'
}
```
copyWith 메서드, fromJson, toJson 포함

### 2. lib/features/episodes/domain/episode_model.dart
```
class EpisodeModel {
  final String videoId;
  final String channelId;
  final String title;
  final String? thumbnailUrl;
  final int? durationSec;
  final int? publishedAt;    // Unix ms
  final String? audioPath;
  final String? videoPath;
  final String downloadMode; // 'none', 'audio', 'video_480p'
  final int? downloadedAt;
  final int playbackPositionSec;
  final bool isPlayed;
  final int? fileSizeBytes;
}
```
copyWith, fromJson, toJson 포함

### 3. lib/core/utils/youtube_url_parser.dart
```
class YouTubeUrlParser {
  // URL 타입 판별
  static bool isVideoUrl(String url);        // watch?v= 또는 youtu.be/
  static bool isChannelUrl(String url);      // /channel/, /c/, /@
  
  // ID 추출
  static String? extractVideoId(String url); // watch?v=xxx 또는 youtu.be/xxx
  static String? extractChannelId(String url); // /channel/UCxxx만 직접 추출
  // /c/name 또는 /@handle은 yt-dlp 필요 → extractChannelId는 UCxxx만 반환
  
  // 채널 URL 정규화
  static String? normalizeChannelUrl(String url);
  // 입력: https://www.youtube.com/@lexfridman
  // 출력: https://www.youtube.com/@lexfridman (정리된 형태)
}
```

### 4. lib/features/subscriptions/data/channel_repository.dart
```
class ChannelRepository {
  // 채널 추가 (URL → ID 변환 → RSS 정보 가져오기 → DB 저장)
  Future<ChannelModel> addChannel(String youtubeUrl);
  
  // 채널 목록 (실시간 Stream)
  Stream<List<ChannelModel>> watchChannels();
  
  // 채널 삭제 (에피소드 파일도 삭제)
  Future<void> removeChannel(String channelId);
  
  // 채널 설정 업데이트
  Future<void> updateChannelSettings({
    required String channelId,
    bool? autoDownload,
    int? maxEpisodes,
    String? downloadMode,
  });
  
  // RSS로 채널 최신 에피소드 목록 가져오기 (DB 저장 없이)
  Future<List<EpisodeModel>> fetchLatestEpisodes(String channelId);
  
  // RSS로 채널 기본 정보 가져오기
  Future<ChannelModel> fetchChannelInfo(String channelId);
}
```

addChannel 내부 로직:
1. URL 파싱 → UCxxx면 바로 사용, @handle이면 YtDlpRunner.resolveChannelId() 호출
2. RSS로 채널 info 가져오기
3. DB에 저장
4. RSS로 최신 에피소드 목록 가져와서 episodes 테이블에 저장 (audioPath=null 상태로)

### 5. lib/features/subscriptions/presentation/subscriptions_screen.dart

화면 구성:
- AppBar: "Offcast" 제목, 설정 아이콘
- 구독 채널 없을 때: 빈 상태 UI ("+ 첫 채널을 추가해보세요")
- 채널 목록: ListView
  - 각 항목: 채널 썸네일(원형), 채널명, 미다운로드 에피소드 수
  - 롱프레스: 삭제 확인 다이얼로그
  - 탭: EpisodesScreen으로 이동 (해당 채널)
- FloatingActionButton: 채널 추가 (AddChannelScreen으로 이동)

### 6. lib/features/subscriptions/presentation/add_channel_screen.dart

화면 구성:
- AppBar: "채널 추가"
- 텍스트 입력: "YouTube URL 또는 @채널핸들 입력"
  - 지원 예시 표시: @lexfridman, youtube.com/channel/UCxxx
- "확인" 버튼 → 로딩 → 채널 정보 미리보기 표시
  - 미리보기: 채널 썸네일, 채널명
- "구독하기" 버튼 → DB 저장 → 이전 화면으로
- 에러 시 스낵바로 안내

### 7. go_router 업데이트 (lib/app.dart)
라우트 추가:
- `/` → SubscriptionsScreen
- `/episodes/:channelId` → EpisodesScreen (나중에 구현, 지금은 Placeholder)
- `/add-channel` → AddChannelScreen

각 파일의 완성된 전체 코드를 제공해주세요.
```

---

### Phase 3 완료 확인

앱 실행 후:
1. "@lexfridman" 입력 → 채널 정보 표시 확인
2. "구독하기" → 목록에 Lex Fridman 표시 확인
3. ADB로 DB 확인 (선택사항)

---

---

## 🟥 PHASE 4 프롬프트: 자동 다운로드 스케줄러

> 아래 내용을 전체 복사해서 Gemini에 붙여넣으세요.

---

```
당신은 Flutter/Dart 전문 시니어 Android 개발자입니다.
Offcast 앱의 Phase 4를 구현합니다.
Phase 1-3이 완료된 상태입니다.

## Phase 4 목표
Wi-Fi 연결 시 구독 채널의 새 에피소드를 자동으로 다운로드하고,
에피소드 목록 화면을 구현

## 코딩 원칙
- Clean Architecture
- 파일당 300줄 이하
- print() 금지 → debugPrint()
- 완성 코드만 제공

## 구현할 파일들

### 1. lib/features/episodes/data/episode_repository.dart
```
class EpisodeRepository {
  // 채널별 에피소드 목록 (실시간 Stream, publishedAt 역순)
  Stream<List<EpisodeModel>> watchEpisodesByChannel(String channelId);
  
  // 전체 에피소드 피드 (최근 다운로드순)
  Stream<List<EpisodeModel>> watchAllDownloadedEpisodes();
  
  // 재생 위치 저장
  Future<void> updatePlaybackPosition(String videoId, int positionSec);
  
  // 재생 완료 처리
  Future<void> markAsPlayed(String videoId);
  
  // 다운로드 경로 업데이트 (다운로드 완료 후 호출)
  Future<void> updateDownloadInfo({
    required String videoId,
    required String downloadMode,
    String? audioPath,
    String? videoPath,
    int? fileSizeBytes,
  });
  
  // 에피소드 삭제 (파일 + DB)
  Future<void> deleteEpisode(String videoId);
  
  // 채널의 미재생 에피소드 수
  Future<int> getUnplayedCount(String channelId);
  
  // 오래된 재생완료 에피소드 정리 (채널별 maxEpisodes 초과 시)
  Future<void> cleanupOldEpisodes(String channelId, int maxEpisodes);
}
```

### 2. lib/shared/providers/providers.dart
Riverpod providers 정의:
```
// DB
final appDatabaseProvider = Provider<AppDatabase>

// Repositories  
final channelRepositoryProvider = Provider<ChannelRepository>
final episodeRepositoryProvider = Provider<EpisodeRepository>
final ytDlpRunnerProvider = Provider<YtDlpRunner>

// 채널 목록
final channelsProvider = StreamProvider<List<ChannelModel>>

// 채널별 에피소드
final episodesByChannelProvider = StreamProvider.family<List<EpisodeModel>, String>

// 전체 다운로드된 에피소드
final allDownloadedEpisodesProvider = StreamProvider<List<EpisodeModel>>

// 다운로드 진행 상태 (videoId → progress 0.0~1.0)
final downloadProgressProvider = StateProvider<Map<String, double>>

// 현재 다운로드 중인 videoId
final currentDownloadingProvider = StateProvider<String?>
```

### 3. lib/features/downloader/download_scheduler.dart
WorkManager 기반 자동 다운로드 스케줄러

**초기화 및 등록:**
```
class DownloadScheduler {
  // WorkManager 주기적 작업 등록 (15분 간격, Wi-Fi only, 배터리 여유 시)
  static Future<void> register();
  
  // 등록 해제
  static Future<void> cancel();
  
  // WorkManager callbackDispatcher에서 호출될 함수 (static, top-level)
  static Future<bool> executeDownloadTask();
}
```

**executeDownloadTask 내부 로직:**
1. DB에서 autoDownload=true 채널 목록 가져오기
2. 각 채널 RSS 체크 → 새 에피소드 감지
3. 새 에피소드를 episodes 테이블에 추가 (downloadMode='none')
4. 다운로드 안 된 에피소드 순서대로 1개씩 다운로드
5. 채널별 maxEpisodes 초과 시 오래된 재생완료 에피소드 삭제
6. 알림: "N개 에피소드 다운로드 완료" (Android 알림)

**WorkManager main() 등록:**
```dart
// main.dart에 추가할 코드도 포함해주세요:
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    return DownloadScheduler.executeDownloadTask();
  });
}
```

### 4. lib/features/episodes/presentation/episodes_screen.dart
채널별 에피소드 목록 화면

화면 구성:
- AppBar: 채널명, 채널 썸네일 아이콘
- 에피소드 없을 때: 빈 상태 UI
- ListView: episodesByChannelProvider 사용
  - 각 항목 (EpisodeTile):
    - 썸네일 이미지 (CachedNetworkImage)
    - 에피소드 제목 (2줄까지)
    - 날짜 + 재생시간 + 파일 크기
    - 다운로드 상태 아이콘:
      - none: 다운로드 버튼 (⬇️)
      - 다운로드 중: CircularProgressIndicator + 취소 버튼
      - audio: 재생 버튼 (▶️)
      - video_480p: 재생 버튼 + 영상 아이콘
    - isPlayed=true면 전체 항목 투명도 0.5
  - 스와이프 삭제 (Dismissible)
  
- 당겨서 새로고침 (RefreshIndicator) → RSS 새로고침

### 5. lib/features/episodes/presentation/episode_tile.dart
위 에피소드 목록 항목을 별도 위젯으로 분리

각 파일의 완성된 전체 코드를 제공해주세요.
```

---

### Phase 4 완료 확인

1. 채널 탭 → 에피소드 목록 표시 확인
2. ⬇️ 버튼 탭 → 오디오 다운로드 시작, 진행률 표시 확인
3. 다운로드 완료 → ▶️ 버튼으로 변경 확인

---

---

## 🟪 PHASE 5 프롬프트: 미디어 플레이어

> 아래 내용을 전체 복사해서 Gemini에 붙여넣으세요.

---

```
당신은 Flutter/Dart 전문 시니어 Android 개발자입니다.
Offcast 앱의 Phase 5를 구현합니다.
Phase 1-4가 완료된 상태입니다.

## Phase 5 목표
팟캐스트급 오디오 플레이어 구현 (백그라운드 재생, 잠금화면 컨트롤 포함)
선택적 480p 영상 재생 지원

## 코딩 원칙
- Clean Architecture
- 파일당 300줄 이하
- print() 금지 → debugPrint()
- 완성 코드만 제공

## AndroidManifest.xml에 추가 필요한 항목
```xml
<!-- audio_service -->
<service
    android:name="com.ryanheise.audioservice.AudioService"
    android:exported="true"
    android:foregroundServiceType="mediaPlayback">
    <intent-filter>
        <action android:name="android.media.browse.MediaBrowserService"/>
    </intent-filter>
</service>
<receiver
    android:name="com.ryanheise.audioservice.MediaButtonReceiver"
    android:exported="true">
    <intent-filter>
        <action android:name="android.intent.action.MEDIA_BUTTON"/>
    </intent-filter>
</receiver>
```

## 구현할 파일들

### 1. lib/features/player/data/audio_handler.dart
OffcastAudioHandler extends BaseAudioHandler

기능:
- just_audio AudioPlayer 내부 사용
- loadEpisode(EpisodeModel): 에피소드 로드 (audioPath 사용)
- play(), pause(), stop(), seek()
- skipToPrevious(), skipToNext() (이전/다음 에피소드)
- setSpeed(double speed): 배속 조절
- setSleepTimer(Duration? duration): 슬립 타이머
- 재생 위치를 30초마다 DB에 자동 저장 (Timer.periodic)
- 재생 완료 시 (95% 이상) isPlayed = true 처리
- MediaItem 업데이트 (제목, 채널명, 썸네일 URL)
- 오디오 포커스 처리 (전화 수신 시 일시정지, 다른 앱 재생 시 볼륨 감소)

### 2. lib/shared/providers/player_providers.dart
플레이어 관련 providers:
```
// AudioHandler 싱글톤
final audioHandlerProvider = Provider<OffcastAudioHandler>

// 현재 재생 중인 에피소드
final currentEpisodeProvider = StateProvider<EpisodeModel?>

// 재생 상태 (playing/paused/stopped)
final playbackStateProvider = StreamProvider<PlaybackState>

// 현재 재생 위치
final positionProvider = StreamProvider<Duration>

// 전체 재생시간
final durationProvider = StreamProvider<Duration?>

// 현재 배속
final playbackSpeedProvider = StateProvider<double>

// 슬립 타이머 남은 시간
final sleepTimerProvider = StateProvider<Duration?>
```

### 3. lib/features/player/presentation/player_screen.dart
전체화면 플레이어

UI 구성:
```
[← 닫기]                    [⋮ 더보기]

[          썸네일 이미지 (정사각형)          ]
[              (없으면 앱 로고)              ]

에피소드 제목 (최대 2줄)
채널명

[현재시간] ━━━━━━━●━━━━━━━━━━━━ [전체시간]
(드래그 가능한 슬라이더)

[◀10초]  [⏮이전]  [▶/⏸]  [다음⏭]  [30초▶]

[1.0x ▼]                     [🌙 슬립타이머]

[🎬 영상으로 보기]   (audioPath만 있을 때 표시)
```

- 배속 버튼 탭 → 배속 선택 BottomSheet (0.5~3.0x)
- 슬립타이머 버튼 탭 → 슬립타이머 다이얼로그
- 영상으로 보기 탭 → videoPath 있으면 바로 재생, 없으면 확인 다이얼로그 후 다운로드

### 4. lib/features/player/presentation/mini_player.dart
하단 미니 플레이어 (currentEpisodeProvider가 null이 아닐 때만 표시)

UI:
```
[썸네일] [에피소드 제목 (1줄)] [▶/⏸] [✕]
(전체 탭하면 PlayerScreen으로 이동)
```

이 위젯을 Scaffold의 bottomNavigationBar 위에 배치하는 방법도 포함해주세요.

### 5. lib/shared/widgets/sleep_timer_dialog.dart
슬립 타이머 선택 다이얼로그

선택지:
- 꺼짐 (현재 타이머 취소)
- 15분
- 30분
- 45분
- 60분
- 에피소드 끝날 때

각 파일의 완성된 전체 코드를 제공해주세요.
```

---

### Phase 5 완료 확인

1. 다운로드된 에피소드 탭 → 플레이어 열림
2. 화면 꺼도 재생 지속 확인
3. 잠금화면에 컨트롤 표시 확인
4. 배속 조절 확인
5. 앱 종료 후 재시작 → 마지막 위치에서 재생 재개 확인

---

---

## 🟫 PHASE 6 프롬프트: Android 공유 인텐트

> 아래 내용을 전체 복사해서 Gemini에 붙여넣으세요.

---

```
당신은 Flutter/Dart 전문 시니어 Android 개발자입니다.
Offcast 앱의 Phase 6를 구현합니다.
Phase 1-5가 완료된 상태입니다.

## Phase 6 목표
YouTube 앱에서 "공유 → Offcast" 선택 시 자동으로 채널 구독 또는 에피소드 다운로드

## receive_sharing_intent 패키지 사용 (이미 pubspec에 포함)

## 구현할 항목들

### 1. AndroidManifest.xml 업데이트
MainActivity에 Intent Filter 추가:
```xml
<intent-filter>
    <action android:name="android.intent.action.SEND"/>
    <category android:name="android.intent.category.DEFAULT"/>
    <data android:mimeType="text/plain"/>
</intent-filter>
```

### 2. lib/app.dart 업데이트
receive_sharing_intent 초기화 및 URL 수신 처리:
- 앱 실행 중 수신: 바로 처리
- 앱 종료 상태에서 수신 (cold start): 앱 시작 후 처리
- URL → YouTubeUrlParser로 분석 → 적절한 화면으로 이동

### 3. 공유 URL 처리 로직
```
URL 수신
  ↓ YouTubeUrlParser 분석
  ├── 채널 URL? → AddChannelScreen으로 이동 (URL 자동 입력됨)
  ├── 영상 URL? → 다이얼로그 표시:
  │     "이 영상을 어떻게 처리할까요?"
  │     [지금 다운로드만] → 해당 영상만 오디오 다운로드
  │     [채널 전체 구독] → AddChannelScreen으로 이동
  │     [취소]
  └── 알 수 없는 URL → 스낵바: "YouTube URL이 아닙니다"
```

각 파일의 완성된 전체 코드를 제공해주세요.
(AndroidManifest 변경사항 포함)
```

---

---

## 🔧 디버깅 프롬프트 모음

### D-1: yt-dlp 실행 오류

```
Flutter Android 앱에서 yt-dlp 바이너리 실행 중 오류가 발생했습니다.

환경:
- Android API: [버전 입력]
- Flutter: [버전 입력]
- yt-dlp: ARM64 바이너리

오류 메시지:
[오류 전체 붙여넣기]

현재 YtDlpRunner 코드:
[ytdlp_runner.dart 전체 내용 붙여넣기]

문제 원인을 분석하고 수정된 코드를 제공해주세요.
```

---

### D-2: Drift 코드 생성 오류

```
Flutter Drift 코드 생성 중 오류가 발생했습니다.

flutter pub run build_runner build --delete-conflicting-outputs
실행 결과:
[오류 전체 붙여넣기]

현재 테이블 파일:
[channels_table.dart 내용]
[episodes_table.dart 내용]
[app_database.dart 내용]

오류를 수정한 완성 코드를 제공해주세요.
```

---

### D-3: WorkManager 백그라운드 미실행

```
Flutter WorkManager 자동 다운로드 작업이 실행되지 않습니다.

증상: [구체적 증상 설명]
Android 버전: [예: Android 12, 삼성 갤럭시]

현재 코드:
[main.dart의 WorkManager 초기화 부분]
[download_scheduler.dart 전체]

디버깅 방법과 수정된 코드를 제공해주세요.
```

---

### D-4: audio_service 백그라운드 종료

```
Offcast에서 화면을 끄거나 앱을 백그라운드로 보내면 재생이 멈춥니다.

Android 버전: [버전]
현재 AudioHandler 코드:
[audio_handler.dart 전체]

AndroidManifest.xml:
[서비스 관련 부분]

백그라운드에서도 재생이 유지되도록 수정해주세요.
```

---

### D-5: Riverpod Provider 오류

```
Riverpod Provider 사용 중 다음 오류가 발생했습니다:

오류: [오류 메시지]
발생 위치: [파일명]

관련 코드:
[providers.dart]
[해당 위젯 코드]

수정된 코드를 제공해주세요.
```

---

## 📝 Phase 완료 체크리스트

각 Phase 완료 후 체크:

```
Phase 0: Flutter 환경
  [ ] flutter --version 정상 출력
  [ ] flutter doctor 주요 항목 통과
  [ ] assets/binaries/yt-dlp 파일 존재

Phase 1: DB 세팅
  [ ] flutter pub get 성공
  [ ] build_runner 코드 생성 성공
  [ ] flutter analyze 오류 없음
  [ ] flutter run → 앱 실행됨

Phase 2: yt-dlp 연동
  [ ] 오디오 다운로드 테스트 성공 (.opus 파일 생성)
  [ ] 480p 영상 다운로드 테스트 성공 (.mp4 파일 생성)
  [ ] 채널 메타데이터 파싱 성공

Phase 3: 채널 구독
  [ ] @핸들로 채널 추가 성공
  [ ] 구독 목록에 채널 표시
  [ ] 채널 탭 → 에피소드 목록 표시

Phase 4: 자동 다운로드
  [ ] 수동 다운로드 버튼 동작
  [ ] 다운로드 진행률 표시
  [ ] Wi-Fi 연결 시 자동 다운로드 트리거 (테스트 어려우면 수동 트리거)

Phase 5: 플레이어
  [ ] 오디오 재생 동작
  [ ] 화면 꺼도 재생 유지
  [ ] 잠금화면 컨트롤 표시
  [ ] 배속 조절 동작
  [ ] 슬립 타이머 동작
  [ ] 재시작 후 위치 복원

Phase 6: 공유 인텐트
  [ ] YouTube 앱에서 공유 → Offcast 목록 표시
  [ ] 채널 URL 공유 → 구독 화면 이동
  [ ] 영상 URL 공유 → 처리 다이얼로그 표시
```
