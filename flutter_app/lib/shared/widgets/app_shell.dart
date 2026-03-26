/// Stroke Mitra - App Shell (Layout)
///
/// Premium navigation shell with frosted AppBar, modern bottom nav,
/// theme toggle, and smooth page transitions.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../app/theme.dart';
import 'app_menu.dart';
import '../../app/theme_provider.dart';
import 'hamburger_menu_widget.dart';

class AppShell extends ConsumerWidget {
  final Widget child;
  const AppShell({super.key, required this.child});

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/face')) return 1;
    if (location.startsWith('/voice')) return 2;
    if (location.startsWith('/motion')) return 3;
    if (location.startsWith('/tap')) return 4;
    return 0;
  }

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/app');
      case 1:
        context.go('/face');
      case 2:
        context.go('/voice');
      case 3:
        context.go('/motion');
      case 4:
        context.go('/tap');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final idx = _currentIndex(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: const HamburgerMenuWidget(),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Logo icon
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.monitor_heart_outlined,
                  color: Colors.white, size: 18),
            ),
            const SizedBox(width: 10),
            Text('Stroke Mitra',
                style: GoogleFonts.outfit(
                    fontWeight: FontWeight.w700,
                    fontSize: 19,
                    color: theme.colorScheme.onSurface)),
          ],
        ),
        centerTitle: false,
        actions: const [
          AppMenu(),
        ],
        backgroundColor: theme.scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
              height: 1,
              color: theme.colorScheme.outline.withValues(alpha: 0.1)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppTheme.spaceMD),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: child,
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          border: Border(
              top: BorderSide(
                  color: theme.colorScheme.outline.withValues(alpha: 0.1))),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(
                    icon: Icons.home_outlined,
                    activeIcon: Icons.home_rounded,
                    label: context.l10n.nav_home,
                    isActive: idx == 0,
                    onTap: () => _onTap(context, 0)),
                _NavItem(
                    icon: Icons.camera_alt_outlined,
                    activeIcon: Icons.camera_alt_rounded,
                    label: context.l10n.nav_face,
                    isActive: idx == 1,
                    onTap: () => _onTap(context, 1)),
                _NavItem(
                    icon: Icons.mic_none_rounded,
                    activeIcon: Icons.mic_rounded,
                    label: context.l10n.nav_voice,
                    isActive: idx == 2,
                    onTap: () => _onTap(context, 2)),
                _NavItem(
                    icon: Icons.show_chart_rounded,
                    activeIcon: Icons.show_chart_rounded,
                    label: context.l10n.nav_motion,
                    isActive: idx == 3,
                    onTap: () => _onTap(context, 3)),
                _NavItem(
                    icon: Icons.touch_app_outlined,
                    activeIcon: Icons.touch_app_rounded,
                    label: context.l10n.nav_tap,
                    isActive: idx == 4,
                    onTap: () => _onTap(context, 4)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isActive
        ? theme.colorScheme.primary
        : theme.colorScheme.onSurface.withValues(alpha: 0.4);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? theme.colorScheme.primary.withValues(alpha: 0.08)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedScale(
              scale: isActive ? 1.1 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: Icon(isActive ? activeIcon : icon, color: color, size: 22),
            ),
            const SizedBox(height: 3),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                color: color,
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}
