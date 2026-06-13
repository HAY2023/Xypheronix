import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/app_state.dart';
import '../theme/mars_theme.dart';

/// AppBottomNav — phone / narrow-screen navigation.
///
/// The desktop build uses [AppSidebar]; on phones (and any window narrower
/// than the responsive breakpoint) we swap to this bottom navigation bar so
/// the same sections stay reachable with a thumb.
///
/// الرئيسية | الحسابات | جهات الاتصال | الاتصال | التحديثات | الإعدادات
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({super.key});

  static const List<_NavSpec> _items = [
    _NavSpec(SidebarPage.home, Icons.dashboard_rounded, 'الرئيسية'),
    _NavSpec(SidebarPage.accounts, Icons.key_rounded, 'الحسابات'),
    _NavSpec(SidebarPage.phones, Icons.phone_android_rounded, 'جهات الاتصال'),
    _NavSpec(SidebarPage.connection, Icons.cable_rounded, 'الاتصال'),
    _NavSpec(SidebarPage.updates, Icons.system_update_alt_rounded, 'التحديثات'),
    _NavSpec(SidebarPage.settings, Icons.settings_rounded, 'الإعدادات'),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, _) {
        return Container(
          decoration: BoxDecoration(
            color: MarsTheme.spaceNavy,
            border: Border(
              top: BorderSide(
                color: MarsTheme.cyanNeon.withOpacity(0.10),
                width: 1,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.35),
                blurRadius: 14,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  for (final item in _items)
                    _BottomNavButton(
                      item: item,
                      isActive: state.currentPage == item.page,
                      onTap: () => state.setCurrentPage(item.page),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _NavSpec {
  final SidebarPage page;
  final IconData icon;
  final String label;
  const _NavSpec(this.page, this.icon, this.label);
}

class _BottomNavButton extends StatelessWidget {
  final _NavSpec item;
  final bool isActive;
  final VoidCallback onTap;

  const _BottomNavButton({
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? MarsTheme.cyanNeon : MarsTheme.textMuted;
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                decoration: BoxDecoration(
                  color: isActive
                      ? MarsTheme.cyanNeon.withOpacity(0.12)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(item.icon, size: 22, color: color),
              ),
              const SizedBox(height: 3),
              Text(
                item.label,
                style: GoogleFonts.cairo(
                  color: color,
                  fontSize: 10.5,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
