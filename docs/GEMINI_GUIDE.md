# Offcast — Gemini 개발 가이드
> 이 문서는 Gemini가 Offcast 앱 코딩을 처음부터 끝까지 담당하기 위한 상세 기술 가이드입니다.
> GEMINI_PROMPTS.md와 함께 사용하세요.

---

## 0. 이 프로젝트에 대하여

### 앱 정의
Offcast는 **YouTube 채널을 팟캐스트처럼 구독하고, 와이파이 환경에서 자동 다운로드하여 오프라인으로 청취**하는 Android 앱입니다.

### 개발자 정보
- 비개발자가 AI 코딩으로 개발 (vibe coding)
- 코드 생성: Gemini (당신)
- 아키텍처 설계: Claude
- 레포: https://github.com/offcast-app/offcast
- 로컬 경로: `c:\Dev\Offcast\`

### 핵심 기술 결정 (변경 불가)
| 항목 | 결정 |
|---|---|
| Framework | Flutter (stable) |
| 다운로드 엔진 | yt-dlp ARM64 바이너리 (APK 번들) |
| 기본 다운로드 | 오디오 전용 (bestaudio opus, **ffmpeg 불필요**) |
| 선택적 다운로드 | 480p 영상 (best[height<=480], **ffmpeg 불필요**) |
| DB | Drift (SQLite) |
| 상태관리 | Riverpod |
| 백그라운드 | WorkManager |
| 오디오 | just_audio + audio_service |

---

## 1. 환경 설정 (처음 1회만)

### 1-1. Flutter 설치

```powershell
# 방법 1: winget (권장)
winget install Google.Flutter

# 설치 후 PowerShell 재시작, 확인
flutter --version
```

설치 안 될 경우 수동 설치:
1. https://docs.flutter.dev/get-started/install/windows/android 접속
2. Flutter SDK zip 다운로드 → `C:\flutter` 압축 해제
3. 시스템 환경변수 Path에 `C:\flutter\bin` 추가
4. PowerShell 재시작

### 1-2. Android SDK 확인

```powershell
flutter doctor
```

나오는 오류 항목별 대처:
- `Android toolchain` 오류 → Android Studio 설치 또는 SDK Command Line Tools 설치
- `cmdline-tools` 없음 → Android Studio > SDK Manager > SDK Tools > Command Line Tools 체크
- `Android licenses` → `flutter doctor --android-licenses` 실행 후 모두 y

### 1-3. yt-dlp ARM64 바이너리 준비

1. https://github.com/yt-dlp/yt-dlp/releases/latest 접속
2. `yt-dlp_linux_aarch64` 파일 다운로드 (~15MB)
3. 파일명을 `yt-dlp`로 변경 (확장자 제거)
4. `c:\Dev\Offcast\assets\binaries\` 폴더 생성 후 그 안에 저장

### 1-4. Flutter 프로젝트 생성

```powershell
# c:\Dev\Offcast\ 안에서 실행
flutter create --org com.offcast --project-name offcast --platforms android .
```

> ⚠️ 주의: `c:\Dev\Offcast\` 폴더에 이미 docs/ README.md 등이 있습니다.
> Flutter 프로젝트를 **같은 폴더에** 생성하면 기존 파일과 합쳐집니다. 이것이 의도입니다.

### 1-5. 생성 후 즉시 확인

```powershell
flutter pub get
flutter analyze
```

오류 없이 통과하면 환경 설정 완료.

---

## 2. 프로젝트 구조 (최종 목표)

```
c:\Dev\Offcast\
├── android/
│   └── app/
│       └── src/main/
│           └── AndroidManifest.xml        ← 권한 + 서비스 등록
├── assets/
│   └── binaries/
│       └── yt-dlp                         ← ARM64 바이너리 (직접 배치)
├── lib/
│   ├── main.dart                          ← 앱 진입점
│   ├── app.dart                           ← MaterialApp + Router
│   │
│   ├── core/
│   │   ├── constants.dart                 ← 전역 상수
│   │   ├── database/
│   │   │   ├── app_database.dart          ← Drift DB 설정
│   │   │   ├── app_database.g.dart        ← 자동 생성 (build_runner)
│   │   │   └── tables/
│   │   │       ├── channels_table.dart
│   │   │       └── episodes_table.dart
│   │   └── utils/
│   │       ├── wifi_checker.dart
│   │       ├── file_utils.dart
│   │       └── youtube_url_parser.dart
│   │
│   ├── features/
│   │   ├── subscriptions/
│   │   │   ├── data/
│   │   │   │   └── channel_repository.dart
│   │   │   ├── domain/
│   │   │   │   └── channel_model.dart
│   │   │   └── presentation/
│   │   │       ├── subscriptions_screen.dart
│   │   │       └── add_channel_screen.dart
│   │   │
│   │   ├── episodes/
│   │   │   ├── data/
│   │   │   │   └── episode_repository.dart
│   │   │   ├── domain/
│   │   │   │   └── episode_model.dart
│   │   │   └── presentation/
│   │   │       ├── episodes_screen.dart
│   │   │       └── episode_tile.dart
│   │   │
│   │   ├── player/
│   │   │   ├── data/
│   │   │   │   └── audio_handler.dart     ← AudioHandler 구현
│   │   │   └── presentation/
│   │   │       ├── player_screen.dart
│   │   │       └── mini_player.dart
│   │   │
│   │   └── downloader/
│   │       ├── ytdlp_runner.dart          ← yt-dlp Process.run() 래퍼
│   │       └── download_scheduler.dart    ← WorkManager 작업
│   │
│   └── shared/
│       ├── widgets/
│       │   ├── speed_control.dart
│       │   └── sleep_timer_dialog.dart
│       └── providers/
│           └── providers.dart             ← 전역 Riverpod providers
│
├── pubspec.yaml
├── docs/
│   ├── PRODUCT_SPEC.md
│   ├── CODING_SPEC.md
│   ├── GEMINI_GUIDE.md                   ← 이 파일
│   └── GEMINI_PROMPTS.md                 ← Phase별 프롬프트
└── .github/
    └── workflows/
        └── ci.yml
