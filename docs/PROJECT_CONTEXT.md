# Offcast — Project Context
> Load this file at the start of any new AI conversation to restore full context.

---

## 프로젝트 한 줄 요약
**YouTube 채널을 팟캐스트처럼 구독하고, 와이파이 환경에서 자동 다운로드하여 오프라인으로 청취하는 Android 앱.**

---

## 기획 배경 (대화 요약)

### 핵심 인사이트
- 유튜브를 "보는" 게 아니라 "듣는" 용도로 쓰는 사용자가 많다
- NewPipe는 "YouTube 뷰어"이지 "YouTube 청취기"가 아님 → 진짜 경쟁자는 Pocket Casts, Overcast 같은 팟캐스트 앱
- YouCaster, Listenbox 등 유사 서비스는 존재하지만 모두 2~3개 서비스 조합이 필요하고, **단일 앱으로 해결하는 것이 없음**
- 이 공백이 존재하는 이유: Play Store 정책상 yt-dlp를 내장한 앱을 올릴 수 없기 때문 → **APK 직배포만 하면 오히려 경쟁이 없음**

### 타겟 시장
- 글로벌 (한국 제외, 영어권 우선)
- 프라이버시 중시, 기술 친화적 사용자
- NewPipe, ReVanced 같은 앱 사용 경험 있는 층

### 수익화 계획
- 초기: 완전 무료 오픈소스
- 유저 10만 명 임계점 도달 시:
  - VPN 서비스 스폰서십 (이 유저층이 VPN 구매율 최고)
  - GitHub Sponsors / Open Collective
  - Grayjay식 일회성 개발자 지원 구매

---

## 확정된 기술 결정사항

| 항목 | 결정 | 이유 |
|---|---|---|
| **앱 이름** | Offcast | Offline + Podcast/Broadcast. 검색 경쟁 없음, 의미 직관적 |
| **플랫폼** | Android only (초기) | iOS는 APK 직배포 불가, 나중에 고려 |
| **프레임워크** | Flutter | AI 코딩 품질 최고, Dart 단순, 관련 패키지 모두 존재 |
| **다운로드 엔진** | yt-dlp ARM 바이너리 (앱에 번들) | 서버 불필요, 완전 오프라인 동작 |
| **배포 방식** | GitHub Releases APK + F-Droid | Play Store 불가 (ToS 위반) |
| **라이선스** | GPL-3.0 | yt-dlp와 동일 라이선스 |
| **개발 방식** | 바이브 코딩 (AI 주도) + 추후 개발자 리뷰 아웃소싱 |

### yt-dlp 연동 방식 (확정: Option A)
- yt-dlp 공식 GitHub에서 Android ARM용 바이너리 배포 중
- APK assets 폴더에 번들
- `dart:io`의 `Process.run()`으로 실행
- 서버 의존성 없음, 인터넷 없이도 이미 다운받은 영상 재생 가능

---

## 단기 목표

### 현재 즉각 목표: OpenAI Codex for Open Source 지원
- 프로그램: 오픈소스 메인테이너에게 ChatGPT Pro + API 크레딧 제공
- 지원 전략: 신규 프로젝트지만 "생태계 공백 해소" 스토리로 커버
- AI 워크플로우 명시 필요: PR 자동 리뷰, yt-dlp 호환성 체크, 릴리즈 노트 자동화
- 지원서 초안: `CODEX_APPLICATION.md` 참고

### 개발 목표 (Codex 크레딧 받은 후 본격 개발)
- MVP: 핵심 기능 동작하는 첫 APK
- F-Droid 등록
- 유저 피드백 수집 후 반복

---

## 현재 레포 구조

```
c:\Dev\Offcast\
├── README.md                    ✅ 완성
├── CONTRIBUTING.md              ✅ 완성
├── docs/
│   ├── PROJECT_CONTEXT.md       ✅ 이 파일
│   ├── CODING_SPEC.md           ✅ Gemini 코딩 스펙
│   ├── GEMINI_PROMPTS.md        ✅ 단계별 프롬프트
│   └── CODEX_APPLICATION.md    ✅ 지원서 초안
└── .github/
    └── workflows/
        ├── ci.yml               ✅ 빌드/테스트 자동화
        └── codex_review.yml     ✅ Codex PR 리뷰
```

---

## AI 역할 분담

| 역할 | 담당 |
|---|---|
| 아키텍처 결정, 기술 선택, 전략 | Claude (Thinking 모드) |
| 실제 코드 생성, 파일 구현 | Gemini (무료 쿼터 활용) |
| 에러 디버깅 전략 | Claude |
| 아웃소싱 리뷰 (나중에) | Upwork Android 개발자 |

---

## 주요 기술 리스크 및 대응

| 리스크 | 대응 |
|---|---|
| YouTube가 yt-dlp 막음 | 커뮤니티 업데이트 기다림. 사용자도 이해함 |
| yt-dlp ARM 바이너리 실행 권한 오류 | `chmod +x` 처리, 아웃소싱 리뷰 항목 |
| 백그라운드 서비스 배터리 최적화 이슈 | WorkManager 사용, 리뷰 항목 |
| 오디오 포커스 충돌 | audio_service 패키지가 대부분 처리 |
