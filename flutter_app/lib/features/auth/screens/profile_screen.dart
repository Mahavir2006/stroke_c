// Stroke Mitra - Profile Screen
//
/// Premium profile with gradient banner, baseline photo,
/// theme settings, and animated entrance.

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../app/locale_provider.dart';
import '../../../app/theme.dart';
import '../../../app/theme_provider.dart';
import '../providers/auth_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  Uint8List? _baselineImageBytes;
  bool _isLoadingImage = true;

  @override
  void initState() {
    super.initState();
    _loadBaselineImage();
  }

  Future<void> _loadBaselineImage() async {
    if (mounted) setState(() => _isLoadingImage = true);
    try {
      final client = Supabase.instance.client;
      final userId = client.auth.currentUser?.id;
      if (userId == null) return;

      final path = '$userId/baseline.jpg';
      final bytes = await client.storage.from('face-images').download(path);

      if (mounted) {
        setState(() {
          _baselineImageBytes = bytes;
          _isLoadingImage = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoadingImage = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final profileAsyncValue = ref.watch(userProfileProvider);
    final theme = Theme.of(context);
    final colors = context.colors;
    final themeMode = ref.watch(themeModeProvider);
    final themeNotifier = ref.read(themeModeProvider.notifier);
    final currentLocale = ref.watch(localeProvider);
    final localeNotifier = ref.read(localeProvider.notifier);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: profileAsyncValue.when(
        data: (profile) {
          if (profile == null) {
            return Center(child: Text(context.l10n.profile_notFound));
          }
          final name = profile['full_name'] ?? 'User';
          final initial = name[0].toUpperCase();

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(userProfileProvider);
              await _loadBaselineImage();
            },
            child: CustomScrollView(
              slivers: [
                // ─── Gradient Header ───
                SliverToBoxAdapter(
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        height: 160,
                        decoration: BoxDecoration(
                          gradient: colors.heroGradient,
                        ),
                        child: SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () => Navigator.of(context).pop(),
                                  child: Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(Icons.arrow_back_rounded,
                                        color: Colors.white, size: 20),
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  context.l10n.profile_title,
                                  style: GoogleFonts.outfit(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                const Spacer(),
                                const SizedBox(width: 36),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: -40,
                        child: Center(
                          child: Container(
                            width: 84,
                            height: 84,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: theme.scaffoldBackgroundColor,
                                width: 4,
                              ),
                              boxShadow: AppTheme.shadowMD,
                            ),
                            child: CircleAvatar(
                              radius: 38,
                              backgroundColor: theme.colorScheme.primary,
                              backgroundImage: _baselineImageBytes != null
                                  ? MemoryImage(_baselineImageBytes!)
                                  : null,
                              child: _baselineImageBytes == null
                                  ? Text(
                                      initial,
                                      style: GoogleFonts.outfit(
                                        fontSize: 32,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    )
                                  : null,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ─── Name & Email ───
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 52),
                    child: Column(
                      children: [
                        Text(
                          name,
                          style: GoogleFonts.outfit(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          profile['email'] ?? user?.email ?? '',
                          style: TextStyle(
                            fontSize: 14,
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(duration: 400.ms, delay: 100.ms),
                ),

                SliverPadding(
                  padding: const EdgeInsets.all(AppTheme.spaceMD),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      const SizedBox(height: AppTheme.spaceSM),

                      // ─── Stats Row ───
                      Row(
                        children: [
                          _StatCard(
                            label: context.l10n.profile_memberSince,
                            value: _formatShortDate(profile['created_at']),
                            icon: Icons.calendar_today_rounded,
                          ),
                          const SizedBox(width: 10),
                          _StatCard(
                            label: context.l10n.profile_testsTaken,
                            value: '—',
                            icon: Icons.assessment_rounded,
                          ),
                          const SizedBox(width: 10),
                          _StatCard(
                            label: context.l10n.profile_lastCheck,
                            value: context.l10n.dashboard_today,
                            icon: Icons.schedule_rounded,
                          ),
                        ],
                      )
                          .animate()
                          .fadeIn(duration: 400.ms, delay: 200.ms)
                          .slideY(begin: 0.1, end: 0, duration: 400.ms, delay: 200.ms),

                      const SizedBox(height: AppTheme.spaceLG),

                      // ─── Baseline Photo ───
                      _SectionCard(
                        icon: Icons.face_retouching_natural_rounded,
                        title: context.l10n.profile_baselinePhoto,
                        subtitle: context.l10n.profile_baselineSubtitle,
                        child: _isLoadingImage
                            ? Container(
                                height: 180,
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.surfaceContainerHighest,
                                  borderRadius: BorderRadius.circular(AppTheme.radiusMD),
                                ),
                                child: Center(
                                  child: SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                ),
                              )
                            : _baselineImageBytes != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(AppTheme.radiusMD),
                                    child: Image.memory(
                                      _baselineImageBytes!,
                                      height: 180,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Container(
                                    height: 140,
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.surfaceContainerHighest,
                                      borderRadius: BorderRadius.circular(AppTheme.radiusMD),
                                    ),
                                    child: Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.face_rounded,
                                              size: 36,
                                              color: theme.colorScheme.onSurface.withValues(alpha: 0.2)),
                                          const SizedBox(height: 8),
                                          Text(context.l10n.profile_noBaseline,
                                              style: TextStyle(fontSize: 13, color: theme.colorScheme.onSurface.withValues(alpha: 0.4))),
                                          const SizedBox(height: 2),
                                          Text(context.l10n.profile_captureBaseline,
                                              style: TextStyle(fontSize: 11, color: theme.colorScheme.onSurface.withValues(alpha: 0.25))),
                                        ],
                                      ),
                                    ),
                                  ),
                      ).animate().fadeIn(duration: 400.ms, delay: 300.ms).slideY(begin: 0.1, end: 0, duration: 400.ms, delay: 300.ms),

                      const SizedBox(height: AppTheme.spaceMD),

                      // ─── Appearance ───
                      _SectionCard(
                        icon: Icons.palette_rounded,
                        title: context.l10n.profile_appearance,
                        subtitle: context.l10n.profile_appearanceSubtitle,
                        child: _ThemeSelector(
                          current: themeMode,
                          onChanged: themeNotifier.setMode,
                          systemLabel: context.l10n.profile_themeSystem,
                          lightLabel: context.l10n.profile_themeLight,
                          darkLabel: context.l10n.profile_themeDark,
                        ),
                      ).animate().fadeIn(duration: 400.ms, delay: 400.ms).slideY(begin: 0.1, end: 0, duration: 400.ms, delay: 400.ms),

                      const SizedBox(height: AppTheme.spaceMD),

                      // ─── Language ───
                      _SectionCard(
                        icon: Icons.translate_rounded,
                        title: context.l10n.profile_language,
                        subtitle: context.l10n.profile_languageSubtitle,
                        child: _LanguageSelector(
                          current: currentLocale,
                          onChanged: localeNotifier.setLocale,
                        ),
                      ).animate().fadeIn(duration: 400.ms, delay: 450.ms).slideY(begin: 0.1, end: 0, duration: 400.ms, delay: 450.ms),

                      const SizedBox(height: AppTheme.spaceMD),

                      // ─── Account ───
                      _SectionCard(
                        icon: Icons.settings_rounded,
                        title: context.l10n.profile_account,
                        child: _ActionRow(
                          icon: Icons.logout_rounded,
                          label: context.l10n.profile_signOut,
                          color: AppTheme.statusError,
                          onTap: () => ref.read(authControllerProvider.notifier).signOut(),
                        ),
                      ).animate().fadeIn(duration: 400.ms, delay: 500.ms).slideY(begin: 0.1, end: 0, duration: 400.ms, delay: 500.ms),

                      const SizedBox(height: AppTheme.spaceMD),

                      // ─── Privacy Info ───
                      Container(
                        padding: const EdgeInsets.all(AppTheme.spaceMD),
                        decoration: BoxDecoration(
                          color: colors.primarySurface,
                          borderRadius: BorderRadius.circular(AppTheme.radiusMD),
                          border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.1)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.shield_rounded, color: theme.colorScheme.primary, size: 18),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                context.l10n.profile_privacy,
                                style: TextStyle(fontSize: 12, color: theme.colorScheme.primary),
                              ),
                            ),
                          ],
                        ),
                      ).animate().fadeIn(duration: 400.ms, delay: 600.ms),

                      const SizedBox(height: AppTheme.spaceLG),
                    ]),
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => Center(
          child: CircularProgressIndicator(color: theme.colorScheme.primary),
        ),
        error: (err, stack) => Center(child: Text(context.l10n.profile_errorLoading(err.toString()))),
      ),
    );
  }

  String _formatShortDate(String? isoDate) {
    if (isoDate == null) return '—';
    try {
      final date = DateTime.parse(isoDate).toLocal();
      const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
      return '${months[date.month - 1]} ${date.year}';
    } catch (_) {
      return '—';
    }
  }
}