```

---

## 3. pubspec.yaml 전체 내용

```yaml
name: offcast
description: YouTube channels, experienced like podcasts.
publish_to: 'none'
version: 0.1.0+1

environment:
  sdk: '>=3.2.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter

  # 오디오 재생
  just_audio: ^0.9.40
  audio_service: ^0.18.15

  # 백그라운드 작업
  workmanager: ^0.5.2

  # 네트워크/와이파이
  connectivity_plus: ^6.0.5
  http: ^1.2.2

  # XML 파싱 (YouTube RSS)
  xml: ^6.5.0

  # 데이터베이스
  drift: ^2.21.0
  drift_flutter: ^0.2.2
  sqlite3_flutter_libs: ^0.5.0

  # 파일 시스템
  path_provider: ^2.1.4
  path: ^1.9.0

  # Android 공유 인텐트
  receive_sharing_intent: ^1.8.0

  # 영상 재생 (480p 옵션)
  video_player: ^2.9.2

  # 상태 관리
  flutter_riverpod: ^2.5.1
  riverpod_annotation: ^2.3.5

  # 네비게이션
  go_router: ^14.3.0

  # 기타 유틸
  intl: ^0.19.0
  cached_network_image: ^3.4.1

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^4.0.0
  build_runner: ^2.4.12
  drift_dev: ^2.21.0
  riverpod_generator: ^2.4.3

flutter:
  uses-material-design: true
  assets:
    - assets/binaries/yt-dlp
