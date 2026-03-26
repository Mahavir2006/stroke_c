import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../app/theme.dart';
import '../../motion_test/motion_provider.dart';
import '../../motion_test/motion_service.dart';
import '../../motion_test/motion_test_screen.dart'
    show BallVisualiser, MotionResultCard, MotionMetricBox;
import '../full_checkup_provider.dart';

class CheckupMotionStep extends ConsumerWidget {
  const CheckupMotionStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final state = ref.watch(motionProvider);
    final notifier = ref.read(motionProvider.notifier);

    // Forward result
    ref.listen(motionProvider, (prev, next) {
      if (next.result != null && prev?.result == null) {
        // Don't auto-advance; let user see result and tap continue
      }
    });

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spaceMD),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(children: [
          Icon(Icons.accessibility_new_rounded,
              color: theme.colorScheme.primary, size: 22),
          const SizedBox(width: 8),
          Text(context.l10n.motion_title,
              style: AppTheme.headingMD
                  .copyWith(color: theme.colorScheme.onSurface)),
        ]),
        const SizedBox(height: AppTheme.spaceSM),
        Container(
          padding: const EdgeInsets.all(AppTheme.spaceMD),
          decoration: BoxDecoration(
            color: context.colors.primarySurface,
            borderRadius: BorderRadius.circular(AppTheme.radiusMD),
            border: Border.all(
                color: theme.colorScheme.primary.withValues(alpha: 0.2)),
          ),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Icon(Icons.info_outline,
                color: theme.colorScheme.primary, size: 20),
            const SizedBox(width: AppTheme.spaceSM),
            Expanded(
                child: Text(
              context.l10n.motion_instruction(MotionService.recordingSeconds),
              style: GoogleFonts.inter(
                  fontSize: 14,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  height: 1.5),
            )),
          ]),
        ),
        const SizedBox(height: AppTheme.spaceLG),
        Center(
            child: BallVisualiser(
          offsetX: state.ballOffsetX,
          offsetY: state.ballOffsetY,
          riskLevel: state.result?.riskLevel,
          isRecording: state.isRecording,
        )),
        const SizedBox(height: AppTheme.spaceLG),
        if (state.isRecording) ...[
          Row(children: [
            MotionMetricBox(
                label: context.l10n.motion_xTilt, value: state.liveX.toStringAsFixed(2)),
            const SizedBox(width: AppTheme.spaceSM),
            MotionMetricBox(
                label: context.l10n.motion_yTilt, value: state.liveY.toStringAsFixed(2)),
            const SizedBox(width: AppTheme.spaceSM),
            MotionMetricBox(
                label: context.l10n.motion_timeLeft,
                value:
                    '${MotionService.recordingSeconds - state.elapsedSeconds}s'),
          ]),
          const SizedBox(height: AppTheme.spaceMD),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: state.elapsedSeconds / MotionService.recordingSeconds,
              minHeight: 8,
              backgroundColor: theme.colorScheme.outline.withValues(alpha: 0.3),
              valueColor:
                  AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
            ),
          ),
          const SizedBox(height: 6),
          Text(
              context.l10n.motion_secondsRemainingLabel(MotionService.recordingSeconds - state.elapsedSeconds),
              style: GoogleFonts.inter(
                  fontSize: 13,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5)),
              textAlign: TextAlign.center),
        ],
        const SizedBox(height: AppTheme.spaceLG),
        if (state.result == null)
          SizedBox(
              height: 52,
              child: state.isRecording
                  ? OutlinedButton.icon(
                      onPressed: notifier.stopTest,
                      icon: const Icon(Icons.stop_rounded),
                      label: Text(context.l10n.common_stopEarly),
                      style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.statusError,
                          side: const BorderSide(
                              color: AppTheme.statusError, width: 2)),
                    )
                  : ElevatedButton.icon(
                      onPressed: notifier.startTest,
                      icon: const Icon(Icons.play_arrow_rounded),
                      label: Text(context.l10n.common_startTest),
                    )),
        if (state.result != null) ...[
          MotionResultCard(result: state.result!),
          const SizedBox(height: AppTheme.spaceMD),
          SizedBox(
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () {
                  ref
                      .read(fullCheckupProvider.notifier)
                      .completeMotion(state.result!);
                  ref.read(motionProvider.notifier).reset();
                },
                icon: const Icon(Icons.arrow_forward_rounded),
                label: Text(context.l10n.checkup_continueToTap),
              )),
        ],
        const SizedBox(height: AppTheme.spaceLG),
      ]),
    );
  }
}
