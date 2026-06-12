// Mahfadha — Connection Hub: USB (wired serial) transport.
// Detects the Mahfadha device by polling available serial ports.
// Desktop only — mobile/web report unsupported.

import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_libserialport/flutter_libserialport.dart';

import '../platform_env.dart';
import 'connection_transport.dart';

class UsbTransport implements ConnectionTransport {
  static const int baudRate = 115200;
  static const Duration _pollInterval = Duration(seconds: 2);

  final StreamController<DeviceLink> _controller =
      StreamController<DeviceLink>.broadcast();
  Timer? _poll;
  SerialPort? _port;
  DeviceLink _current = DeviceLink.disconnected(TransportKind.usb);

  @override
  TransportKind get kind => TransportKind.usb;

  @override
  bool get isSupported => PlatformEnv.supportsSerialPort;

  @override
  Stream<DeviceLink> get linkUpdates => _controller.stream;

  @override
  DeviceLink get current => _current;

  @override
  Future<void> start() async {
    if (!isSupported) return;
    _scan();
    _poll = Timer.periodic(_pollInterval, (_) => _scan());
  }

  void _scan() {
    try {
      final ports = SerialPort.availablePorts;
      if (ports.isEmpty) {
        _emit(DeviceLink.disconnected(TransportKind.usb));
        return;
      }
      // Heuristic: treat the first available port as the device endpoint.
      // A production build should match by the ESP32 board USB VID/PID.
      final endpoint = ports.first;
      _emit(DeviceLink(
        kind: TransportKind.usb,
        connected: true,
        peerName: 'الحاسوب',
        endpoint: endpoint,
        security: ChannelSecurity.insecure, // upgraded after handshake
        detail: 'تسلسلي $baudRate',
      ));
    } catch (_) {
      _emit(DeviceLink.disconnected(TransportKind.usb));
    }
  }

  void _emit(DeviceLink link) {
    _current = link;
    if (!_controller.isClosed) _controller.add(link);
  }

  @override
  Future<void> send(Uint8List frame) async {
    if (!_current.connected || _current.endpoint == null) {
      throw StateError('USB غير متصل');
    }
    final port = _port ??= SerialPort(_current.endpoint!);
    if (!port.isOpen) {
      port.openReadWrite();
      port.config = SerialPortConfig()..baudRate = baudRate;
    }
    port.write(frame);
  }

  @override
  Future<void> stop() async {
    _poll?.cancel();
    _poll = null;
    try {
      _port?.close();
    } catch (_) {}
    _port = null;
    if (!_controller.isClosed) await _controller.close();
  }
}