```

---

## 4. DB 스키마 상세

### channels 테이블

| 컬럼 | 타입 | 설명 |
|---|---|---|
| id | INTEGER PK | 자동 증가 |
| channelId | TEXT UNIQUE NOT NULL | YouTube 채널 ID (UCxxxxxx) |
| name | TEXT NOT NULL | 채널명 |
| thumbnailUrl | TEXT | 채널 아바타 URL |
| addedAt | INTEGER NOT NULL | Unix timestamp (ms) |
| autoDownload | INTEGER DEFAULT 1 | 0=꺼짐, 1=켜짐 |
| maxEpisodes | INTEGER DEFAULT 10 | 최대 보관 에피소드 수 |
| downloadMode | TEXT DEFAULT 'audio' | 'audio' 또는 'video_480p' |

### episodes 테이블

| 컬럼 | 타입 | 설명 |
|---|---|---|
| id | INTEGER PK | 자동 증가 |
| videoId | TEXT UNIQUE NOT NULL | YouTube video ID |
| channelId | TEXT NOT NULL | FK → channels.channelId |
| title | TEXT NOT NULL | 에피소드 제목 |
| thumbnailUrl | TEXT | 썸네일 URL |
| durationSec | INTEGER | 재생시간 (초) |
| publishedAt | INTEGER | Unix timestamp (ms) |
| audioPath | TEXT | 오디오 파일 경로 (null=미다운로드) |
| videoPath | TEXT | 480p 영상 파일 경로 (null=미다운로드) |
| downloadMode | TEXT DEFAULT 'none' | 'none', 'audio', 'video_480p' |
| downloadedAt | INTEGER | 다운로드 완료 시각 |
| playbackPositionSec | INTEGER DEFAULT 0 | 마지막 재생 위치 (초) |
| isPlayed | INTEGER DEFAULT 0 | 0=미재생, 1=재생완료 |
| fileSizeBytes | INTEGER | 파일 크기 (bytes) |

---

## 5. yt-dlp 명령어 레퍼런스

### 오디오 전용 다운로드 (기본값)

```bash
yt-dlp \
  -f bestaudio \
  -x \
  --audio-format opus \
  --no-playlist \
  --no-warnings \
  -o "/data/user/0/com.offcast.app/files/audio/%(id)s.%(ext)s" \
  "https://www.youtube.com/watch?v={VIDEO_ID}"
```

Dart에서:
```dart
await Process.run(ytdlpPath, [
  '-f', 'bestaudio',
  '-x',
  '--audio-format', 'opus',
  '--no-playlist',
  '--no-warnings',
  '-o', outputPath,
  'https://www.youtube.com/watch?v=$videoId',
]);
```

### 480p 영상 다운로드 (선택값)

```bash
yt-dlp \
  -f "best[height<=480]" \
  --no-playlist \
  --no-warnings \
  -o "/data/user/0/com.offcast.app/files/video/%(id)s.%(ext)s" \
  "https://www.youtube.com/watch?v={VIDEO_ID}"
```

### 채널 메타데이터 가져오기 (다운로드 없이)

```bash
yt-dlp \
  --flat-playlist \
  --playlist-items 1:15 \
  --dump-json \
  --no-warnings \
  "https://www.youtube.com/channel/{CHANNEL_ID}"
```

출력: 각 영상마다 JSON 1줄씩 (newline-delimited JSON)
파싱해야 할 필드: `id`, `title`, `duration`, `thumbnail`, `upload_date`

### 핸들(@handle) → 채널 ID 변환

```bash
yt-dlp \
  --flat-playlist \
  --playlist-items 0 \
  --dump-json \
  --no-warnings \
  "https://www.youtube.com/@{HANDLE}"
```

결과 JSON의 `channel_id` 필드 사용.

---

## 6. YouTube RSS 피드

```
URL: https://www.youtube.com/feeds/videos.xml?channel_id={CHANNEL_ID}
인증: 불필요 (완전 공개)
형식: Atom XML
```

파싱할 필드:
```xml
<feed>
  <title>채널명</title>
  <entry>
    <yt:videoId>dQw4w9WgXcQ</yt:videoId>
    <title>영상 제목</title>
    <published>2024-01-15T10:00:00+00:00</published>
    <media:group>
      <media:thumbnail url="https://i.ytimg.com/vi/.../hqdefault.jpg"/>
      <media:description>설명</media:description>
    </media:group>
  </entry>
