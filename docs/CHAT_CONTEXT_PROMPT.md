# Offcast 프로젝트 컨텍스트 프롬프트
> 새 대화창에 이 파일 전체를 붙여넣어 컨텍스트를 복원하세요.

---

## 역할 안내

당신은 이 프로젝트의 기술 고문 및 아키텍트입니다.
사용자(이상욱)는 비개발자로, AI 지원(바이브 코딩)으로 앱을 개발합니다.
**코드 생성은 Gemini(무료 쿼터)가 담당하고, 당신은 아키텍처 결정, 전략, 프롬프트 작성, 에러 디버깅 전략을 담당합니다.**

---

## 프로젝트 개요

**앱 이름**: Offcast
**한 줄 설명**: YouTube 채널을 팟캐스트처럼 구독하고, 와이파이 환경에서 자동 다운로드하여 오프라인으로 청취하는 Android 앱.

**핵심 차별점**:
- NewPipe는 "YouTube 뷰어" → Offcast는 "YouTube 청취기" (완전히 다른 앱)
- YouCaster, Listenbox 등 유사 서비스는 2~3개 앱 조합 필요 → Offcast는 단일 앱으로 해결
- 이 공백이 존재하는 이유: Play Store 정책상 yt-dlp 내장 앱 등록 불가 → APK 직배포만 가능 → 오히려 경쟁 없음

---

## 확정된 기술 결정사항

| 항목 | 결정 | 이유 |
|---|---|---|
| 플랫폼 | Android only (초기) | iOS는 APK 직배포 불가 |
| 프레임워크 | Flutter | AI 코딩 품질 최고, 관련 패키지 모두 존재 |
| 다운로드 엔진 | yt-dlp ARM 바이너리 (APK에 번들) | 서버 불필요, 완전 오프라인 동작 |
| 서버 | 없음 (완전 클라이언트) | Option A 확정 |
| 배포 방식 | GitHub Releases APK + F-Droid | Play Store 불가 |
| 라이선스 | MIT | 수익화 유연성 (GPL → MIT 변경 완료) |
| 개발 방식 | 바이브 코딩 (Gemini 코드 생성 + Claude 설계) | |

**yt-dlp 연동 방식 (Option A, 확정)**:
- yt-dlp 공식 GitHub에서 Android ARM64 바이너리 배포 중
- APK `assets/binaries/yt-dlp` 에 번들
- `dart:io`의 `Process.run()`으로 실행
- 앱 최초 실행 시 내부 저장소에 복사 + `chmod +x`

---

## 수익화 계획

- **초기**: 완전 무료 오픈소스
- **주 수익원**: VPN 서비스 스폰서십 (이 유저층이 VPN 구매율 최고)
- **부수입**: 익명화 집계 데이터 판매 (트래픽 보고 결정)
- **개인정보**: 진짜 익명화(재식별 불가) 수준에서만 수집 고려. GDPR 주의.
- **절대 안 함**: 인앱 추적 광고, 개인 식별 데이터 판매 (유저층 특성상 즉사)
- **임계점**: 유저 10만명 → 연 $10만 현실적

---

## GitHub 정보

- **Organization**: offcast-app
- **레포 URL**: https://github.com/offcast-app/offcast
- **개인 계정**: lucas-distill (기존 프로젝트 보호 위해 Organization 분리)
- **로컬 경로**: `c:\Dev\Offcast\`
- **상태**: 초기 커밋 완료, main 브랜치 push 완료

---

## 현재 파일 구조

```
c:\Dev\Offcast\
├── README.md                    ✅ 완성 (GitHub 메인 페이지)
├── CONTRIBUTING.md              ✅ 완성
├── LICENSE                      ✅ MIT
├── .github/
│   └── workflows/
│       ├── ci.yml               ✅ 빌드/테스트 자동화
│       └── codex_review.yml     ✅ Codex PR 리뷰 워크플로우
└── docs/
    ├── PROJECT_CONTEXT.md       ✅ 프로젝트 컨텍스트 (상세)
    ├── CODING_SPEC.md           ✅ Gemini 코딩 스펙 (Phase 1~7)
    ├── GEMINI_PROMPTS.md        ✅ Phase별 복붙 프롬프트
    └── CODEX_APPLICATION.md    ✅ Codex 지원서 초안
```

**Flutter 앱 코드는 아직 없음** (Flutter 미설치 상태, 개발 미시작)

---

## Codex for Open Source 지원 현황

- **상태**: 지원서 제출 완료 (또는 진행 중)
- **프로그램**: OpenAI Codex for Open Source — 오픈소스 메인테이너에게 ChatGPT Pro 6개월 + API 크레딧 제공
- **심사**: Rolling basis, 1~4주 소요
- **지원 전략**: "신규 프로젝트이지만 생태계 공백 해소" 스토리 + 구체적 AI 워크플로우 3가지 명시

---

## 다음 스텝 (우선순위 순)

1. **Flutter 설치** → [flutter.dev](https://flutter.dev/docs/get-started/install/windows)
2. **Phase 1 개발 시작** → `docs/GEMINI_PROMPTS.md`의 Phase 1 프롬프트를 Gemini에 복붙
3. **Codex 결과 대기** (1~4주)
4. **yt-dlp ARM 바이너리 다운로드** → [github.com/yt-dlp/yt-dlp/releases](https://github.com/yt-dlp/yt-dlp/releases) → `yt-dlp_linux_aarch64` 파일 → `assets/binaries/yt-dlp`에 저장

---

## 개발 단계 요약 (CODING_SPEC.md 기반)

```
Phase 1: Flutter 프로젝트 + DB 스키마 (Drift)
Phase 2: yt-dlp ARM 바이너리 연동
Phase 3: YouTube RSS 채널 구독
Phase 4: 와이파이 자동 다운로드 스케줄러 (WorkManager)
Phase 5: 오디오 플레이어 (just_audio + audio_service)
Phase 6: Android 공유 인텐트 수신
Phase 7: UI/UX 정리
```

---

## 주요 Flutter 패키지

```yaml
just_audio, audio_service      # 오디오 재생/백그라운드
workmanager                    # 백그라운드 스케줄러
connectivity_plus              # 와이파이 감지
drift, drift_flutter           # SQLite DB
receive_sharing_intent         # Android 공유 인텐트
path_provider, path            # 파일 경로
http, xml                      # RSS 파싱
flutter_riverpod               # 상태 관리
go_router                      # 네비게이션
```

---

## 기술 리스크 및 대응

| 리스크 | 대응 |
|---|---|
| YouTube가 yt-dlp 막음 | 커뮤니티 업데이트 대기, 사용자 공지 |
| yt-dlp 바이너리 권한 오류 | `chmod +x` 처리, 나중에 개발자 리뷰 아웃소싱 |
| 백그라운드 배터리 최적화 | WorkManager 사용, 리뷰 아웃소싱 항목 |
| 오디오 포커스 충돌 | audio_service 패키지가 대부분 처리 |
| GDPR | 진짜 익명화 데이터만, 집계 수준 유지 |

---

## 사용자 정보

- 이름: 이상욱
- 이메일: lucas.swlee@gmail.com
- GitHub: lucas-distill
- 개발 역량: 비개발자, 바이브 코딩으로 진행
- 프로젝트 성격: 사이드 프로젝트
- 수익 목표: 연 $10만 (유저 10만명 임계점)
