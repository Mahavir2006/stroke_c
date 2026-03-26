// Stroke Mitra - Voice Check Screen
//
/// Records user speech, sends it to the deployed speech analysis API,
/// and displays detailed results including slurring score, risk tier,
/// and acoustic metrics.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/theme.dart';
import '../../core/constants.dart';
import '../../shared/utils/session_service.dart';
import 'voice_provider.dart';
import 'voice_result.dart';
import 'voice_service.dart';

class VoiceCheckScreen extends ConsumerWidget {
  const VoiceCheckScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colors = context.colors;
    final state = ref.watch(voiceProvider);
    final notifier = ref.read(voiceProvider.notifier);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spaceMD),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(Icons.mic_rounded,
                  color: theme.colorScheme.primary, size: 24),
              const SizedBox(width: 8),
              Text(context.l10n.voice_title,
                  style: AppTheme.headingMD.copyWith(
                    color: theme.colorScheme.onSurface,
                  )),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            context.l10n.voice_readSentence,
            style: AppTheme.bodyMD.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: AppTheme.spaceMD),

          // Prompt Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppTheme.spaceLG),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(AppTheme.radiusMD),
              boxShadow: context.isDark ? [] : AppTheme.shadowSM,
              border: Border(
                left: BorderSide(color: theme.colorScheme.primary, width: 4),
              ),
            ),
            child: Text(
              '"${AppConstants.voicePrompt}"',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: AppTheme.spaceLG),

          AudioVisualizer(isActive: state.phase == VoicePhase.recording),
          const SizedBox(height: AppTheme.spaceMD),

          if (state.phase == VoicePhase.recording) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: state.elapsedSeconds / VoiceService.maxDurationSec,
                minHeight: 8,
                backgroundColor:
                    theme.colorScheme.outline.withValues(alpha: 0.3),
                valueColor:
                    AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '${state.elapsedSeconds}s / ${VoiceService.maxDurationSec}s',
              style: GoogleFonts.inter(
                  fontSize: 13,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTheme.spaceMD),
          ],

          if (state.phase != VoicePhase.analyzing &&
              state.phase != VoicePhase.result)
            Center(
              child: SizedBox(
                width: 300,
                child: state.phase == VoicePhase.recording
                    ? ElevatedButton.icon(
                        onPressed: notifier.stopRecording,
                        icon: const Icon(Icons.stop_rounded, size: 20),
                        label: Text(context.l10n.voice_stopRecording),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.statusError,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.all(AppTheme.spaceLG),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                      )
                    : ElevatedButton.icon(
                        onPressed: notifier.startRecording,
                        icon: const Icon(Icons.mic_rounded, size: 20),
                        label: Text(state.hasRecording
                            ? context.l10n.common_recordAgain
                            : context.l10n.voice_startRecording),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(AppTheme.spaceLG),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                      ),
              ),
            ),

          if (state.hasRecording && state.phase == VoicePhase.idle) ...[
            const SizedBox(height: AppTheme.spaceLG),
            Container(
              padding: const EdgeInsets.all(AppTheme.spaceMD),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(AppTheme.radiusMD),
                border: Border.all(color: colors.cardBorder),
              ),
              child: Column(
                children: [
                  Text(
                    context.l10n.voice_recordingComplete(state.recordedDuration.toString()),
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spaceMD),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: notifier.playRecording,
                      icon: const Icon(Icons.play_arrow_rounded),
                      label: Text(context.l10n.voice_playRecording),
                    ),
                  ),
                  const SizedBox(height: AppTheme.spaceSM),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: notifier.analyseRecording,
                      icon: const Icon(Icons.auto_graph_rounded),
                      label: Text(context.l10n.voice_analyseSpeech),
                    ),
                  ),
                ],
              ),
            ),
          ],

          if (state.phase == VoicePhase.analyzing) ...[
            const SizedBox(height: AppTheme.spaceXL),
            Center(
              child: Column(
                children: [
                  SizedBox(
                      width: 48,
                      height: 48,
                      child: CircularProgressIndicator(
                          strokeWidth: 3, color: theme.colorScheme.primary)),
                  const SizedBox(height: AppTheme.spaceMD),
                  Text(context.l10n.voice_analysing,
                      style: AppTheme.headingSM
                          .copyWith(color: theme.colorScheme.onSurface)),
                  const SizedBox(height: AppTheme.spaceXS),
                  Text(context.l10n.voice_analysingWait,
                      style: GoogleFonts.inter(
                          fontSize: 13,
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.5))),
                ],
              ),
            ),
          ],

          if (state.phase == VoicePhase.error &&
              state.errorMessage != null) ...[
            const SizedBox(height: AppTheme.spaceMD),
            Container(
              padding: const EdgeInsets.all(AppTheme.spaceMD),
              decoration: BoxDecoration(
                color: AppTheme.statusError.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppTheme.radiusMD),
                border: Border.all(
                    color: AppTheme.statusError.withValues(alpha: 0.3)),
              ),
              child: Column(
                children: [
                  Row(children: [
                    const Icon(Icons.error_outline,
                        color: AppTheme.statusError, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                        child: Text(state.errorMessage!,
                            style: GoogleFonts.inter(
                                fontSize: 14,
                                color: AppTheme.statusError,
                                fontWeight: FontWeight.w500))),
                  ]),
                  const SizedBox(height: AppTheme.spaceMD),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: notifier.reset,
                      icon: const Icon(Icons.refresh_rounded, size: 16),
                      label: Text(context.l10n.common_tryAgain),
                      style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.statusError,
                          side: const BorderSide(color: AppTheme.statusError)),
                    ),
                  ),
                ],
              ),
            ),
          ],

          if (state.phase == VoicePhase.result && state.result != null) ...[
            const SizedBox(height: AppTheme.spaceLG),
            VoiceResultCard(result: state.result!),
            const SizedBox(height: AppTheme.spaceMD),
            Row(children: [
              Expanded(
                  child: SizedBox(
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          await SessionService.submitData(
                              'temp-session',
                              AppConstants.dataTypeVoice,
                              state.result!.toJson());
                          notifier.reset();
                        },
                        icon: const Icon(Icons.save_rounded),
                        label: Text(context.l10n.common_saveAndContinue),
                      ))),
              const SizedBox(width: AppTheme.spaceSM),
              Expanded(
                  child: SizedBox(
                      height: 52,
                      child: OutlinedButton.icon(
                        onPressed: notifier.reset,
                        icon: const Icon(Icons.refresh_rounded),
                        label: Text(context.l10n.common_recordAgain),
                      ))),
            ]),
          ],

          const SizedBox(height: AppTheme.spaceLG),
        ],
      ),
    );
  }
}