// ─── Reusable Private Widgets ────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final String label, value;
  final IconData icon;
  const _StatCard({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(AppTheme.radiusMD),
          border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.15)),
        ),
        child: Column(
          children: [
            Icon(icon, size: 16, color: theme.colorScheme.onSurface.withValues(alpha: 0.3)),
            const SizedBox(height: 6),
            Text(value, style: GoogleFonts.jetBrainsMono(fontSize: 14, fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface)),
            Text(label, style: TextStyle(fontSize: 10, color: theme.colorScheme.onSurface.withValues(alpha: 0.4))),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget child;
  const _SectionCard({required this.icon, required this.title, this.subtitle, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceLG),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusLG),
        border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.12)),
        boxShadow: AppTheme.shadowSM,
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(icon, color: theme.colorScheme.primary, size: 20),
          const SizedBox(width: 8),
          Text(title, style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface)),
        ]),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Text(subtitle!, style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface.withValues(alpha: 0.45))),
        ],
        const SizedBox(height: AppTheme.spaceMD),
        child,
      ]),
    );
  }
}

class _ThemeSelector extends StatelessWidget {
  final ThemeMode current;
  final ValueChanged<ThemeMode> onChanged;
  final String systemLabel;
  final String lightLabel;
  final String darkLabel;
  const _ThemeSelector({required this.current, required this.onChanged, required this.systemLabel, required this.lightLabel, required this.darkLabel});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      _ThemeOption(icon: Icons.brightness_auto_rounded, label: systemLabel, isSelected: current == ThemeMode.system, onTap: () => onChanged(ThemeMode.system)),
      const SizedBox(width: 8),
      _ThemeOption(icon: Icons.light_mode_rounded, label: lightLabel, isSelected: current == ThemeMode.light, onTap: () => onChanged(ThemeMode.light)),
      const SizedBox(width: 8),
      _ThemeOption(icon: Icons.dark_mode_rounded, label: darkLabel, isSelected: current == ThemeMode.dark, onTap: () => onChanged(ThemeMode.dark)),
    ]);
  }
}

