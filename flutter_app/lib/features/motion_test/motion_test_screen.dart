import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../app/theme.dart';
import '../../core/constants.dart';
import '../../shared/utils/session_service.dart';
import 'motion_provider.dart';
import 'motion_service.dart';

class MotionTestScreen extends ConsumerWidget {
  const MotionTestScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colors = context.colors;
    final state = ref.watch(motionProvider);
    final notifier = ref.read(motionProvider.notifier);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spaceMD),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(children: [
            Icon(Icons.accessibility_new_rounded,
                color: theme.colorScheme.primary, size: 24),
            const SizedBox(width: 8),
            Text(context.l10n.motion_title,
                style: AppTheme.headingMD.copyWith(
                  color: theme.colorScheme.onSurface,
                )),
          ]),
          const SizedBox(height: AppTheme.spaceSM),

          // Instruction Card
          Container(
            padding: const EdgeInsets.all(AppTheme.spaceMD),
            decoration: BoxDecoration(
              color: colors.primarySurface,
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
                ),
              ),
            ]),
          ),
          const SizedBox(height: AppTheme.spaceLG),

          // Ball Visualiser
          Center(
            child: BallVisualiser(
              offsetX: state.ballOffsetX,
              offsetY: state.ballOffsetY,
              riskLevel: state.result?.riskLevel,
              isRecording: state.isRecording,
            ),
          ),
          const SizedBox(height: AppTheme.spaceLG),

          // Live Axis Readout
          if (state.isRecording)
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
                    '${MotionService.recordingSeconds - state.elapsedSeconds}s',
              ),
            ]),

          // Progress Bar
          if (state.isRecording) ...[
            const SizedBox(height: AppTheme.spaceMD),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: state.elapsedSeconds / MotionService.recordingSeconds,
                minHeight: 8,
                backgroundColor:
                    theme.colorScheme.outline.withValues(alpha: 0.3),
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
              textAlign: TextAlign.center,
            ),
          ],

          const SizedBox(height: AppTheme.spaceLG),

          // Start / Stop Button
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
                            color: AppTheme.statusError, width: 2),
                      ),
                    )
                  : ElevatedButton.icon(
                      onPressed: notifier.startTest,
                      icon: const Icon(Icons.play_arrow_rounded),
                      label: Text(context.l10n.common_startTest),
                    ),
            ),

          // Results Card
          if (state.result != null) ...[
            MotionResultCard(result: state.result!),
            const SizedBox(height: AppTheme.spaceMD),
            SizedBox(
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () async {
                  await SessionService.submitData('temp-session',
                      AppConstants.dataTypeMotion, state.result!.toJson());
                  notifier.reset();
                },
                icon: const Icon(Icons.refresh_rounded),
                label: Text(context.l10n.common_testAgain),
              ),
            ),
          ],

          const SizedBox(height: AppTheme.spaceLG),
        ],
      ),
    );
  }
}

// ─── Ball Visualiser Widget ─────────────────────────────────────────────────
class BallVisualiser extends StatelessWidget {
  final double offsetX;
  final double offsetY;
  final String? riskLevel;
  final bool isRecording;

  const BallVisualiser({
    super.key,
    required this.offsetX,
    required this.offsetY,
    required this.riskLevel,
    required this.isRecording,
  });

