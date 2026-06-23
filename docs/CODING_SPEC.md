# Offcast — Coding Specification
> Gemini 코드 생성을 위한 상세 기술 스펙. 각 Phase를 순서대로 구현할 것.

---

## 앱 개요

**Offcast**는 YouTube 채널을 팟캐스트처럼 구독하고, 와이파이 환경에서 자동 다운로드하여 오프라인으로 청취하는 Android 전용 Flutter 앱이다.

---

## 기술 스택

```yaml
Framework: Flutter (stable channel)
Language: Dart
Min SDK: Android API 26 (Android 8.0)
Target SDK: Android API 34

Dependencies:
  # 오디오
  just_audio: ^0.9.x
  audio_service: ^0.18.x
  
  # 백그라운드 작업
  workmanager: ^0.5.x
  
  # 네트워크/와이파이 감지
  connectivity_plus: ^6.x
  
  # 데이터베이스
  drift: ^2.x
  drift_flutter: ^0.2.x
  
  # Android 공유 인텐트 수신
  receive_sharing_intent: ^1.x
  
  # 파일/경로
  path_provider: ^2.x
  path: ^1.x
  
  # HTTP (채널 RSS/메타데이터)
  http: ^1.x
  
  # XML 파싱 (YouTube RSS)
  xml: ^6.x
  
  # 상태 관리
  flutter_riverpod: ^2.x
  
  # UI
  go_router: ^14.x
```

---

## 아키텍처

Clean Architecture + Riverpod 상태 관리

```
lib/
├── main.dart
├── app.dart                    # MaterialApp, Router 설정
│
├── core/
│   ├── constants.dart          # 앱 상수 (yt-dlp 바이너리 경로 등)
│   ├── database/
│   │   ├── app_database.dart   # Drift DB 설정
│   │   └── tables/
│   │       ├── channels_table.dart
│   │       └── episodes_table.dart
│   └── utils/
│       ├── wifi_checker.dart
│       └── file_utils.dart
│
├── features/
│   ├── subscriptions/          # 채널 구독 관리
│   │   ├── data/
│   │   │   └── channel_repository.dart
│   │   ├── domain/
│   │   │   └── channel_model.dart
│   │   └── presentation/
│   │       ├── subscriptions_screen.dart
│   │       └── add_channel_screen.dart
│   │
│   ├── episodes/               # 에피소드 목록 및 다운로드 상태
│   │   ├── data/
│   │   │   └── episode_repository.dart
│   │   ├── domain/
│   │   │   └── episode_model.dart
│   │   └── presentation/
│   │       ├── episodes_screen.dart
│   │       └── episode_tile.dart
│   │
│   ├── player/                 # 오디오 플레이어
│   │   ├── data/
│   │   │   └── audio_handler.dart   # AudioHandler 구현
│   │   └── presentation/
│   │       ├── player_screen.dart
│   │       └── mini_player.dart
│   │
│   └── downloader/             # yt-dlp 다운로드 엔진
│       ├── ytdlp_runner.dart   # Process.run() 래퍼
│       └── download_scheduler.dart  # WorkManager 작업
│
└── shared/
    ├── widgets/
    │   ├── speed_control.dart
    │   └── sleep_timer_dialog.dart
    └── providers/
        └── providers.dart      # 전역 Riverpod providers
```

---

## Phase 1: 프로젝트 초기 세팅

### 목표
Flutter 프로젝트 생성, 의존성 설치, 기본 구조 세팅, DB 스키마 정의

### 구현 항목

#### 1-1. pubspec.yaml
위 Dependencies 섹션 참고하여 모두 추가.

#### 1-2. AndroidManifest.xml 권한
```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
<uses-permission android:name="android.permission.ACCESS_WIFI_STATE"/>
<uses-permission android:name="android.permission.FOREGROUND_SERVICE"/>
<uses-permission android:name="android.permission.FOREGROUND_SERVICE_DATA_SYNC"/>
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
<uses-permission android:name="android.permission.WAKE_LOCK"/>
<!-- Android 10 이하 외부 저장소 -->
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"
    android:maxSdkVersion="28"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"
    android:maxSdkVersion="32"/>
```

#### 1-3. DB 스키마 (Drift)

**ChannelsTable**
```
id          INTEGER PRIMARY KEY AUTOINCREMENT
channelId   TEXT NOT NULL UNIQUE   # YouTube channel ID (UCxxxxxx)
name        TEXT NOT NULL
thumbnailUrl TEXT
addedAt     INTEGER NOT NULL       # Unix timestamp
autoDownload INTEGER DEFAULT 1     # 0 or 1
maxEpisodes INTEGER DEFAULT 10     # 자동 다운로드 최대 개수
```

