<p align="center">
  <img src="assets/logo.png" alt="Offcast Logo" width="120"/>
</p>

<h1 align="center">Offcast</h1>

<p align="center">
  <strong>YouTube channels, experienced like podcasts.</strong><br/>
  Subscribe. Auto-download on Wi-Fi. Listen offline.
</p>

<p align="center">
  <a href="https://github.com/offcast-app/offcast/releases"><img src="https://img.shields.io/github/v/release/offcast-app/offcast?style=flat-square&label=Download%20APK" alt="Download APK"/></a>
  <a href="https://github.com/offcast-app/offcast/blob/main/LICENSE"><img src="https://img.shields.io/badge/license-MIT-blue?style=flat-square" alt="License: MIT"/></a>
  <a href="https://github.com/offcast-app/offcast/stargazers"><img src="https://img.shields.io/github/stars/offcast-app/offcast?style=flat-square" alt="Stars"/></a>
  <img src="https://img.shields.io/badge/platform-Android-3DDC84?style=flat-square&logo=android" alt="Android"/>
  <img src="https://img.shields.io/badge/built%20with-Flutter-54C5F8?style=flat-square&logo=flutter" alt="Flutter"/>
  <a href="docs/PRODUCT_SPEC.md"><img src="https://img.shields.io/badge/docs-Product%20Spec-orange?style=flat-square" alt="Product Spec"/></a>
</p>

---

## The Problem

You follow 10 YouTube channels you actually *listen* to — tech talks, interviews, essays, commentary. But YouTube's app is built for watching, not listening.

- No auto-download on Wi-Fi for specific channels
- No podcast-grade playback controls (fine-grained speed, sleep timer, silence skip)
- No "new episodes" queue like a podcast app
- Offline requires YouTube Premium

Podcast apps can't help either — they can't download YouTube content.

**The gap:** There is no single app that treats YouTube channels as podcast subscriptions with proper offline, listening-first UX.

Offcast fills that gap.

---

## What Offcast Does

| Feature | Description |
|---|---|
| 📡 **Channel Subscriptions** | Subscribe to any YouTube channel like a podcast feed |
| ⬇️ **Wi-Fi Auto-Download** | New videos automatically downloaded when on Wi-Fi |
| 🎧 **Listening-First Player** | Speed control (0.5x–3.0x), sleep timer, silence skip, chapter skip |
| 📱 **Android Share Integration** | Share any YouTube URL directly into Offcast |
| 📂 **Offline-First** | All content stored locally, works without internet |
| 🔋 **Battery-Aware** | Background sync respects battery saver and idle states |
| 🗂️ **Episode Queue** | Manage your listening queue like Pocket Casts or Overcast |

---

## Why Not YouTube Premium?

Premium locks offline content inside the YouTube app. No speed control beyond 2x, no silence skip, no cross-app queue management, no persistent listening history across sessions.

Offcast downloads to local storage. Your content, your player.

## Why Not NewPipe?

NewPipe is a YouTube *viewer*. Offcast is a YouTube *listener*. Different UX, different purpose.

---

## Tech Stack

- **Framework:** Flutter (Android)
- **Download Engine:** [yt-dlp](https://github.com/yt-dlp/yt-dlp) ARM binary (bundled, no server required)
- **Audio Playback:** `just_audio` + `audio_service`
- **Background Sync:** WorkManager via Flutter plugin
- **Storage:** SQLite (drift)

---

## Installation

> Offcast is not on the Play Store. Download the APK directly.

1. Enable **Install unknown apps** for your browser in Android Settings
2. Download the latest APK from [Releases](https://github.com/lucas-distill/offcast/releases)
3. Install and open Offcast

F-Droid listing coming soon.

---

## Roadmap

- [x] Project setup
- [ ] yt-dlp ARM binary integration
- [ ] Channel subscription + RSS polling
- [ ] Wi-Fi-only auto-download scheduler
- [ ] Audio player with speed control
- [ ] Sleep timer + silence skip
- [ ] Android Share intent handler
- [ ] Episode queue management
- [ ] F-Droid submission

---

## Contributing

Offcast is open source and welcomes contributions.

```
git clone https://github.com/lucas-distill/offcast.git
cd offcast
flutter pub get
flutter run
```

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

---

## Legal

Offcast does not host, stream, or redistribute any content. It uses yt-dlp to download videos the user explicitly requests, for personal offline use. Users are responsible for compliance with YouTube's Terms of Service in their jurisdiction.

---

## License

[MIT](LICENSE)

---

<p align="center">
  Built because podcast apps don't do YouTube, and YouTube doesn't do podcasts.
</p>