// ─── Audio Visualizer ────────────────────────────────────────────────────────
class AudioVisualizer extends StatefulWidget {
  final bool isActive;
  const AudioVisualizer({super.key, required this.isActive});

  @override
  State<AudioVisualizer> createState() => _AudioVisualizerState();
}

class _AudioVisualizerState extends State<AudioVisualizer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
  }

  @override
  void didUpdateWidget(covariant AudioVisualizer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _controller.repeat(reverse: true);
    } else if (!widget.isActive && oldWidget.isActive) {
      _controller.stop();
      _controller.reset();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (i) {
              final height = widget.isActive
                  ? 12.0 +
                      (48.0 *
                          (0.3 + 0.7 * _controller.value) *
                          [0.6, 0.9, 1.0, 0.8, 0.5][i])
                  : 12.0;
              return AnimatedContainer(
                duration: Duration(milliseconds: 100 + (i * 50)),
                width: 8,
                height: height,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                  color: widget.isActive
                      ? theme.colorScheme.primary
                      : theme.colorScheme.outline.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}

// ─── Voice Result Card ───────────────────────────────────────────────────────
class VoiceResultCard extends StatelessWidget {
  final VoiceResult result;
  const VoiceResultCard({super.key, required this.result});

  Color get _severityColor {
    switch (result.severity) {
      case 'severe':
        return AppTheme.statusError;
      case 'moderate':
        return AppTheme.orange500;
      case 'mild':
        return AppTheme.statusWarning;
      default:
        return AppTheme.statusSuccess;
    }
  }

  Color get _riskColor {
    switch (result.riskTier) {
      case 'critical':
        return AppTheme.statusError;
      case 'high':
        return AppTheme.orange500;
      case 'moderate':
        return AppTheme.statusWarning;
      default:
        return AppTheme.statusSuccess;
    }
  }

  IconData get _severityIcon {
    switch (result.severity) {
      case 'severe':
        return Icons.warning_rounded;
      case 'moderate':
        return Icons.error_outline;
      case 'mild':
        return Icons.info_rounded;
      default:
        return Icons.check_circle_rounded;
    }
  }

  String _interpretation(BuildContext context) {
    switch (result.severity) {
      case 'severe':
        return context.l10n.voice_severe;
      case 'moderate':
        return context.l10n.voice_moderate;
      case 'mild':
        return context.l10n.voice_mild;
      default:
        return context.l10n.voice_normal;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusLG),
        border: Border.all(color: _severityColor.withValues(alpha: 0.3)),
        boxShadow: context.isDark ? [] : AppTheme.shadowSM,
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Container(
          padding: const EdgeInsets.all(AppTheme.spaceLG),
          decoration: BoxDecoration(
            color: _severityColor.withValues(alpha: 0.08),
            borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppTheme.radiusLG)),
          ),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(_severityIcon, color: _severityColor, size: 28),
            const SizedBox(width: 8),
            Text(
              result.severity[0].toUpperCase() + result.severity.substring(1),
              style: GoogleFonts.outfit(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: _severityColor),
            ),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.all(AppTheme.spaceLG),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            _MetricRow(
                label: context.l10n.voice_slurringScore,
                value: '${result.slurringScore.toStringAsFixed(1)} / 100'),
            const SizedBox(height: AppTheme.spaceSM),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(context.l10n.voice_riskTier,
                  style: GoogleFonts.inter(
                      fontSize: 14,
                      color:
                          theme.colorScheme.onSurface.withValues(alpha: 0.5))),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                    color: _riskColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(AppTheme.radiusSM)),
                child: Text(result.riskTier.toUpperCase(),
                    style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: _riskColor)),
              ),
            ]),
            const SizedBox(height: AppTheme.spaceSM),
            _MetricRow(
                label: context.l10n.voice_riskScore,
                value: '${result.riskScore.toStringAsFixed(1)} / 100'),
            const SizedBox(height: AppTheme.spaceSM),
            _MetricRow(
                label: context.l10n.voice_confidence,
                value: '${(result.confidence * 100).toStringAsFixed(0)}%'),
            const SizedBox(height: AppTheme.spaceMD),
            Divider(color: colors.cardBorder),
            const SizedBox(height: AppTheme.spaceMD),
            Text(context.l10n.voice_acousticSummary,
                style: AppTheme.headingSM
                    .copyWith(color: theme.colorScheme.onSurface)),
            const SizedBox(height: AppTheme.spaceSM),
            _MetricRow(
                label: context.l10n.voice_speakingRate,
                value:
                    '${result.acousticSummary.speakingRate.toStringAsFixed(1)} syl/s'),
            const SizedBox(height: AppTheme.spaceXS),
            _MetricRow(
                label: context.l10n.voice_pitchMean,
                value:
                    '${result.acousticSummary.pitchMeanHz.toStringAsFixed(1)} Hz'),
            const SizedBox(height: AppTheme.spaceXS),
            _MetricRow(
                label: context.l10n.voice_pitchVariability,
                value:
                    '${result.acousticSummary.pitchVariabilityHz.toStringAsFixed(1)} Hz'),
            const SizedBox(height: AppTheme.spaceXS),
            _MetricRow(
                label: context.l10n.voice_pauseRatio,
                value:
                    '${(result.acousticSummary.pauseRatio * 100).toStringAsFixed(0)}%'),
            const SizedBox(height: AppTheme.spaceXS),
            _MetricRow(
                label: context.l10n.voice_voicingRatio,
                value:
                    '${(result.acousticSummary.voicingRatio * 100).toStringAsFixed(0)}%'),
            const SizedBox(height: AppTheme.spaceMD),
            Divider(color: colors.cardBorder),
            const SizedBox(height: AppTheme.spaceMD),
            Container(
              padding: const EdgeInsets.all(AppTheme.spaceMD),
              decoration: BoxDecoration(
                  color: _severityColor.withValues(alpha: 0.07),
                  borderRadius: BorderRadius.circular(AppTheme.radiusMD)),
              child: Text(_interpretation(context),
                  style: GoogleFonts.inter(
                      fontSize: 14,
                      color: _severityColor,
                      fontWeight: FontWeight.w500,
                      height: 1.6)),
            ),
            if (result.emergencyAlert) ...[
              const SizedBox(height: AppTheme.spaceMD),
              GestureDetector(
                onTap: () =>
                    launchUrl(Uri.parse('tel:${AppConstants.emergencyNumber}')),
                child: Container(
                  padding: const EdgeInsets.all(AppTheme.spaceMD),
                  decoration: BoxDecoration(
                      color: AppTheme.statusError,
                      borderRadius: BorderRadius.circular(AppTheme.radiusMD)),
                  child: Row(children: [
                    const Icon(Icons.emergency, color: Colors.white, size: 24),
                    const SizedBox(width: AppTheme.spaceSM),
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          Text(context.l10n.emergency_title,
                              style: GoogleFonts.outfit(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white)),
                          Text(
                              context.l10n.emergency_callPrompt(AppConstants.emergencyNumber),
                              style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: Colors.white.withValues(alpha: 0.9))),
                        ])),
                    const Icon(Icons.phone, color: Colors.white, size: 24),
                  ]),
                ),
              ),
            ],
            const SizedBox(height: AppTheme.spaceMD),
            Text(
                context.l10n.voice_processedIn((result.processingTimeMs / 1000).toStringAsFixed(1)),
                style: GoogleFonts.inter(
                    fontSize: 11,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.4)),
                textAlign: TextAlign.center),
          ]),
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