**EpisodesTable**
```
id            INTEGER PRIMARY KEY AUTOINCREMENT
videoId       TEXT NOT NULL UNIQUE  # YouTube video ID
channelId     TEXT NOT NULL         # FK → channels.channelId
title         TEXT NOT NULL
thumbnailUrl  TEXT
durationSec   INTEGER
publishedAt   INTEGER               # Unix timestamp
downloadPath  TEXT                  # null이면 미다운로드
downloadedAt  INTEGER
playbackPositionSec INTEGER DEFAULT 0
isPlayed      INTEGER DEFAULT 0
fileSizeBytes INTEGER
```

---

## Phase 2: yt-dlp 바이너리 연동

### 목표
yt-dlp Android ARM 바이너리를 앱에 번들하고, Dart에서 실행하여 영상 다운로드

### 구현 항목

#### 2-1. 바이너리 번들
- `assets/binaries/yt-dlp` 경로에 yt-dlp ARM64 바이너리 저장
- pubspec.yaml assets에 등록
- 앱 최초 실행 시 앱 내부 저장소에 복사 + 실행 권한 부여

```dart
// core/constants.dart
class AppConstants {
  static const ytDlpAssetPath = 'assets/binaries/yt-dlp';
  static const maxVideoHeight = 720; // 720p 이하만 다운로드
}
```

#### 2-2. YtDlpRunner (features/downloader/ytdlp_runner.dart)

```dart
// 구현해야 할 메서드들:

// 1. 바이너리 초기화 (앱 시작 시 1회)
Future<void> initialize() async {
  // assets에서 app internal storage로 복사
  // chmod +x 실행
}

// 2. 단일 영상 다운로드
Future<DownloadResult> downloadVideo({
  required String videoId,
  required String outputDir,
  int maxHeight = 720,
}) async {
  // yt-dlp 실행 인수:
  // [ytdlpPath, videoUrl, '-f', 'bestvideo[height<=720]+bestaudio/best[height<=720]',
  //  '--merge-output-format', 'mp4', '-o', outputPath, '--no-playlist']
}

// 3. 채널 최신 영상 ID 목록 가져오기 (다운로드 없이 메타데이터만)
Future<List<VideoMetadata>> fetchChannelVideos({
  required String channelId,
  int count = 10,
}) async {
  // yt-dlp --flat-playlist --playlist-items 1:10 --dump-json
}
```

#### 2-3. 다운로드 결과 모델
```dart
class DownloadResult {
  final bool success;
  final String? filePath;
  final int? fileSizeBytes;
  final String? error;
}

class VideoMetadata {
  final String videoId;
  final String title;
  final String? thumbnailUrl;
  final int? durationSec;
  final int? publishedAt; // Unix timestamp
}
```

---

## Phase 3: YouTube RSS 채널 구독

### 목표
YouTube 채널 ID로 RSS 피드를 파싱하여 신규 에피소드 감지

### 구현 항목

YouTube 공식 RSS 피드:
```
https://www.youtube.com/feeds/videos.xml?channel_id={CHANNEL_ID}
```

RSS에서 파싱할 항목:
- `yt:videoId` → videoId
- `title` → 제목
- `published` → 발행일
- `media:thumbnail url` → 썸네일

#### ChannelRepository
```dart
// 1. URL에서 채널 ID 추출
// 지원 URL 형식:
//   https://www.youtube.com/channel/UCxxxxxx
//   https://www.youtube.com/c/ChannelName   (핸들 → ID 변환 필요)
//   https://www.youtube.com/@handle         (핸들 → ID 변환 필요)
String? extractChannelId(String url);

// 2. RSS로 채널 기본 정보 가져오기
Future<ChannelModel> fetchChannelInfo(String channelId);

// 3. RSS로 최신 에피소드 목록 가져오기
Future<List<EpisodeModel>> fetchLatestEpisodes(String channelId);
```

**핸들(@handle) → 채널 ID 변환:**
yt-dlp를 사용하여 변환:
```
yt-dlp --flat-playlist --playlist-items 0 --dump-json https://www.youtube.com/@handle
```
결과 JSON의 `channel_id` 필드 사용.

---

## Phase 4: 와이파이 자동 다운로드 스케줄러

