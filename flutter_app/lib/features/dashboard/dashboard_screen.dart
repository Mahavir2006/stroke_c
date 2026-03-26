/// Stroke Mitra - Dashboard Screen
///
/// Premium home screen with personalized greeting, status bar,
/// 2x2 gradient test cards, and animated entrance.

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../app/theme.dart';
import '../../shared/widgets/disclaimer_widget.dart';
import '../../shared/widgets/gradient_card.dart';
import '../auth/providers/auth_provider.dart';
import '../full_checkup/full_checkup_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

String _greeting(BuildContext context) {
  final hour = DateTime.now().hour;
  if (hour < 12) return context.l10n.dashboard_greetingMorning;
  if (hour < 17) return context.l10n.dashboard_greetingAfternoon;
  return context.l10n.dashboard_greetingEvening;
}

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colors = context.colors;
    final l10n = context.l10n;
    final profile = ref.watch(userProfileProvider);
    final firstName = profile.whenOrNull(
          data: (p) => p?['full_name']?.toString().split(' ').first,
        ) ??
        '';

    final greeting = _greeting(context);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppTheme.spaceSM),

          // ─── Greeting ───
          Text(
            firstName.isNotEmpty
                ? l10n.dashboard_greetingWithName(greeting, firstName)
                : greeting,
            style: GoogleFonts.outfit(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
            ),
          )
              .animate()
              .fadeIn(duration: 400.ms, curve: Curves.easeOut)
              .slideY(begin: 0.1, end: 0, duration: 400.ms),
          const SizedBox(height: 4),
          Text(
            l10n.dashboard_readyCheck,
            style: TextStyle(
              fontSize: 15,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          )
              .animate()
              .fadeIn(duration: 400.ms, delay: 80.ms, curve: Curves.easeOut),
          const SizedBox(height: 6),
          // Accent line
          Container(
            width: 40,
            height: 3,
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(2),
            ),
          ).animate().scaleX(
              begin: 0,
              end: 1,
              duration: 500.ms,
              delay: 200.ms,
              alignment: Alignment.centerLeft,
              curve: Curves.easeOutCubic),

          const SizedBox(height: AppTheme.spaceLG),

          // ─── Quick Status Bar ───
          SizedBox(
            height: 80,
            child: Row(
              children: [
                Expanded(
                  child: _StatusMiniCard(
                    icon: Icons.schedule_rounded,
                    label: l10n.dashboard_lastCheck,
                    value: l10n.dashboard_today,
                    color: theme.colorScheme.primary,
                    surface: colors.primarySurface,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _StatusMiniCard(
                    icon: Icons.favorite_rounded,
                    label: l10n.dashboard_status,
                    value: l10n.dashboard_allClear,
                    color: AppTheme.statusSuccess,
                    surface: colors.successSurface,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _StatusMiniCard(
                    icon: Icons.trending_up_rounded,
                    label: l10n.dashboard_streak,
                    value: l10n.dashboard_days(3),
                    color: AppTheme.accent,
                    surface: colors.accentSurface,
                  ),
                ),
              ],
            ),
          )
              .animate()
              .fadeIn(duration: 400.ms, delay: 150.ms)
              .slideY(begin: 0.15, end: 0, duration: 400.ms, delay: 150.ms),

          const SizedBox(height: AppTheme.spaceLG),

          // ─── Full Check-up CTA ───
          _FullCheckupButton(
            onTap: () {
              ref.read(fullCheckupProvider.notifier).reset();
              context.go('/checkup');
            },
          )
              .animate()
              .fadeIn(duration: 400.ms, delay: 260.ms)
              .slideY(begin: 0.1, end: 0, duration: 400.ms, delay: 260.ms),

          const SizedBox(height: AppTheme.spaceLG),

          // ─── Section Label ───
          Text(
            l10n.dashboard_screeningTests,
            style: AppTheme.labelTag.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.35),
            ),
          ).animate().fadeIn(duration: 300.ms, delay: 250.ms),
          const SizedBox(height: AppTheme.spaceMD),

          // ─── 2x2 Test Cards Grid ───
          Column(
            children: [
              _ScreeningCard(
                icon: Icons.camera_alt_rounded,
                gradient: colors.faceGradient,
                title: l10n.dashboard_faceAnalysis,
                subtitle: l10n.dashboard_detectFacialDrooping,
                onTap: () => context.go('/face'),
              )
                  .animate()
                  .fadeIn(duration: 400.ms, delay: 300.ms)
                  .slideY(begin: 0.15, end: 0, duration: 400.ms, delay: 300.ms),
              const SizedBox(height: 12),
              _ScreeningCard(
                icon: Icons.mic_rounded,
                gradient: colors.voiceGradient,
                title: l10n.dashboard_voiceCheck,
                subtitle: l10n.dashboard_analyzeSpeech,
                onTap: () => context.go('/voice'),
              )
                  .animate()
                  .fadeIn(duration: 400.ms, delay: 380.ms)
                  .slideY(begin: 0.15, end: 0, duration: 400.ms, delay: 380.ms),
              const SizedBox(height: 12),
              _ScreeningCard(
                icon: Icons.show_chart_rounded,
                gradient: colors.motionGradient,
                title: l10n.dashboard_motionTest,
                subtitle: l10n.dashboard_assessArmStability,
                onTap: () => context.go('/motion'),
              )
                  .animate()
                  .fadeIn(duration: 400.ms, delay: 460.ms)
                  .slideY(begin: 0.15, end: 0, duration: 400.ms, delay: 460.ms),
              const SizedBox(height: 12),
              _ScreeningCard(
                icon: Icons.touch_app_rounded,
                gradient: colors.tapGradient,
                title: l10n.dashboard_tapTest,
                subtitle: l10n.dashboard_fingerCoordination,
                onTap: () => context.go('/tap'),
              )
                  .animate()
                  .fadeIn(duration: 400.ms, delay: 540.ms)
                  .slideY(begin: 0.15, end: 0, duration: 400.ms, delay: 540.ms),
            ],
          ),

          const SizedBox(height: AppTheme.spaceLG),

          // ─── Disclaimer ───
          const DisclaimerWidget()
              .animate()
              .fadeIn(duration: 400.ms, delay: 600.ms),

          const SizedBox(height: AppTheme.spaceLG),
        ],
      ),
    );
  }
}

// ─── Full Check-up Button ────────────────────────────────────────────────────
class _FullCheckupButton extends StatelessWidget {
  final VoidCallback onTap;
  const _FullCheckupButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
        decoration: BoxDecoration(
          gradient: AppTheme.primaryGradient,
          borderRadius: BorderRadius.circular(AppTheme.radiusLG),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0B6B5D).withValues(alpha: 0.35),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.play_circle_filled_rounded,
                color: Colors.white, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(l10n.dashboard_startFullCheckup,
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    )),
                Text(l10n.dashboard_allTestsOneSession,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: Colors.white.withValues(alpha: 0.8),
                    )),
              ])),
          const Icon(Icons.arrow_forward_ios_rounded,
              color: Colors.white, size: 18),
        ]),
      ),
    );
  }
}

class _StatusMiniCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final Color surface;

  const _StatusMiniCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.surface,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusMD),
        border: Border.all(color: color.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: color.withValues(alpha: 0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Screening Card ──────────────────────────────────────────────────────────
class _ScreeningCard extends StatelessWidget {
  final IconData icon;
  final Gradient gradient;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ScreeningCard({
    required this.icon,
    required this.gradient,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(AppTheme.radiusMD),
          border: Border.all(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.08),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
            ),
          ],
        ),
      ),
    );
  }
}