  Color get _ballColor {
    if (!isRecording && riskLevel == null) return AppTheme.slate300;
    switch (riskLevel) {
      case 'Abnormal':
        return AppTheme.statusError;
      case 'Borderline':
        return AppTheme.statusWarning;
      case 'Normal':
        return AppTheme.statusSuccess;
      default:
        return AppTheme.primaryLight;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;
    const boxSize = 280.0;
    const ballSize = 40.0;
    const center = boxSize / 2 - ballSize / 2;

    return Container(
      width: boxSize,
      height: boxSize,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        shape: BoxShape.circle,
        border: Border.all(color: colors.cardBorder, width: 3),
        boxShadow: context.isDark ? [] : AppTheme.shadowMD,
      ),
      child: Stack(
        children: [
          Center(
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: theme.colorScheme.outline,
                shape: BoxShape.circle,
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 50),
            curve: Curves.linear,
            left: (center + offsetX).clamp(0, boxSize - ballSize),
            top: (center + offsetY).clamp(0, boxSize - ballSize),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: ballSize,
              height: ballSize,
              decoration: BoxDecoration(
                color: _ballColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: _ballColor.withValues(alpha: 0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Result Card Widget ─────────────────────────────────────────────────────
class MotionResultCard extends StatelessWidget {
  final MotionResult result;
  const MotionResultCard({super.key, required this.result});

  Color get _riskColor {
    switch (result.riskLevel) {
      case 'Abnormal':
        return AppTheme.statusError;
      case 'Borderline':
        return AppTheme.statusWarning;
      default:
        return AppTheme.statusSuccess;
    }
  }

  IconData get _riskIcon {
    switch (result.riskLevel) {
      case 'Abnormal':
        return Icons.warning_rounded;
      case 'Borderline':
        return Icons.info_rounded;
      default:
        return Icons.check_circle_rounded;
    }
  }

  String _interpretation(BuildContext context) {
    switch (result.riskLevel) {
      case 'Abnormal':
        return context.l10n.motion_abnormal;
      case 'Borderline':
        return context.l10n.motion_borderline;
      default:
        return context.l10n.motion_normal;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceLG),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusLG),
        border: Border.all(color: _riskColor.withValues(alpha: 0.3)),
        boxShadow: context.isDark ? [] : AppTheme.shadowSM,
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(_riskIcon, color: _riskColor, size: 24),
          const SizedBox(width: 8),
          Text(
            result.riskLevel,
            style: GoogleFonts.outfit(
                fontSize: 22, fontWeight: FontWeight.w800, color: _riskColor),
          ),
        ]),
        const SizedBox(height: AppTheme.spaceMD),
        Divider(color: colors.cardBorder),
        const SizedBox(height: AppTheme.spaceSM),
        _MetricRow(
            label: context.l10n.motion_tiltVariance,
            value: result.varianceScore.toStringAsFixed(2)),
        const SizedBox(height: AppTheme.spaceSM),
        _MetricRow(
            label: context.l10n.motion_driftScore,
            value: result.driftMagnitude.toStringAsFixed(2)),
        const SizedBox(height: AppTheme.spaceSM),
        _MetricRow(label: context.l10n.motion_samples, value: result.sampleCount.toString()),
        const SizedBox(height: AppTheme.spaceMD),
        Container(
          padding: const EdgeInsets.all(AppTheme.spaceSM),
          decoration: BoxDecoration(
            color: _riskColor.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(AppTheme.radiusSM),
          ),
          child: Text(
            _interpretation(context),
            style: GoogleFonts.inter(
                fontSize: 13,
                color: _riskColor,
                fontWeight: FontWeight.w500,
                height: 1.5),
          ),
        ),
      ]),
    );
  }
}

class _MetricRow extends StatelessWidget {
  final String label;
  final String value;
  const _MetricRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label,
          style: GoogleFonts.inter(
              fontSize: 14,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5))),
      Text(value,
          style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface)),
    ]);
  }
}

class MotionMetricBox extends StatelessWidget {
  final String label;
  final String value;
  const MotionMetricBox({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(AppTheme.radiusMD),
          border: Border.all(color: colors.cardBorder),
        ),
        child: Column(children: [
          Text(label,
              style: GoogleFonts.inter(
                  fontSize: 11,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5))),
          const SizedBox(height: 4),
          Text(value,
              style: AppTheme.metricSM.copyWith(
                color: theme.colorScheme.primary,
              )),
        ]),
      ),
    );
  }
}
