import 'package:flutter/material.dart';
import 'package:stroke_mitra/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../app/theme_provider.dart';

enum _MenuItem { profile, theme, medicalReports }

/// Hamburger menu that replaces the theme toggle + profile icon in AppShell.
/// Drop it into any AppBar's `actions` list.
class AppMenu extends ConsumerWidget {
  const AppMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = context.isDark;

    return PopupMenuButton<_MenuItem>(
      icon: Icon(Icons.menu_rounded,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.7)),
      tooltip: 'Menu',
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      elevation: 8,
      color: theme.colorScheme.surface,
      offset: const Offset(0, 48),
      onSelected: (item) {
        switch (item) {
          case _MenuItem.profile:
            context.push('/profile');
          case _MenuItem.theme:
            ref.read(themeModeProvider.notifier).toggle();
          case _MenuItem.medicalReports:
            context.push('/medical-reports');
        }
      },
      itemBuilder: (context) {
        final l10n = AppLocalizations.of(context);
        return [
          _menuItem(
            context: context,
            value: _MenuItem.profile,
            icon: Icons.person_rounded,
            label: l10n.menu_profile,
          ),
          _menuItem(
            context: context,
            value: _MenuItem.theme,
            icon: isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
            label: isDark ? l10n.menu_lightMode : l10n.menu_darkMode,
          ),
          _menuItem(
            context: context,
            value: _MenuItem.medicalReports,
            icon: Icons.description_rounded,
            label: l10n.menu_medicalReports,
          ),
        ];
      },
    );
  }

  PopupMenuItem<_MenuItem> _menuItem({
    required BuildContext context,
    required _MenuItem value,
    required IconData icon,
    required String label,
  }) {
    final theme = Theme.of(context);
    return PopupMenuItem<_MenuItem>(
      value: value,
      child: Row(children: [
        Icon(icon,
            size: 20,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7)),
        const SizedBox(width: 12),
        Text(label,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onSurface)),
      ]),
    );
  }
}
