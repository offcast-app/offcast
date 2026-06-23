# Offcast — Gemini 코딩 프롬프트 모음
> 각 Phase 시작 시, 해당 프롬프트를 Gemini에 복붙하여 사용.
> 항상 CODING_SPEC.md를 첨부하거나 내용을 함께 붙여넣을 것.

---

## 🔖 공통 시스템 프롬프트 (모든 대화 시작 시 붙여넣기)

```
당신은 Flutter/Dart 전문 Android 개발자입니다.
우리는 "Offcast"라는 오픈소스 Android 앱을 개발 중입니다.
첨부된 CODING_SPEC.md가 전체 기술 스펙입니다.

코딩 원칙:
- Clean Architecture 유지 (data/domain/presentation 레이어 분리)
- 모든 파일은 300줄 이하로 유지
- Riverpod을 상태 관리로 사용
- 에러 처리는 Result 패턴 또는 Either 사용
- 한국어 주석 허용
- 코드 외에 설명은 최소화하고, 바로 실행 가능한 완성 코드를 제공
```

---

## Phase 1: 프로젝트 초기 세팅

```
[공통 시스템 프롬프트 붙여넣기]

지금은 Phase 1을 구현합니다.

다음을 순서대로 구현해주세요:

1. Flutter 프로젝트 생성 명령어 (패키지명: com.offcast.app)

2. pubspec.yaml 전체 내용 (CODING_SPEC.md의 Dependencies 섹션 참고)

3. android/app/src/main/AndroidManifest.xml 전체 내용
   (CODING_SPEC.md Phase 1의 권한 목록 모두 포함)

4. lib/core/database/tables/channels_table.dart
   (Drift 테이블 정의, CODING_SPEC.md 스키마 참고)

5. lib/core/database/tables/episodes_table.dart
   (Drift 테이블 정의, CODING_SPEC.md 스키마 참고)

6. lib/core/database/app_database.dart
   (Drift DB 설정, 위 두 테이블 포함)

7. lib/core/constants.dart

8. lib/main.dart (ProviderScope, 앱 초기화)

9. lib/app.dart (MaterialApp.router, 다크테마, go_router 기본 설정)

각 파일의 전체 코드를 제공해주세요.
```

---

## Phase 2: yt-dlp 바이너리 연동

```
[공통 시스템 프롬프트 붙여넣기]

Phase 1이 완료된 상태입니다. 이제 Phase 2를 구현합니다.

중요 전제:
- yt-dlp ARM64 바이너리가 assets/binaries/yt-dlp 경로에 존재한다고 가정
- pubspec.yaml의 assets 섹션에 이미 등록되어 있다고 가정

다음을 구현해주세요:

1. lib/features/downloader/ytdlp_runner.dart
   - initialize(): assets → 앱 내부 저장소 복사 + chmod +x
   - downloadVideo(): yt-dlp로 영상 다운로드 (720p 이하)
   - fetchChannelVideos(): 채널 최신 영상 메타데이터만 가져오기 (--flat-playlist)
   - DownloadResult, VideoMetadata 모델 클래스 포함

2. lib/features/downloader/download_scheduler.dart
   - WorkManager 기반 주기적 다운로드 스케줄러
   - 와이파이 연결 조건 (NetworkType.unmetered)
   - 배터리 절약 모드 제외 조건

3. lib/core/utils/file_utils.dart
   - 앱 다운로드 디렉토리 경로 반환
   - 파일 크기 포맷팅 유틸리티

테스트용으로 단일 YouTube 영상 URL (https://www.youtube.com/watch?v=dQw4w9WgXcQ)을
다운로드하는 간단한 테스트 코드도 포함해주세요.
```

---

## Phase 3: YouTube RSS 채널 구독

```
[공통 시스템 프롬프트 붙여넣기]

Phase 2까지 완료된 상태입니다. Phase 3을 구현합니다.

다음을 구현해주세요:

1. lib/features/subscriptions/domain/channel_model.dart
   - ChannelModel 데이터 클래스

2. lib/features/episodes/domain/episode_model.dart
   - EpisodeModel 데이터 클래스

3. lib/features/subscriptions/data/channel_repository.dart
   - extractChannelId(String url): URL → 채널 ID 변환
     지원 형식: /channel/UCxxx, /c/name, /@handle
   - fetchChannelInfo(String channelId): RSS로 채널 정보
   - fetchLatestEpisodes(String channelId): RSS로 최신 에피소드 목록
   - addChannel(ChannelModel): DB에 저장
   - getChannels(): 구독 채널 목록 Stream

4. lib/features/subscriptions/presentation/subscriptions_screen.dart
   - 구독 채널 목록 화면
   - 채널 카드 (썸네일, 이름, 미다운로드 에피소드 수)
   - FloatingActionButton으로 채널 추가

5. lib/features/subscriptions/presentation/add_channel_screen.dart
   - YouTube URL 또는 채널 ID 입력
   - 채널 정보 미리보기
   - 구독 확인 버튼

YouTube RSS 피드 URL: https://www.youtube.com/feeds/videos.xml?channel_id={CHANNEL_ID}
```

