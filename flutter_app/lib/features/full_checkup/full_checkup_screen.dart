import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../app/theme.dart';
import '../face_analysis/face_provider.dart';
import '../voice_check/voice_provider.dart';
import '../motion_test/motion_provider.dart';
import '../tap_test/tap_test_provider.dart';
import 'full_checkup_provider.dart';
import 'widgets/checkup_face_step.dart';
import 'widgets/checkup_voice_step.dart';
import 'widgets/checkup_motion_step.dart';
import 'widgets/checkup_tap_step.dart';

class FullCheckupScreen extends ConsumerWidget {
  const FullCheckupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(fullCheckupProvider);

    ref.listen(fullCheckupProvider, (prev, next) {
      if (next.currentStep == CheckupStep.report && next.allDone) {
        context.go('/checkup/report');
      }
    });

    final stepIndex = state.currentStep.index.clamp(0, 3);
    final labels = [context.l10n.checkup_stepFace, context.l10n.checkup_stepVoice, context.l10n.checkup_stepMotion, context.l10n.checkup_stepTap];
    const icons = [
      Icons.camera_alt_rounded,
      Icons.mic_rounded,
      Icons.show_chart_rounded,
      Icons.touch_app_rounded,
    ];

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _showExitDialog(context, ref);
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          surfaceTintColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.close_rounded),
            onPressed: () => _showExitDialog(context, ref),
            tooltip: context.l10n.checkup_exitTooltip,
          ),
          title: Text(
            context.l10n.checkup_fullCheckup,
            style:
                GoogleFonts.outfit(fontWeight: FontWeight.w700, fontSize: 18),
          ),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(57),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 1,
                  color: Theme.of(context)
                      .colorScheme
                      .outline
                      .withValues(alpha: 0.1),
                ),
                _StepProgressBar(
                  currentIndex: stepIndex,
                  labels: labels,
                  icons: icons,
                ),
              ],
            ),
          ),
        ),
        body: _CheckupBody(step: state.currentStep),
      ),
    );
  }

  void _showExitDialog(BuildContext context, WidgetRef ref) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusLG)),
        title: Text(context.l10n.checkup_exitTitle,
            style: GoogleFonts.outfit(fontWeight: FontWeight.w700)),
        content: Text(
          context.l10n.checkup_exitMessage,
          style: const TextStyle(fontSize: 14, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(context.l10n.checkup_stay),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.statusError,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              ref.read(faceProvider.notifier).reset();
              ref.read(voiceProvider.notifier).reset();
              ref.read(motionProvider.notifier).reset();
              ref.read(tapTestProvider.notifier).reset();
              ref.read(fullCheckupProvider.notifier).reset();
              context.go('/app');
            },
            child: Text(context.l10n.checkup_exit),
          ),
        ],
      ),
    );
  }
}

// ─── Body ─────────────────────────────────────────────────────────────────────
class _CheckupBody extends StatelessWidget {
  final CheckupStep step;
  const _CheckupBody({required this.step});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: _buildStep(step),
      ),
    );
  }

  Widget _buildStep(CheckupStep step) {
    switch (step) {
      case CheckupStep.face:
        return const CheckupFaceStep();
      case CheckupStep.voice:
        return const CheckupVoiceStep();
      case CheckupStep.motion:
        return const CheckupMotionStep();
      case CheckupStep.tap:
        return const CheckupTapStep();
      case CheckupStep.report:
        return const SizedBox.shrink();
    }
  }
}

// ─── Step Progress Bar ────────────────────────────────────────────────────────
class _StepProgressBar extends StatelessWidget {
  final int currentIndex;
  final List<String> labels;
  final List<IconData> icons;

  const _StepProgressBar({
    required this.currentIndex,
    required this.labels,
    required this.icons,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: List.generate(labels.length, (i) {
          final isDone = i < currentIndex;
          final isActive = i == currentIndex;
          final color = isDone || isActive
              ? theme.colorScheme.primary
              : theme.colorScheme.outline.withValues(alpha: 0.4);
          return Expanded(
            child: Row(children: [
              Expanded(
                child: Column(children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: isActive ? 32 : 24,
                    height: isActive ? 32 : 24,
                    decoration: BoxDecoration(
                      color: isDone
                          ? AppTheme.statusSuccess
                          : isActive
                              ? theme.colorScheme.primary
                              : theme.colorScheme.outline
                                  .withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isDone ? Icons.check_rounded : icons[i],
                      size: isActive ? 16 : 12,
                      color: isDone || isActive
                          ? Colors.white
                          : theme.colorScheme.outline,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(labels[i],
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight:
                              isActive ? FontWeight.w700 : FontWeight.w400,
                          color: color)),
                ]),
              ),
              if (i < labels.length - 1)
                Expanded(
                  child: Container(
                    height: 2,
                    margin: const EdgeInsets.only(bottom: 18),
                    color: isDone
                        ? AppTheme.statusSuccess
                        : theme.colorScheme.outline.withValues(alpha: 0.2),
                  ),
                ),
            ]),
          );
        }),
      ),
    );
  }
}
