/// Hamburger menu dropdown replacing top-left controls.
/// Provides access to Profile, Theme Toggle, and Medical Report.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../app/theme_provider.dart';

class HamburgerMenuWidget extends ConsumerStatefulWidget {
  const HamburgerMenuWidget({super.key});

  @override
  ConsumerState<HamburgerMenuWidget> createState() =>
      _HamburgerMenuWidgetState();
}

class _HamburgerMenuWidgetState extends ConsumerState<HamburgerMenuWidget> {
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();

  void _toggleMenu() {
    if (_overlayEntry != null) {
      _removeOverlay();
    } else {
      _showOverlay();
    }
  }

  void _showOverlay() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry() {
    final theme = Theme.of(context);
    final isDark = context.isDark;
    final themeNotifier = ref.read(themeModeProvider.notifier);

    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Barrier to close on outside tap
          Positioned.fill(
            child: GestureDetector(
              onTap: _removeOverlay,
              behavior: HitTestBehavior.translucent,
              child: Container(color: Colors.transparent),
            ),
          ),
          // Dropdown menu
          Positioned(
            width: 220,
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: const Offset(0, 50),
              child: Material(
                color: Colors.transparent,
                child: TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 150),
                  tween: Tween(begin: 0.0, end: 1.0),
                  curve: Curves.easeOut,
                  builder: (context, value, child) {
                    return Transform.translate(
                      offset: Offset(0, -10 * (1 - value)),
                      child: Opacity(
                        opacity: value,
                        child: child,
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: theme.colorScheme.outline.withValues(alpha: 0.2),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _MenuItem(
                          icon: Icons.person_outline,
                          label: 'Profile',
                          onTap: () {
                            _removeOverlay();
                            context.push('/profile');
                          },
                        ),
                        Divider(
                          height: 1,
                          color:
                              theme.colorScheme.outline.withValues(alpha: 0.1),
                        ),
                        _MenuItem(
                          icon: isDark
                              ? Icons.light_mode_rounded
                              : Icons.dark_mode_rounded,
                          label: 'Color Theme',
                          onTap: () {
                            themeNotifier.toggle();
                            _removeOverlay();
                          },
                        ),
                        Divider(
                          height: 1,
                          color:
                              theme.colorScheme.outline.withValues(alpha: 0.1),
                        ),
                        _MenuItem(
                          icon: Icons.health_and_safety_outlined,
                          label: 'Medical Report',
                          onTap: () {
                            _removeOverlay();
                            context.go('/medical-report');
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CompositedTransformTarget(
      link: _layerLink,
      child: IconButton(
        icon: Icon(
          Icons.menu,
          size: 24,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
        ),
        onPressed: _toggleMenu,
        tooltip: 'Menu',
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
