# Mahfadha Pro — Universal (One App, Every Device)

Mahfadha Pro is now a **single Flutter codebase** that runs on:

| Platform | Status | How it talks to the hardware vault |
| --- | --- | --- |
| Windows / macOS / Linux (Desktop) | ✅ Supported | USB serial (`flutter_libserialport`) + local WebSocket bridge |
| Android / iOS (Phone & Tablet) | ✅ Supported (UI ready) | Bluetooth LE link *(transport on the roadmap below)* |
| Web (Browser) | 🟡 Next phase | Web BLE / WebSerial *(needs `dart:io` removed first)* |

The goal: **جهاز واحد — تطبيق واحد — كل الأجهزة.** The same vault UI, the same
five sections, the same theme, adapting itself to whatever screen it runs on.

## How the adaptivity works

### 1. Platform detection — `lib/core/platform_env.dart`
A tiny, **web-safe** helper (`kIsWeb` + `defaultTargetPlatform`, **no `dart:io`**).
Use `PlatformEnv.isDesktop / isMobile / isWeb` and the capability flags
(`supportsWindowChrome`, `supportsSystemTray`, `supportsSerialPort`,
`supportsLocalBridge`) instead of checking `Platform.isWindows` directly in UI code.

### 2. Responsive layout — `lib/main.dart`
The dashboard uses a `LayoutBuilder` with a breakpoint of **800px**:

- **Wide (desktop / tablet landscape):** left `AppSidebar` + content.
- **Narrow (phone):** content + `AppBottomNav` (`lib/widgets/responsive_scaffold.dart`).

The custom desktop title bar (`AppTitleBar`) is only rendered when
`PlatformEnv.supportsWindowChrome` is true, so phones get a clean full-screen UI.

### 3. Desktop-only services are guarded
`window_manager`, `tray_manager`, `windows_single_instance` and the serial
`TaskManager` are only initialised when `PlatformEnv.isDesktop`. On phones the
app boots straight into the adaptive UI without touching those plugins.

## Building

> ⚠️ The repo only tracks `lib/` + `pubspec.yaml`. The native platform folders
> (`android/`, `ios/`, `windows/`, `web/`) are **generated on demand**:

```bash
cd app
flutter create --project-name mahfadha_companion --platforms=windows,android,ios,web .
flutter pub get

# Phone
flutter build apk --release        # Android
# Desktop
flutter build windows --release    # Windows
```

### Automated CI (add manually)
> This file could not be committed automatically because the integration token
> lacks the GitHub `workflow` scope. Create
> `.github/workflows/build-multiplatform.yml` with the following content:

```yaml
name: Build Mahfadha Pro (Multi-platform)
on:
  push:
    branches: ["feat/universal-multiplatform", "main"]
  workflow_dispatch:
jobs:
  build:
    name: Build $ matrix.name 
    runs-on: $ matrix.os 
    strategy:
      fail-fast: false
      matrix:
        include:
          - { name: Windows Desktop, os: windows-latest, target: windows }
          - { name: Android APK, os: ubuntu-latest, target: apk }
    defaults:
      run:
        working-directory: app
    steps:
      - uses: actions/checkout@v4
      - if: matrix.target == 'apk'
        uses: actions/setup-java@v4
        with: { distribution: temurin, java-version: "17" }
      - uses: subosito/flutter-action@v2
        with: { channel: stable }
      - run: flutter create --project-name mahfadha_companion --platforms=windows,android,ios,web .
      - run: flutter pub get
      - if: matrix.target == 'apk'
        run: flutter build apk --release
      - if: matrix.target == 'windows'
        run: flutter build windows --release
```

## Roadmap to finish universal support

1. **BLE transport for phones** — add a `flutter_blue_plus` implementation of the
   hardware link (mirror of `services/hardware_service.dart`) so the phone can
   pair with the ESP32 vault over Bluetooth LE. The UI is already device-agnostic.
2. **True Web build** — remove/abstract every `dart:io` import
   (`main.dart` asset paths, `task_manager.dart`, services) behind
   conditional imports, then enable `flutter build web`.
3. **Generate & commit platform folders** if you prefer reproducible native
   builds over `flutter create` in CI.
4. **Reconcile README** — it still references the ATECC608A secure element; the
   current hardware is a 3-component design (microSD + ESP32 CYD + R503).