</feed>
```

> ⚠️ 주의: RSS는 최신 15개만 반환. 더 많이 필요하면 yt-dlp --flat-playlist 사용.

---

## 7. AndroidManifest.xml 전체 설정

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">

    <!-- 네트워크 -->
    <uses-permission android:name="android.permission.INTERNET"/>
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
    <uses-permission android:name="android.permission.ACCESS_WIFI_STATE"/>

    <!-- 백그라운드 작업 -->
    <uses-permission android:name="android.permission.FOREGROUND_SERVICE"/>
    <uses-permission android:name="android.permission.FOREGROUND_SERVICE_DATA_SYNC"/>
    <uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
    <uses-permission android:name="android.permission.WAKE_LOCK"/>

    <!-- 저장소 (Android 10 이하) -->
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"
        android:maxSdkVersion="28"/>
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"
        android:maxSdkVersion="32"/>

    <application
        android:label="Offcast"
        android:name="${applicationName}"
        android:icon="@mipmap/ic_launcher">

        <activity
            android:name=".MainActivity"
            android:exported="true"
            android:launchMode="singleTop"
            android:theme="@style/LaunchTheme"
            android:configChanges="orientation|keyboardHidden|keyboard|screenSize|smallestScreenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode"
            android:hardwareAccelerated="true"
            android:windowSoftInputMode="adjustResize">

            <meta-data
                android:name="io.flutter.embedding.android.NormalTheme"
                android:resource="@style/NormalTheme"/>

            <intent-filter>
                <action android:name="android.intent.action.MAIN"/>
                <category android:name="android.intent.category.LAUNCHER"/>
            </intent-filter>

            <!-- YouTube URL 공유 인텐트 수신 -->
            <intent-filter>
                <action android:name="android.intent.action.SEND"/>
                <category android:name="android.intent.category.DEFAULT"/>
                <data android:mimeType="text/plain"/>
            </intent-filter>
        </activity>

        <!-- audio_service 백그라운드 서비스 -->
        <service
            android:name="com.ryanheise.audioservice.AudioService"
            android:exported="true"
            android:foregroundServiceType="mediaPlayback">
            <intent-filter>
                <action android:name="android.media.browse.MediaBrowserService"/>
            </intent-filter>
        </service>

        <!-- audio_service 미디어 버튼 수신 -->
        <receiver
            android:name="com.ryanheise.audioservice.MediaButtonReceiver"
            android:exported="true">
            <intent-filter>
                <action android:name="android.intent.action.MEDIA_BUTTON"/>
            </intent-filter>
        </receiver>

        <!-- WorkManager 초기화 -->
        <provider
            android:name="androidx.startup.InitializationProvider"
            android:authorities="${applicationId}.androidx-startup"
            android:exported="false"
            tools:node="merge">
            <meta-data
                android:name="androidx.work.WorkManagerInitializer"
                android:value="androidx.startup"/>
        </provider>

    </application>
</manifest>
```

---

## 8. 코딩 원칙 (반드시 준수)

### 아키텍처
- **Clean Architecture**: data / domain / presentation 레이어 엄격히 분리
- **파일당 300줄 이하** 유지
- **단일 책임 원칙**: 파일 하나 = 기능 하나

### Dart 코딩 스타일
- `print()` 절대 사용 금지 → `debugPrint()` 또는 로깅 패키지 사용
- 모든 public 메서드에 타입 명시
- `async/await` 사용, `.then()` 체인 지양
- `null` 안전성 철저히 (nullable 타입 최소화)
- 에러 처리: try-catch 필수, 빈 catch 금지

### Flutter 스타일
- `const` 위젯 최대한 활용
- `BuildContext` 를 async gap 이후 사용할 때 `mounted` 확인 필수
- StatefulWidget보다 ConsumerWidget (Riverpod) 우선

### 주석
- 복잡한 로직에 한국어 주석 허용
- 공개 API에는 `///` 문서 주석 사용

---

## 9. Phase별 구현 순서 및 의존성

```
Phase 1 (환경 + DB)
  ├── Flutter 프로젝트 생성
  ├── pubspec.yaml 설정
  ├── Drift 테이블 정의 (channels, episodes)
  ├── build_runner 실행 (코드 자동 생성)
  └── 기본 앱 구조 (main.dart, app.dart)
         ↓
Phase 2 (yt-dlp 연동)              ← Phase 1 완료 필요
  ├── YtDlpRunner (초기화, 오디오 다운, 480p 다운, 메타데이터)
  ├── FileUtils (경로, 크기 포맷)
  └── 수동 테스트: 단일 영상 오디오 다운로드 성공 확인
         ↓
Phase 3 (채널 구독)                ← Phase 2 완료 필요
  ├── ChannelModel, EpisodeModel
  ├── ChannelRepository (RSS 파싱, URL 파싱)
  ├── SubscriptionsScreen
  └── AddChannelScreen
         ↓
Phase 4 (자동 다운로드)            ← Phase 3 완료 필요
  ├── EpisodeRepository
  ├── DownloadScheduler (WorkManager)
  ├── Providers (전역 상태)
  └── EpisodesScreen
         ↓
Phase 5 (플레이어)                 ← Phase 4 완료 필요
  ├── AudioHandler (audio_service)
  ├── PlayerScreen (전체화면)
  └── MiniPlayer (항상 표시)
         ↓
Phase 6 (공유 인텐트)              ← Phase 5 완료 필요
  ├── AndroidManifest Intent Filter
  ├── URL 파서
  └── 공유 수신 처리 로직
         ↓
Phase 7 (UI 폴리싱)                ← Phase 6 완료 후
  ├── 애니메이션, 트랜지션
  ├── 에러 상태 UI
  └── 온보딩 플로우
```

