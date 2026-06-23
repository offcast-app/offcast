# Offcast — OpenAI Codex for Open Source 지원서 초안
> https://openai.com/codex-open-source 에서 지원
> 500자 이내 제한 항목은 [500자 제한] 표시

---

## Project Name
Offcast

## GitHub Repository URL
https://github.com/lucas-distill/offcast

## Your Role
Primary maintainer and sole developer

---

## Project Description [500자 제한]

```
Offcast is an open-source Android app that treats YouTube channels like podcast subscriptions.

Users subscribe to channels, and the app auto-downloads new videos on Wi-Fi for offline listening — with podcast-grade controls: variable speed (0.5x–3.0x), sleep timer, silence skip, and persistent playback position.

No server required. yt-dlp ARM binary is bundled directly in the APK.

This fills a real gap: RSS-to-podcast bridges exist, but no single app combines YouTube channel management + actual audio download + listening-first UX. Distribution via GitHub APK only, as Play Store prohibits yt-dlp integration.

Built with Flutter. Licensed GPL-3.0.
```

---

## Why Does This Project Qualify? [500자 제한]

```
The overlap between "YouTube viewer" and "podcast listener" is underserved. 

Existing tools require 2–3 apps in combination (RSS converter + podcast player + downloader). No single app solves this end-to-end — not because demand is absent, but because Play Store policy prevents yt-dlp-based apps from being listed.

APK-distributed apps like NewPipe (millions of installs) prove this user base exists. Offcast targets the listening-specific subset: people who follow tech talks, interviews, and commentary channels — the same audience most likely to adopt AI-integrated tooling and contribute back.

As sole maintainer of a GPL project with no corporate backing, Codex access would directly determine whether this reaches users.
```

---

## How Will You Use Codex? [핵심 항목 — 구체적으로]

```
Three specific workflows:

1. Automated PR review
When contributors submit PRs, a GitHub Actions workflow sends the diff to the Codex API and posts a structured review comment: correctness, battery/performance implications (critical for background services), and yt-dlp compatibility risks. I then verify and merge. This prevents maintainer bottleneck on technical review.

2. yt-dlp compatibility monitoring
YouTube periodically patches against yt-dlp. A scheduled Codex workflow analyzes yt-dlp changelogs and open issues, then generates a compatibility report and draft patch for Offcast's runner integration. This reduces downtime when YouTube breaks compatibility.

3. Release note generation
Before each release, a script sends git log to Codex API to produce user-friendly release notes from raw commit messages. Output reviewed by me before publishing to GitHub Releases.

All AI outputs are human-reviewed before any merge or publish action.
```

---

## How Will You Verify AI Output?

```
- PR reviews: I read every comment before acting. Auto-close is never triggered.
- Compatibility patches: Tested on device before merge.
- Release notes: Manually edited before publishing.

AI accelerates; I decide.
```

---

## 제출 전 체크리스트

- [ ] GitHub 레포 Public으로 설정
- [ ] README.md 완성 (스크린샷 포함하면 더 좋음)
- [ ] GitHub Profile Public 설정
- [ ] .github/workflows/codex_review.yml 존재
- [ ] CONTRIBUTING.md 존재
- [ ] LICENSE 파일 (MIT) 존재
- [ ] 최소 1개 이상의 커밋 히스토리
- [ ] Issues 탭 활성화

---

## 지원 URL
https://openai.com/codex-open-source
(또는 developers.openai.com → Codex for Open Source)
