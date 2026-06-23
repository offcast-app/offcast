# Offcast — Product Specification

> Version 1.0 | Last updated: 2026-06-24
> Author: Sangwook Lee ([@lucas-distill](https://github.com/lucas-distill))

---

## Table of Contents

1. [Product Vision](#1-product-vision)
2. [Problem Statement](#2-problem-statement)
3. [Target Users](#3-target-users)
4. [Competitive Analysis](#4-competitive-analysis)
5. [Core Features](#5-core-features)
6. [User Experience Design](#6-user-experience-design)
7. [Technical Architecture](#7-technical-architecture)
8. [Distribution Strategy](#8-distribution-strategy)
9. [Monetization Strategy](#9-monetization-strategy)
10. [Roadmap](#10-roadmap)
11. [Risk Assessment](#11-risk-assessment)
12. [AI Development Workflow](#12-ai-development-workflow)

---

## 1. Product Vision

### Mission Statement

> **Turn any YouTube channel into a podcast — automatically, privately, and offline.**

Offcast is an Android application that bridges the gap between YouTube's video-first platform and the increasingly audio-first consumption habits of modern users. It treats YouTube channels as podcast feeds: subscribe once, and new episodes are automatically downloaded over Wi-Fi for offline listening.

### Why Now?

- **Podcast listening is at an all-time high**: 500M+ monthly podcast listeners globally (2024)
- **YouTube is the world's largest audio content library**: Millions of channels produce content that is primarily audio-driven (interviews, lectures, commentary, news)
- **No single app solves this**: Existing solutions require 2–3 apps, server-side workarounds, or paid subscriptions
- **The legal gap creates opportunity**: Play Store policy prohibits yt-dlp-based apps → zero legitimate competition on Play Store → APK distribution fills the vacuum

---

## 2. Problem Statement

### The Core Pain

A listener who wants to subscribe to a YouTube channel "like a podcast" currently faces this friction:

```
CURRENT WORKFLOW (broken):
1. Open YouTube → find channel → remember to check for new videos
2. If offline listening wanted:
   → Use YouCaster/Listenbox (requires 3rd-party server, unreliable)
   → Or: separate download app → separate podcast app → manual import
   → Or: YouTube Premium ($13.99/mo) — but no RSS/auto-subscription concept
3. No background audio control (lock screen, car, earphones)
4. No playback speed, sleep timer, or position sync
```

```
OFFCAST WORKFLOW (solved):
1. Paste YouTube channel URL → subscribed
2. App auto-downloads new episodes over Wi-Fi (background)
3. Listen offline with full podcast controls
```

### User Quotes (from Reddit research)

> *"I just want my favorite YouTube channels to show up in my podcast app automatically. Why is this so hard?"*
> — r/androidapps

> *"I drive 2 hours a day. Most of what I watch on YouTube is just talking heads. Why can't I listen like a podcast?"*
> — r/youtube

> *"Tried Listenbox, it's slow and breaks every few weeks. Tried AntennaPod with YouTube RSS — it streams, but no offline and the audio cuts when screen turns off."*
> — r/podcasts

---

## 3. Target Users

### Primary Persona: "The Commuter Listener"

| Attribute | Description |
|---|---|
| Age | 25–40 |
| Platform | Android (flagship or mid-range) |
| Behavior | 1–3 hours of audio/commute daily |
| Content | Tech podcasts, news commentary, long-form interviews, educational channels |
| Pain | Wants to listen offline but hates the setup friction |
| Tech comfort | Medium-high (comfortable installing APKs) |
| Privacy stance | Values privacy; avoids ad-heavy apps |

### Secondary Persona: "The Privacy-Conscious Power User"

| Attribute | Description |
|---|---|
| Age | 20–35 |
| Behavior | Uses F-Droid, NewPipe, custom ROMs |
| Content | Same as above, plus niche/independent creators |
| Pain | YouTube app is surveillance; wants alternative client |
| Key differentiator | Prefers Offcast over NewPipe because audio-first UX |

### Non-Target Users

- Casual YouTube viewers who want video (→ use NewPipe/YouTube)
- iOS users (APK distribution impossible on iOS)
- Users who want real-time livestream (not supported by design)

---

## 4. Competitive Analysis

### Direct Competitors

| App | Category | Strengths | Why Offcast Wins |
|---|---|---|---|
| **NewPipe** | YouTube viewer | Mature, F-Droid, huge community | NewPipe is video-first; no podcast UX, no auto-download queue |
| **Grayjay** | Multi-platform viewer | Plugin architecture | Paid ($0 but donation-nag), complex UI, not audio-focused |
| **LibreTube** | YouTube viewer | Clean UI | No offline, no podcast features |
| **AntennaPod** | Podcast player | Best podcast UX | Cannot play YouTube channels (only RSS audio feeds) |
| **PodGrab** | Self-hosted podcast | Full automation | Requires home server; non-technical users excluded |

### Indirect Competitors

| Service | Model | Weakness |
|---|---|---|
| **YouCaster** | Server-side RSS bridge | Server dependency, breaks with YouTube changes, ~$5/mo for quality tier |
| **Listenbox** | Server-side | Same as above, unreliable |
| **YouTube Premium** | Official | $13.99/mo, no auto-subscription/RSS concept, no speed control, walled garden |

### Competitive Moat

```
Offcast's unique position:
┌─────────────────────────────────────────────────┐
│                                                 │
│   Podcast UX  ──────────────────── Offcast ✓   │
│   (AntennaPod,                                  │
│    Pocket Casts)                                │
│                                                 │
│   YouTube     ──────────────────── NewPipe ✓   │
│   (alternative                                  │
│    client)                                      │
│                                                 │
│   INTERSECTION: Podcast UX + YouTube Content    │
│   = Nobody is here except Offcast               │
└─────────────────────────────────────────────────┘
```

---

## 5. Core Features

### MVP (Phase 1–5)

#### 5.1 Channel Subscription

- **Add by URL**: Supports all YouTube URL formats
  - `https://youtube.com/channel/UCxxxxxx` (Channel ID)
  - `https://youtube.com/@handle` (Handle)
  - `https://youtube.com/c/ChannelName` (Legacy)
  - `https://youtu.be/{videoId}` (Single video → offer channel subscription)
- **Add via Android Share Sheet**: Share from YouTube app → Offcast auto-detects
- **Channel metadata**: Name, avatar, subscriber count (via RSS)
- **Per-channel settings**:
  - Auto-download: On/Off
  - Max episodes to keep: 3 / 5 / 10 / 20 / Unlimited
  - Download mode: Audio only / Video (480p)

#### 5.2 Episode Management

- **Episode list per channel**: Newest-first, with download status indicator
- **Global feed**: All subscribed channels' episodes in chronological order
- **Episode states**:
  - `Not downloaded` → stream not supported (offline-first)
  - `Queued` → waiting for Wi-Fi
  - `Downloading` → progress indicator with % and speed
  - `Downloaded` → ready to play
  - `Played` → greyed out, marked complete
- **Manual download**: Tap any episode to queue for download
- **Delete episode**: Swipe or long-press to free storage

#### 5.3 Auto-Download Engine

- **Trigger**: Wi-Fi connected + battery not low
- **Check interval**: Every 15 minutes (WorkManager minimum)
- **Logic**:
  1. For each subscribed channel: fetch RSS feed
  2. Compare with DB → find new episodes
  3. Queue new episodes for download (newest first)
  4. Download sequentially (1 at a time to preserve battery)
  5. Delete oldest played episodes when storage limit reached
- **User notification**: "3 new episodes downloaded from 2 channels"
- **Failure handling**: Retry on next Wi-Fi cycle; log error per episode

#### 5.4 Audio Player

**Playback Controls:**
- Play / Pause / Stop
- Previous episode / Next episode
- Skip backward 10s / Skip forward 30s
- Seekbar with chapter markers (if available)

**Podcast-Grade Features:**
- **Playback speed**: 0.5× / 0.75× / 1.0× / 1.25× / 1.5× / 1.75× / 2.0× / 2.5× / 3.0×
- **Sleep timer**: 15 / 30 / 45 / 60 min / End of episode / Custom
- **Position memory**: Auto-saves every 30 seconds; resumes exactly where you left off
- **Completion tracking**: Mark as played at 95% completion; manual mark available
- **Background playback**: Continues when screen is off or other apps are open
- **Lock screen controls**: Standard Android media controls (MediaSession)
- **Car/Bluetooth**: Compatible with Android Auto and Bluetooth AVRCP

#### 5.5 Video Mode (Optional)

- **Access**: "Watch video" button in audio player
- **Format**: 480p MP4 (no ffmpeg required; single-stream download)
- **Behavior**: Switches to fullscreen video player; audio continues if screen dims
- **Storage warning**: Shown before 480p download (~250MB/30min)

#### 5.6 Privacy & Data

- **No account required**: No login, no user ID, no cloud sync
- **No analytics by default**: No tracking SDK bundled
- **All data local**: Channel subscriptions, episodes, playback position stored in on-device SQLite
- **Network requests**: Only to YouTube RSS feeds and yt-dlp download URLs; no Offcast servers

### Post-MVP (Phase 6–7)

#### 5.7 Android Share Intent

- **Share from YouTube app**: Select Offcast in share sheet
- **Smart detection**: Channel URL → subscribe flow; Video URL → direct download
- **One-tap subscribe**: Confirmation dialog → subscribed in 2 taps total

#### 5.8 Queue Management

- **Manual queue**: Add any episode to "Up Next"
- **Continuous play**: Auto-advances through queue
- **Shuffle mode**: Shuffle queued episodes

#### 5.9 Playback Statistics (Local)

- Total listening time (stored locally)
- Episodes played per channel
- Exportable as JSON (user-owned data)

---

## 6. User Experience Design

### Design Philosophy

1. **Audio-first**: Video is a bonus feature; every UI decision prioritizes listening
2. **Zero friction**: Subscribing and playing should take under 10 seconds
3. **Podcast-familiar**: Users of Pocket Casts / Overcast should feel at home immediately
4. **Dark by default**: Target users (commuters, night listeners) prefer dark mode

### Navigation Structure

```
Bottom Navigation Bar:
├── 🏠 Home (Recent Episodes Feed)
├── 📻 Subscriptions (Channel List)
├── 📥 Downloads (Queue + Storage)
└── ⚙️ Settings

Persistent Mini Player (above bottom nav, when playing):
[▶/⏸] [Episode Title — Channel Name] [↕ Expand]
```

### Screen-by-Screen Flow

#### Home Screen
```
┌─────────────────────────────┐
│  Offcast              [+]   │
├─────────────────────────────┤
│  Recently Downloaded        │
│  ┌───┐ Episode Title        │
│  │ 📷│ Channel Name · 45m   │
│  └───┘ ████░░░░░░ 42%       │
│                             │
│  ┌───┐ Episode Title        │
│  │ 📷│ Channel Name · 1h 2m │
│  └───┘ ○ Not started        │
│  ...                        │
├─────────────────────────────┤
│  [▶] Now Playing ─────────  │ ← Mini Player
└─────────────────────────────┘
```

#### Player Screen (Audio Mode)
```
┌─────────────────────────────┐
│  ← Channel Name             │
│                             │
│   ┌─────────────────────┐   │
│   │                     │   │
│   │   [Thumbnail Art]   │   │
│   │                     │   │
│   └─────────────────────┘   │
│                             │
│  Episode Title              │
│  Channel Name               │
│                             │
│  ──────●────────────  24:13 │
│  00:00              1:02:45 │
│                             │
│  [◀10] [⏮]  [▶/⏸]  [⏭] [30▶]│
│                             │
│  [1.5×]          [🌙 30min] │
│                             │
│  [🎬 Watch 480p]            │
└─────────────────────────────┘
```

#### Add Channel Screen
```
┌─────────────────────────────┐
│  ← Add Channel              │
│                             │
│  Paste YouTube URL or @handle│
│  ┌─────────────────────┐    │
│  │ youtube.com/@...    │[→] │
│  └─────────────────────┘    │
│                             │
│  [Preview after URL lookup] │
│  ┌─────────────────────────┐│
│  │ 📷 Channel Name         ││
│  │    1.2M subscribers     ││
│  │    Latest: "Episode..." ││
│  └─────────────────────────┘│
│                             │
│  Auto-download: [ON]        │
│  Keep last: [10 episodes ▼] │
│  Mode: [Audio only ▼]       │
│                             │
│  [Subscribe]                │
└─────────────────────────────┘
```

### Onboarding Flow

```
Launch → 
  [1] "Welcome to Offcast" — 3-slide intro (10 sec skip available)
  [2] Battery optimization exception request (with explanation)
  [3] Add your first channel (can skip)
  → Home Screen
```

---

## 7. Technical Architecture

### Technology Choices

| Layer | Technology | Rationale |
|---|---|---|
| Framework | Flutter (Dart) | Best AI code-gen quality; cross-platform ready for future iOS support |
| Download engine | yt-dlp (ARM64 binary, bundled) | No server needed; official Android binary available; community-maintained |
| Database | Drift (SQLite) | Type-safe, supports migrations, excellent Flutter integration |
| State management | Riverpod | Compile-safe, testable, scales well |
| Background work | WorkManager | Official Android solution; handles Doze mode correctly |
| Audio playback | just_audio + audio_service | Podcast-grade; handles background, lock screen, BT controls |
| Video playback | video_player | Flutter-official; sufficient for 480p |
| Navigation | go_router | Deep link support; Android back stack aware |

### Download Engine Design

```
yt-dlp is bundled as a compiled ARM64 binary (~15MB).
No server. No API keys. No rate limits from Offcast's side.

Audio download:
  yt-dlp -f bestaudio -x --audio-format opus
  → Single stream, no ffmpeg merge required
  → Output: {videoId}.opus (~30MB / 30min)

Video download (480p, optional):
  yt-dlp -f best[height<=480]
  → Single combined stream (video+audio), no ffmpeg merge required
  → Output: {videoId}.mp4 (~250MB / 30min)

APK binary assets:
  assets/binaries/yt-dlp  (~15MB ARM64)
  # ffmpeg NOT bundled → APK size ~20-25MB total
```

### Database Schema

```sql
-- Channel subscriptions
CREATE TABLE channels (
  id             INTEGER PRIMARY KEY AUTOINCREMENT,
  channel_id     TEXT NOT NULL UNIQUE,  -- UCxxxxxx
  name           TEXT NOT NULL,
  thumbnail_url  TEXT,
  added_at       INTEGER NOT NULL,      -- Unix timestamp
  auto_download  INTEGER DEFAULT 1,     -- 0 | 1
  max_episodes   INTEGER DEFAULT 10,
  download_mode  TEXT DEFAULT 'audio'   -- 'audio' | 'video_480p'
);

-- Episode index
CREATE TABLE episodes (
  id                   INTEGER PRIMARY KEY AUTOINCREMENT,
  video_id             TEXT NOT NULL UNIQUE,
  channel_id           TEXT NOT NULL,
  title                TEXT NOT NULL,
  thumbnail_url        TEXT,
  duration_sec         INTEGER,
  published_at         INTEGER,
  audio_path           TEXT,            -- null if not downloaded
  video_path           TEXT,            -- null if video not downloaded
  download_mode        TEXT DEFAULT 'none',  -- 'none'|'audio'|'video_480p'
  downloaded_at        INTEGER,
  playback_position_sec INTEGER DEFAULT 0,
  is_played            INTEGER DEFAULT 0,
  file_size_bytes      INTEGER
);
```

### Privacy Architecture

```
No Offcast servers.
No analytics SDK.
No user identifiers.

Network calls made by the app:
  1. YouTube RSS feed (public, no auth):
     GET https://www.youtube.com/feeds/videos.xml?channel_id={id}
  2. yt-dlp download URLs:
     Direct to YouTube CDN (same as browser)
  3. Optional: yt-dlp update check (github.com/yt-dlp/releases)

Data stored:
  - On-device SQLite only
  - No cloud sync
  - User can export or delete all data
```

---

## 8. Distribution Strategy

### Primary: GitHub Releases

- APK signed with a consistent key (auto-generated, stored in GitHub Secrets)
- GitHub Actions CI builds APK on every tagged release
- Update notification: App checks GitHub Releases API on launch
- Download URL: `https://github.com/offcast-app/offcast/releases/latest`

### Secondary: F-Droid

- Submit to F-Droid repository after MVP stabilizes
- F-Droid builds from source (no bundled binary concern if we document the build process)
- Alternative: IzzyOnDroid repository (faster review cycle than main F-Droid)

### Community Distribution

| Channel | Strategy |
|---|---|
| Reddit (r/androidapps, r/YoutubeRevanced) | Launch post with demo video |
| XDA Developers | Thread with technical deep-dive |
| GitHub (organic) | Good README + demo GIF → stars → discovery |
| Hacker News | "Show HN" post at launch |
| YouTube creators | Reach out to 5–10 mid-size creators whose fans would use this |

### Auto-Update Mechanism

```dart
// On app launch: check GitHub Releases API
GET https://api.github.com/repos/offcast-app/offcast/releases/latest
→ Compare tag_name with BuildConfig.VERSION_NAME
→ If newer: show "Update available" banner (non-intrusive)
→ Tap → open GitHub releases page in browser
```

---

## 9. Monetization Strategy

### Phase 1: Free & Open Source (0 → 10,000 users)

- No monetization. Build trust, grow user base.
- Accept GitHub Sponsors / Open Collective donations

### Phase 2: Sponsorship (10,000 → 100,000 users)

**Primary: VPN Sponsorship**

This user demographic (privacy-conscious, tech-forward, APK installers) has the highest VPN conversion rate of any app category. Comparable apps charge:
- $0.01–$0.05 CPM for banner ads (privacy users use adblockers → near-zero)
- $2,000–$10,000/month flat sponsorship for 50K–200K MAU apps

**Implementation**: In-app "Sponsors" section (clearly labeled, never intrusive). One sponsor slot. No tracking pixels.

### Phase 3: Sustainable Model (100,000+ users)

| Revenue Stream | Mechanism | Est. Monthly (100K users) |
|---|---|---|
| VPN sponsorship | Flat fee, 1 sponsor | $5,000–$15,000 |
| GitHub Sponsors | Voluntary | $500–$2,000 |
| Open Collective | Voluntary | $200–$500 |
| **Total** | | **$5,700–$17,500/mo** |

**Monetization principles (non-negotiable):**
- ❌ No ad SDKs (Google AdMob, Meta Audience Network, etc.)
- ❌ No user profiling or behavioral tracking
- ❌ No personal data sale
- ❌ No freemium feature gating on core functionality
- ✅ Sponsors clearly disclosed in app and README
- ✅ Aggregate, anonymized, non-re-identifiable usage stats only (opt-out available)

---

## 10. Roadmap

### MVP — Phase 1 (Target: Month 1–2)

```
[ ] Flutter project setup + dependency configuration
[ ] SQLite database schema (Drift)
[ ] yt-dlp binary bundling + initialization
[ ] Audio-only download via yt-dlp (bestaudio)
[ ] YouTube RSS feed parsing
[ ] Channel subscription (add by URL)
[ ] Basic episode list UI
[ ] Audio playback (just_audio)
[ ] Background audio service (audio_service)
[ ] WorkManager auto-download scheduler (Wi-Fi only)
[ ] GitHub Actions CI + APK release build
[ ] First public APK release (alpha)
```

### Feature Complete — Phase 2 (Target: Month 3–4)

```
[ ] Full podcast player controls (speed, sleep timer, skip)
[ ] Playback position persistence
[ ] 480p video download + video_player integration
[ ] Android Share Intent receiver
[ ] Episode queue management
[ ] Storage management (auto-delete played episodes)
[ ] Onboarding flow
[ ] Update checker (GitHub Releases API)
[ ] F-Droid / IzzyOnDroid submission
```

### Polish & Growth — Phase 3 (Target: Month 5–6)

```
[ ] Android Auto support
[ ] Playlist / Queue with shuffle
[ ] Per-channel download filters (e.g., episodes > 20 minutes only)
[ ] Local playback statistics
[ ] Data export (JSON)
[ ] Community feedback integration
[ ] VPN sponsorship integration (if 10K+ users)
```

### Future Considerations (Not Committed)

```
[ ] iOS support (requires different distribution strategy; no APK)
[ ] Chapter support (if available in yt-dlp metadata)
[ ] Silence skip / smart speed
[ ] OPML import/export (for portability with other podcast apps)
[ ] Widget (Android 12+ home screen widget for quick play)
```

---

## 11. Risk Assessment

### High Impact Risks

| Risk | Probability | Impact | Mitigation |
|---|---|---|---|
| YouTube blocks yt-dlp | Medium | High | Community patches within 24–72h historically; in-app update notifier for yt-dlp binary; user communication via GitHub |
| GitHub DMCA takedown | Low | High | Maintain a mirror repo; document mirror in README; yt-dlp itself has survived DMCA |
| YouTube ToS action against maintainer | Very Low | Very High | No commercial streaming; no re-distribution of content; purely local download for personal use |
| Android battery optimization kills WorkManager | High | Medium | User onboarding prompts battery exception; document per-manufacturer workarounds |
| F-Droid rejects due to bundled binary | Medium | Low | IzzyOnDroid as fallback; GitHub Releases as primary |

### Low Impact Risks

| Risk | Mitigation |
|---|---|
| yt-dlp ARM64 binary breaks on specific Android version | User bug reports via GitHub Issues; yt-dlp release notes monitoring |
| 480p combined stream unavailable for some videos | Fallback to lowest available combined stream; log gracefully |
| Drift schema migration issues on app update | Versioned migrations enforced from day 1 |

---

## 12. AI Development Workflow

Offcast is built using a **human-in-the-loop AI development** model. This is documented transparently as a core part of the project's methodology.

### Roles

| Role | Tool | Responsibility |
|---|---|---|
| Architecture & Strategy | Claude (Anthropic) | System design, risk analysis, spec writing, prompt engineering |
| Code Generation | Gemini (Google) | Flutter/Dart implementation from phase-by-phase prompts |
| Code Review | OpenAI Codex (pending) | PR review, security analysis, optimization suggestions |
| QA & Testing | Claude + manual | Edge case identification, test scenario design |

### AI Workflow: Phase-by-Phase Code Generation

Each development phase uses a structured prompt template:

```
Context: [Project overview, confirmed tech stack, prior phase output]
Task: [Specific files to implement]
Constraints: [Clean Architecture, no print statements, proper typing]
Output format: [Complete file contents, no placeholders]
```

Prompts are documented in `docs/GEMINI_PROMPTS.md` and updated after each phase completion.

### Why This Approach Is Effective for This Project

1. **Scope is well-defined**: Each feature has a clear input/output contract (yt-dlp command → file on disk)
2. **Well-documented dependencies**: All packages have extensive examples for AI to learn from
3. **Iterative testing**: Each phase produces a testable artifact before moving to the next
4. **Human judgment on architecture**: AI generates code; humans decide what to build and why

### Open Source Commitment

- All code, prompts, and architecture decisions are public on GitHub
- The AI workflow itself is documented to serve as a reference for other developers building with AI
- Issues, PRs, and discussions are open to community contribution

---

## Appendix A: yt-dlp Command Reference

```bash
# Audio-only download (DEFAULT)
yt-dlp \
  -f bestaudio \
  -x \
  --audio-format opus \
  --no-playlist \
  -o "%(id)s.%(ext)s" \
  "https://www.youtube.com/watch?v={videoId}"
# Result: {videoId}.opus, ~30MB/30min, no ffmpeg needed

# 480p video download (OPTIONAL)
yt-dlp \
  -f "best[height<=480]" \
  --no-playlist \
  -o "%(id)s.%(ext)s" \
  "https://www.youtube.com/watch?v={videoId}"
# Result: {videoId}.mp4, ~250MB/30min, no ffmpeg needed

# Channel metadata only (no download)
yt-dlp \
  --flat-playlist \
  --playlist-items 1:10 \
  --dump-json \
  "https://www.youtube.com/channel/{channelId}"

# Handle → Channel ID resolution
yt-dlp \
  --flat-playlist \
  --playlist-items 0 \
  --dump-json \
  "https://www.youtube.com/@{handle}"
# Parse: result["channel_id"]
```

## Appendix B: YouTube RSS Feed

```
Public endpoint (no API key required):
https://www.youtube.com/feeds/videos.xml?channel_id={CHANNEL_ID}

Returns Atom XML. Key fields:
<yt:videoId>   → video ID
<title>        → episode title
<published>    → ISO 8601 date
<media:thumbnail url="..."> → thumbnail URL
<yt:statistics views="..."> → view count (bonus metadata)

Rate limit: Not officially documented; ~1 req/channel/15min is safe
```

## Appendix C: Key Flutter Packages

```yaml
dependencies:
  # Audio
  just_audio: ^0.9.x          # Core audio engine
  audio_service: ^0.18.x      # Background + lock screen

  # Background work
  workmanager: ^0.5.x         # Android WorkManager wrapper

  # Network
  connectivity_plus: ^6.x     # Wi-Fi detection
  http: ^1.x                  # HTTP client
  xml: ^6.x                   # XML/RSS parser

  # Database
  drift: ^2.x                 # Type-safe SQLite ORM
  drift_flutter: ^0.2.x       # Flutter integration

  # File system
  path_provider: ^2.x         # Platform-correct paths
  path: ^1.x                  # Path manipulation

  # Android integration
  receive_sharing_intent: ^1.x # Share sheet receiver

  # Video (optional mode)
  video_player: ^2.x          # 480p video playback

  # State & navigation
  flutter_riverpod: ^2.x      # State management
  go_router: ^14.x            # Declarative routing
```
