// Mahfadha — Connection Hub brain.
// Aggregates every transport, tracks which one is live, and routes outgoing
// frames to the active channel. Exposed to the UI as a ChangeNotifier.

import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';

import 'connection_transport.dart';

class ConnectionManager extends ChangeNotifier {
  final List<ConnectionTransport> _transports;
  final Map<TransportKind, DeviceLink> _links = {};
  final List<StreamSubscription<DeviceLink>> _subs = [];

  ConnectionManager(this._transports) {
    for (final t in _transports) {
      _links[t.kind] = t.current;
    }
  }

  DeviceLink linkFor(TransportKind kind) =>
      _links[kind] ?? DeviceLink.disconnected(kind);

  DeviceLink get usb => linkFor(TransportKind.usb);
  DeviceLink get bluetooth => linkFor(TransportKind.bluetooth);

  bool get anyConnected => _links.values.any((l) => l.connected);

  /// The active transport: USB takes priority over BLE when both are live.
  TransportKind get activeKind {
    final connected =
        _transports.where((t) => linkFor(t.kind).connected).toList();
    if (connected.isEmpty) return TransportKind.none;
    connected.sort((a, b) => _priority(b.kind) - _priority(a.kind));
    return connected.first.kind;
  }

  int _priority(TransportKind k) =>
      k == TransportKind.usb ? 2 : (k == TransportKind.bluetooth ? 1 : 0);

  /// True only when the active channel finished its handshake and is encrypted.
  bool get isSecure =>
      activeKind != TransportKind.none &&
      linkFor(activeKind).security == ChannelSecurity.encrypted;

  Future<void> startAll() async {
    for (final t in _transports) {
      _subs.add(t.linkUpdates.listen((link) {
        _links[t.kind] = link;
        notifyListeners();
      }));
      if (t.isSupported) {
        await t.start();
      }
    }
    notifyListeners();
  }

  /// Send a frame over the active channel.
  Future<void> send(Uint8List frame) async {
    final kind = activeKind;
    if (kind == TransportKind.none) {
      throw StateError('لا توجد وسيلة اتصال نشطة');
    }
    final t = _transports.firstWhere((t) => t.kind == kind);
    await t.send(frame);
  }

  @override
  void dispose() {
    for (final s in _subs) {
      s.cancel();
    }
    for (final t in _transports) {
      t.stop();
    }
    super.dispose();
  }
}
