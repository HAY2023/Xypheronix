// Mahfadha — Connection Hub: Bluetooth Low Energy transport.
// Phone ↔ device wireless link (and optionally a BLE-capable desktop).
//
// This scaffold compiles with the current dependency set. To make it live:
//   1) add `flutter_blue_plus` to pubspec.yaml,
//   2) flip [isSupported] to use PlatformEnv.isMobile,
//   3) replace the TODO sections with real scan/connect/notify calls.

import 'dart:async';
import 'dart:typed_data';

import 'connection_transport.dart';

class BleTransport implements ConnectionTransport {
  // Proposed Mahfadha GATT contract:
  //   Service     0000a1fa-...  vault transport service
  //   TX (write)  0000a1fb-...  app -> device frames
  //   RX (notify) 0000a1fc-...  device -> app frames
  static const String serviceUuid = '0000a1fa-0000-1000-8000-00805f9b34fb';
  static const String txCharUuid = '0000a1fb-0000-1000-8000-00805f9b34fb';
  static const String rxCharUuid = '0000a1fc-0000-1000-8000-00805f9b34fb';

  final StreamController<DeviceLink> _controller =
      StreamController<DeviceLink>.broadcast();
  DeviceLink _current = DeviceLink.disconnected(TransportKind.bluetooth);

  @override
  TransportKind get kind => TransportKind.bluetooth;

  // Becomes true once flutter_blue_plus is wired in (see header note).
  @override
  bool get isSupported => false;

  @override
  Stream<DeviceLink> get linkUpdates => _controller.stream;

  @override
  DeviceLink get current => _current;

  @override
  Future<void> start() async {
    if (!isSupported) {
      _emit(DeviceLink.disconnected(TransportKind.bluetooth));
      return;
    }
    // TODO(flutter_blue_plus): FlutterBluePlus.startScan(withServices: [Guid(serviceUuid)]);
    // On found: connect, discoverServices, subscribe to RX notify, then:
    //   _emit(DeviceLink(kind: TransportKind.bluetooth, connected: true,
    //       peerName: 'هاتف', endpoint: remoteId, detail: 'BLE'));
  }

  void _emit(DeviceLink link) {
    _current = link;
    if (!_controller.isClosed) _controller.add(link);
  }

  @override
  Future<void> send(Uint8List frame) async {
    if (!isSupported) {
      throw UnsupportedError('BLE غير مفعّل بعد — أضف flutter_blue_plus');
    }
    // TODO(flutter_blue_plus): write [frame] to the TX characteristic
    // (with response) on the connected device.
  }

  @override
  Future<void> stop() async {
    if (!_controller.isClosed) await _controller.close();
  }
}
