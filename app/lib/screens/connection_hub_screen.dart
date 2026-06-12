// Mahfadha — "ركن الاتصال": shows which device is connected and over which
// channel (USB / Bluetooth), plus a security banner when the active channel
// is not yet encrypted.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/transport/connection_transport.dart';
import '../core/transport/connection_manager.dart';
import '../theme/mars_theme.dart';

class ConnectionHubScreen extends StatelessWidget {
  const ConnectionHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectionManager>(
      builder: (context, manager, _) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'ركن الاتصال',
                  style: TextStyle(
                    color: MarsTheme.cyanNeon,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'يكتشف الجهاز المتصل والوسيلة (USB / Bluetooth)',
                  style: TextStyle(color: MarsTheme.textSecondary),
                ),
                const SizedBox(height: 20),
                _LinkCard(link: manager.usb),
                const SizedBox(height: 12),
                _LinkCard(link: manager.bluetooth),
                const SizedBox(height: 20),
                _SecurityBanner(secure: manager.isSecure),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _LinkCard extends StatelessWidget {
  final DeviceLink link;
  const _LinkCard({required this.link});

  @override
  Widget build(BuildContext context) {
    final connected = link.connected;
    final accent = connected ? MarsTheme.success : MarsTheme.textMuted;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: MarsTheme.spaceNavy,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: accent.withOpacity(0.6)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  link.kind.arabicLabel,
                  style: TextStyle(
                    color: MarsTheme.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  connected
                      ? 'الجهاز: ${link.peerName ?? '—'} · ${link.detail ?? ''}'
                      : 'غير متصل',
                  style:
                      TextStyle(color: MarsTheme.textSecondary, fontSize: 13),
                ),
              ],
            ),
          ),
          _StatusPill(connected: connected, security: link.security),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final bool connected;
  final ChannelSecurity security;
  const _StatusPill({required this.connected, required this.security});

  @override
  Widget build(BuildContext context) {
    final color = !connected
        ? MarsTheme.textMuted
        : (security == ChannelSecurity.encrypted
            ? MarsTheme.success
            : MarsTheme.warning);
    final label = !connected
        ? '○ غير متصل'
        : (security == ChannelSecurity.encrypted
            ? '● متصل ومشفّر'
            : '● متصل');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Text(
        label,
        style:
            TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _SecurityBanner extends StatelessWidget {
  final bool secure;
  const _SecurityBanner({required this.secure});

  @override
  Widget build(BuildContext context) {
    final color = secure ? MarsTheme.success : MarsTheme.error;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            secure ? '🛡️ القناة مشفّرة' : '⚠️ ملاحظة أمنية — الأمان ينقص',
            style: TextStyle(
                color: color, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 6),
          Text(
            secure
                ? 'تم التحقق من التطبيق والقناة مشفّرة بمفتاح الجلسة.'
                : 'القناة الحالية بنص واضح بلا تحقق من هوية التطبيق. سيتم التشفير بمفتاح الجلسة (session_key/ble_key) بعد المصافحة وقبل أي عملية فتح للخزنة.',
            style: TextStyle(
                color: MarsTheme.textSecondary, fontSize: 13, height: 1.5),
          ),
        ],
      ),
    );
  }
}