class _ThemeOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  const _ThemeOption({required this.icon, required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? theme.colorScheme.primary.withValues(alpha: 0.1) : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(AppTheme.radiusMD),
            border: Border.all(color: isSelected ? theme.colorScheme.primary.withValues(alpha: 0.3) : Colors.transparent),
          ),
          child: Column(children: [
            Icon(icon, size: 20, color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface.withValues(alpha: 0.4)),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(fontSize: 11, fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400, color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface.withValues(alpha: 0.5))),
          ]),
        ),
      ),
    );
  }
}

class _LanguageSelector extends StatelessWidget {
  final Locale current;
  final ValueChanged<Locale> onChanged;
  const _LanguageSelector({required this.current, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      _LanguageOption(label: 'English', locale: const Locale('en'), isSelected: current.languageCode == 'en', onTap: () => onChanged(const Locale('en'))),
      const SizedBox(width: 8),
      _LanguageOption(label: 'हिन्दी', locale: const Locale('hi'), isSelected: current.languageCode == 'hi', onTap: () => onChanged(const Locale('hi'))),
      const SizedBox(width: 8),
      _LanguageOption(label: 'मराठी', locale: const Locale('mr'), isSelected: current.languageCode == 'mr', onTap: () => onChanged(const Locale('mr'))),
    ]);
  }
}

class _LanguageOption extends StatelessWidget {
  final String label;
  final Locale locale;
  final bool isSelected;
  final VoidCallback onTap;
  const _LanguageOption({required this.label, required this.locale, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? theme.colorScheme.primary.withValues(alpha: 0.1) : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(AppTheme.radiusMD),
            border: Border.all(color: isSelected ? theme.colorScheme.primary.withValues(alpha: 0.3) : Colors.transparent),
          ),
          child: Center(
            child: Text(label, style: TextStyle(fontSize: 13, fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400, color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface.withValues(alpha: 0.5))),
          ),
        ),
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _ActionRow({required this.icon, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Text(label, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: color)),
          const Spacer(),
          Icon(Icons.chevron_right_rounded, color: color.withValues(alpha: 0.5), size: 20),
        ]),
      ),
    );
  }
}