### 목표
앱이 켜진 상태 + 와이파이 연결 시 신규 에피소드 자동 다운로드

### 구현 항목

#### DownloadScheduler (WorkManager 기반)
```dart
// 조건:
// - Wi-Fi 연결 상태
// - 배터리 절약 모드 아닐 것 (선택적)
// - 앱이 foreground 또는 background

// WorkManager 제약 조건
Constraints constraints = Constraints(
  networkType: NetworkType.unmetered, // Wi-Fi only
  requiresBatteryNotLow: true,
);

// 주기: 15분마다 체크 (WorkManager 최소 주기)
// 각 구독 채널의 RSS 확인 → 새 에피소드 발견 → 다운로드 큐에 추가
```

#### 다운로드 큐 관리
- 동시 다운로드: 1개 (순차 처리)
- 채널별 최대 보관 에피소드 수 설정 가능 (기본 10개)
- 오래된 에피소드(재생 완료)는 자동 삭제

---

## Phase 5: 오디오 플레이어

### 목표
팟캐스트급 청취 경험 구현

### 구현 항목

#### AudioHandler (audio_service 기반)
```dart
// 구현할 기능:
// - 재생/일시정지/다음/이전
// - 배속 조절 (0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0, 2.5, 3.0)
// - 10초/30초 앞/뒤 이동
// - 슬립 타이머 (15분, 30분, 45분, 60분, 에피소드 끝)
// - 재생 위치 자동 저장 (앱 종료 시, 30초마다)
// - 재생 완료 시 isPlayed = true 표시
// - 무음 구간 스킵 (silence skip) - 추후 구현
// - 잠금화면/알림 컨트롤 (audio_service가 자동 처리)
```

#### PlayerScreen UI 요소
```
[채널명] [에피소드 제목]
[썸네일 이미지]
[현재시간 ──────●────── 전체시간]
[◀10s] [⏮] [▶/⏸] [⏭] [30s▶]
[배속: 1.5x ▼]  [슬립타이머 🌙]
[에피소드 목록 ↕]
```

---

## Phase 6: Android 공유 인텐트 수신

### 목표
Android 공유하기 → Offcast 선택 → URL 자동 처리

### 구현 항목

`receive_sharing_intent` 패키지 사용.

수신한 YouTube URL 처리 로직:
```
URL 수신
  ↓
URL 분석
  ├── 채널 URL? → 구독 추가 화면으로 이동
  └── 영상 URL? → "지금 다운로드" 또는 "채널 구독 후 다운로드" 선택
```

지원 URL 패턴:
- `https://youtu.be/{videoId}`
- `https://www.youtube.com/watch?v={videoId}`
- `https://www.youtube.com/channel/{channelId}`
- `https://www.youtube.com/@{handle}`

---

## Phase 7: UI/UX

### 네비게이션 구조 (go_router)
```
/                       → HomeScreen (최근 에피소드 피드)
/subscriptions          → 구독 채널 목록
/subscriptions/add      → 채널 추가
/episodes?channelId=    → 채널별 에피소드 목록
/player?episodeId=      → 플레이어 전체화면
```

### 디자인 원칙
- Material 3 다크 테마 기본
- 미니 플레이어: 하단에 항상 표시 (재생 중일 때)
- 팟캐스트 앱 UX 참고: Pocket Casts, Overcast

---

## Phase 구현 순서 요약

```
Phase 1: Flutter 프로젝트 + DB 스키마        (필수 기반)
Phase 2: yt-dlp 바이너리 연동               (핵심 기능)
Phase 3: YouTube RSS 채널 구독              (핵심 기능)
Phase 4: 와이파이 자동 다운로드 스케줄러     (핵심 기능)
Phase 5: 오디오 플레이어                    (핵심 기능)
Phase 6: Android 공유 인텐트               (UX 완성)
Phase 7: UI/UX 정리                        (폴리싱)
```

---

## 주의사항

1. **yt-dlp 바이너리 경로**: 앱 내부 저장소(`getApplicationSupportDirectory()`)에 복사 후 사용. assets에서 직접 실행 불가.
2. **실행 권한**: `Process.run('chmod', ['+x', ytdlpPath])` 먼저 실행.
3. **Android 12+ 배터리 최적화**: WorkManager가 자동 처리하지만, 사용자에게 배터리 최적화 예외 추가 안내 UI 필요.
4. **파일 저장 경로**: Android 10+는 앱 전용 저장소 사용 (`getExternalStorageDirectory()`는 deprecated).
