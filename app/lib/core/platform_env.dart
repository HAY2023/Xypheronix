import 'package:flutter/foundation.dart';

/// PlatformEnv — single source of truth for "which device are we on?"
///
/// Uses [kIsWeb] + [defaultTargetPlatform] ONLY (no `dart:io`), so this file
/// is safe to import from shared UI code that also has to compile for Web.
///
///  - Desktop  -> Windows / macOS / Linux  (window chrome, tray, USB serial)
///  - Mobile   -> Android / iOS            (touch UI, BLE link, no window chrome)
///  - Web      -> browser                  (no native hardware bridge yet)
class PlatformEnv {
  PlatformEnv._();

  /// Running inside a web browser.
  static bool get isWeb => kIsWeb;

  /// Running on a desktop OS (Windows / macOS / Linux).
  static bool get isDesktop {
    if (kIsWeb) return false;
    switch (defaultTargetPlatform) {
      case TargetPlatform.windows:
      case TargetPlatform.macOS:
      case TargetPlatform.linux:
        return true;
      default:
        return false;
    }
  }

  /// Running on a phone or tablet (Android / iOS).
  static bool get isMobile {
    if (kIsWeb) return false;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
      case TargetPlatform.iOS:
        return true;
      default:
        return false;
    }
  }

  /// Custom window chrome / drag bar / minimise-maximise-close.
  static bool get supportsWindowChrome => isDesktop;

  /// System tray + "hide to tray" behaviour.
  static bool get supportsSystemTray => isDesktop;

  /// USB serial link to the hardware vault (desktop only).
  /// Phones talk to the device over BLE instead (see roadmap).
  static bool get supportsSerialPort => isDesktop;

  /// Local WebSocket auto-save bridge (browser extension -> desktop app).
  static bool get supportsLocalBridge => isDesktop;
}