---

## 10. 각 Phase 후 테스트 체크리스트

### Phase 1 완료 확인
- [ ] `flutter analyze` 오류 없음
- [ ] `flutter run` 실행 → 빈 화면이라도 앱 실행됨
- [ ] `flutter pub run build_runner build` → Drift 코드 생성 성공

### Phase 2 완료 확인
- [ ] yt-dlp 바이너리가 앱 내부 저장소에 복사됨
- [ ] 단일 영상 오디오 다운로드 성공 (`.opus` 파일 생성됨)
- [ ] 단일 영상 480p 다운로드 성공 (`.mp4` 파일 생성됨)
- [ ] 채널 메타데이터 5개 이상 파싱 성공

### Phase 3 완료 확인
- [ ] YouTube URL 입력 → 채널 정보 표시됨
- [ ] 채널 구독 → DB에 저장됨
- [ ] 구독 목록 화면에 채널 표시됨

### Phase 4 완료 확인
- [ ] Wi-Fi 연결 시 자동 다운로드 실행됨 (WorkManager 로그 확인)
- [ ] 에피소드 목록에 다운로드 상태 표시됨
- [ ] 다운로드 진행률 표시됨

### Phase 5 완료 확인
- [ ] 다운로드된 오디오 재생됨
- [ ] 화면 꺼도 재생 유지됨 (백그라운드)
- [ ] 잠금화면에 컨트롤 표시됨
- [ ] 배속 조절 동작함
- [ ] 슬립 타이머 동작함
- [ ] 앱 재시작 후 마지막 위치에서 재생 재개됨

---

## 11. 흔한 오류 및 해결법

### build_runner 오류
```
Error: The name 'xxx' is defined in the generated part '...'
```
해결: `flutter pub run build_runner build --delete-conflicting-outputs`

### yt-dlp 실행 권한 오류
```
Permission denied: /data/user/0/com.offcast.app/files/yt-dlp
```
해결: 복사 후 `chmod +x` 명령 실행 확인
```dart
await Process.run('chmod', ['+x', ytdlpBinaryPath]);
```

### WorkManager 백그라운드 미실행 (삼성/샤오미)
원인: 제조사별 배터리 최적화
해결: 
1. 앱 설정에서 "배터리 최적화 제외" 허용 요청 UI 추가
2. 최소 실행 주기 15분 (WorkManager 하드 제한)

### audio_service 백그라운드 종료
원인: Android 백그라운드 프로세스 킬
해결: Foreground Service 사용 (AudioService 기본 동작)
AndroidManifest에 `android:foregroundServiceType="mediaPlayback"` 확인

### Drift 마이그레이션 오류
원인: 스키마 변경 후 마이그레이션 미정의
해결: `MigrationStrategy` 정의 또는 개발 중에는 `destroyEverything()` 사용
```dart
MigrationStrategy(
  onUpgrade: (m, from, to) async {
    // 개발 중에는 전체 삭제 후 재생성
    await m.destructiveMigration();
  },
)
```

---

## 12. 개발 완료 후 APK 빌드

```powershell
# Debug APK (테스트용)
flutter build apk --debug

# Release APK (배포용, 서명 필요)
flutter build apk --release

# APK 위치
# build/app/outputs/flutter-apk/app-release.apk
```

GitHub Actions CI (`ci.yml`)가 자동으로 릴리스 APK를 빌드합니다.

---

## 13. 다음 대화 시작 방법

새 Gemini 대화를 시작할 때:
1. **이 파일(GEMINI_GUIDE.md)을 첨부** 또는 붙여넣기
2. **CODING_SPEC.md도 함께 첨부**
3. **GEMINI_PROMPTS.md의 해당 Phase 프롬프트** 복붙

각 Phase 프롬프트는 `docs/GEMINI_PROMPTS.md` 파일에 있습니다.
