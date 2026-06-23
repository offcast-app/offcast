# Contributing to Offcast

Thank you for your interest in contributing!

## Getting Started

### Prerequisites
- Flutter SDK (stable channel)
- Android Studio or VS Code with Flutter extension
- Android device or emulator (API 26+)

### Setup
```bash
git clone https://github.com/lucas-distill/offcast.git
cd offcast
flutter pub get
flutter run
```

## How to Contribute

### Reporting Bugs
- Use [GitHub Issues](https://github.com/lucas-distill/offcast/issues)
- Include Android version, device model, and steps to reproduce
- If yt-dlp broke (YouTube patched something), label it `yt-dlp-compat`

### Pull Requests
1. Fork the repo
2. Create a feature branch: `git checkout -b feature/sleep-timer`
3. Commit with clear messages
4. Open a PR with a description of what changed and why

### Priority Areas
- yt-dlp binary update automation
- Battery optimization for background sync
- Audio focus handling edge cases
- F-Droid reproducible build setup

## Code Style
- Follow standard Flutter/Dart conventions
- Run `flutter analyze` before submitting
- Keep files under 300 lines (split by responsibility)

## License
By contributing, you agree your code will be licensed under GPL-3.0.
