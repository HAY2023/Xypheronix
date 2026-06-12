// Mahfadha — Connection Hub: unified transport abstraction.
// Defines the contract every link to the Mahfadha device implements,
// whether the physical channel is USB (wired) or Bluetooth (BLE).

import 'dart:async';
import 'dart:typed_data';

/// The physical channel used to reach the device.
enum TransportKind { usb, bluetooth, none }

extension TransportKindLabel on TransportKind {
  String get arabicLabel {
    switch (this) {
      case TransportKind.usb:
        return 'USB سلكي';
      case TransportKind.bluetooth:
        return 'Bluetooth';
      case TransportKind.none:
        return 'غير متصل';
    }
  }
}

/// Security state of the channel. The hub only treats the vault as usable
/// once the active channel reaches [encrypted] after a successful handshake.
enum ChannelSecurity { insecure, handshaking, encrypted }

extension ChannelSecurityLabel on ChannelSecurity {
  String get arabicLabel {
    switch (this) {
      case ChannelSecurity.insecure:
        return 'غير مشفّرة';
      case ChannelSecurity.handshaking:
        return 'جارٍ التحقق';
      case ChannelSecurity.encrypted:
        return 'مشفّرة ✓';
    }
  }
}

/// A snapshot of a single link's state, surfaced to the UI.
class DeviceLink {
  final TransportKind kind;
  final bool connected;
  final String? peerName; // the other side, e.g. "الحاسوب" / "هاتف"
  final String? endpoint; // serial port path, or BLE remote id
  final ChannelSecurity security;
  final String? detail; // free-form, e.g. "تسلسلي 115200" / "BLE"

  const DeviceLink({
    required this.kind,
    required this.connected,
    this.peerName,
    this.endpoint,
    this.security = ChannelSecurity.insecure,
    this.detail,
  });

  DeviceLink copyWith({
    bool? connected,
    String? peerName,
    String? endpoint,
    ChannelSecurity? security,
    String? detail,
  }) {
    return DeviceLink(
      kind: kind,
      connected: connected ?? this.connected,
      peerName: peerName ?? this.peerName,
      endpoint: endpoint ?? this.endpoint,
      security: security ?? this.security,
      detail: detail ?? this.detail,
    );
  }

  factory DeviceLink.disconnected(TransportKind kind) =>
      DeviceLink(kind: kind, connected: false);
}

/// Common contract for USB and BLE transports.
abstract class ConnectionTransport {
  TransportKind get kind;

  /// Whether this transport can run on the current platform/build.
  bool get isSupported;

  /// Continuous stream of link state updates.
  Stream<DeviceLink> get linkUpdates;

  /// Most recent known state (synchronous access for the UI).
  DeviceLink get current;

  /// Begin monitoring / scanning for the device.
  Future<void> start();

  /// Stop and release resources.
  Future<void> stop();

  /// Send a framed message to the device over this channel.
  Future<void> send(Uint8List frame);
}