---

## Phase 4: 자동 다운로드 스케줄러 (고도화)

```
[공통 시스템 프롬프트 붙여넣기]

Phase 3까지 완료된 상태입니다. Phase 4를 구현합니다.

다음을 구현해주세요:

1. lib/features/episodes/data/episode_repository.dart
   - getEpisodesByChannel(String channelId): Stream
   - markAsPlayed(String videoId)
   - updatePlaybackPosition(String videoId, int positionSec)
   - deleteEpisode(String videoId): 파일 + DB 삭제
   - getUnplayedCount(String channelId)

2. lib/features/downloader/download_scheduler.dart 고도화
   - 채널별 RSS 체크 → 신규 에피소드 감지 → 다운로드 큐
   - 채널별 최대 보관 개수 초과 시 오래된 재생완료 에피소드 자동 삭제
   - 다운로드 진행 상태 Provider로 노출

3. lib/shared/providers/providers.dart
   - channelRepositoryProvider
   - episodeRepositoryProvider
   - downloadSchedulerProvider
   - currentDownloadProgressProvider (다운로드 진행률 0.0~1.0)

4. lib/features/episodes/presentation/episodes_screen.dart
   - 채널별 에피소드 목록
   - 에피소드 타일: 제목, 날짜, 재생시간, 다운로드 상태
   - 다운로드 진행 중이면 진행 바 표시
   - 재생 완료 에피소드는 흐리게 표시
```

---

## Phase 5: 오디오 플레이어

```
[공통 시스템 프롬프트 붙여넣기]

Phase 4까지 완료된 상태입니다. Phase 5를 구현합니다.

다음을 구현해주세요:

1. lib/features/player/data/audio_handler.dart
   - AudioHandler (audio_service) 구현
   - just_audio AudioPlayer 래핑
   - 재생 위치 30초마다 DB에 자동 저장
   - 재생 완료 시 isPlayed = true

2. lib/features/player/presentation/player_screen.dart
   전체화면 플레이어, 다음 UI 요소 포함:
   - 채널명, 에피소드 제목
   - 썸네일 (없으면 앱 아이콘 fallback)
   - 재생 진행 슬라이더 (현재시간 / 전체시간)
   - 재생/일시정지, 10초 뒤로, 30초 앞으로 버튼
   - 배속 조절 버튼 (0.5x ~ 3.0x, 0.25 단위)
   - 슬립 타이머 버튼 (다이얼로그: 15/30/45/60분, 에피소드 끝)

3. lib/features/player/presentation/mini_player.dart
   - 하단 미니 플레이어 (재생 중일 때만 표시)
   - 제목, 재생/일시정지 버튼, 닫기 버튼
   - 탭하면 전체 플레이어로 이동

4. lib/shared/widgets/sleep_timer_dialog.dart

audio_service 백그라운드 서비스 AndroidManifest 설정도 포함해주세요.
```

---

## Phase 6: Android 공유 인텐트

```
[공통 시스템 프롬프트 붙여넣기]

Phase 5까지 완료된 상태입니다. Phase 6를 구현합니다.

다음을 구현해주세요:

1. AndroidManifest.xml에 Intent Filter 추가
   - youtube.com, youtu.be URL 공유 수신

2. lib/app.dart에 receive_sharing_intent 처리 추가
   - 앱 실행 중 수신: 바로 처리
   - 앱 종료 상태에서 수신: 앱 시작 후 처리

3. URL 처리 라우팅 로직:
   - 영상 URL → "이 영상 다운로드" 다이얼로그
     (옵션: 지금만 다운로드 / 채널 전체 구독)
   - 채널 URL → add_channel_screen으로 이동
   - 알 수 없는 URL → 에러 스낵바

4. lib/core/utils/youtube_url_parser.dart
   - isVideoUrl(String url): bool
   - isChannelUrl(String url): bool
   - extractVideoId(String url): String?
   - extractChannelId(String url): String?
```

---

## 에러 디버깅 프롬프트

### yt-dlp 실행 오류 시
```
Flutter Android 앱에서 yt-dlp ARM 바이너리를 실행 중 다음 오류가 발생했습니다:

[오류 메시지 붙여넣기]

현재 코드:
[ytdlp_runner.dart 내용 붙여넣기]

문제를 분석하고 수정된 코드를 제공해주세요.
환경: Android API 26+, Flutter, dart:io Process.run() 사용
```

### WorkManager 백그라운드 작업 오류 시
```
Flutter WorkManager 백그라운드 작업이 실행되지 않습니다.

증상: [증상 설명]
AndroidManifest.xml: [내용 붙여넣기]
download_scheduler.dart: [내용 붙여넣기]

Android 버전: [버전]
문제를 분석하고 수정된 코드를 제공해주세요.
```

### 오디오 포커스 충돌 시
```
전화 수신 또는 다른 앱 재생 시 Offcast 오디오가 [증상] 합니다.
audio_handler.dart: [내용 붙여넣기]

올바른 AudioFocus 처리가 되도록 수정해주세요.
```
