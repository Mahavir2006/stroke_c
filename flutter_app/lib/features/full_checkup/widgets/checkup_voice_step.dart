import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../app/theme.dart';
import '../../../core/constants.dart';
import '../../voice_check/voice_provider.dart';
import '../../voice_check/voice_check_screen.dart'
    show AudioVisualizer, VoiceResultCard;
import '../../voice_check/voice_service.dart';
import '../full_checkup_provider.dart';

class CheckupVoiceStep extends ConsumerWidget {
  const CheckupVoiceStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colors = context.colors;
    final state = ref.watch(voiceProvider);
    final notifier = ref.read(voiceProvider.notifier);

    // Forward result to checkup provider
    ref.listen(voiceProvider, (prev, next) {
      if (next.phase == VoicePhase.result && next.result != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref.read(fullCheckupProvider.notifier).completeVoice(next.result!);
          ref.read(voiceProvider.notifier).reset();
        });
      }
    });

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spaceMD),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(children: [
          Icon(Icons.mic_rounded, color: theme.colorScheme.primary, size: 22),
          const SizedBox(width: 8),
          Text(context.l10n.checkup_voiceCheck,
              style: AppTheme.headingMD
                  .copyWith(color: theme.colorScheme.onSurface)),
        ]),
        const SizedBox(height: 4),
        Text(context.l10n.voice_readSentence,
            style: AppTheme.bodyMD.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6))),
        const SizedBox(height: AppTheme.spaceMD),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppTheme.spaceLG),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(AppTheme.radiusMD),
            boxShadow: context.isDark ? const [] : AppTheme.shadowSM,
            border: Border(
                left: BorderSide(color: theme.colorScheme.primary, width: 4)),
          ),
          child: Text('"${AppConstants.voicePrompt}"',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center),
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
              backgroundColor: theme.colorScheme.outline.withValues(alpha: 0.3),
              valueColor:
                  AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
            ),
          ),
          const SizedBox(height: 6),
          Text('${state.elapsedSeconds}s / ${VoiceService.maxDurationSec}s',
              style: GoogleFonts.inter(
                  fontSize: 13,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5)),
              textAlign: TextAlign.center),
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
                            borderRadius: BorderRadius.circular(50)),
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
                            borderRadius: BorderRadius.circular(50)),
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
            child: Column(children: [
              Text(context.l10n.voice_recordingComplete(state.recordedDuration.toString()),
                  style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface)),
              const SizedBox(height: AppTheme.spaceMD),
              SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: notifier.playRecording,
                    icon: const Icon(Icons.play_arrow_rounded),
                    label: Text(context.l10n.voice_playRecording),
                  )),
              const SizedBox(height: AppTheme.spaceSM),
              SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: notifier.analyseRecording,
                    icon: const Icon(Icons.auto_graph_rounded),
                    label: Text(context.l10n.voice_analyseSpeech),
                  )),
            ]),
          ),
        ],
        if (state.phase == VoicePhase.analyzing) ...[
          const SizedBox(height: AppTheme.spaceXL),
          Center(
              child: Column(children: [
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
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5))),
          ])),
        ],
        if (state.phase == VoicePhase.error && state.errorMessage != null) ...[
          const SizedBox(height: AppTheme.spaceMD),
          Container(
            padding: const EdgeInsets.all(AppTheme.spaceMD),
            decoration: BoxDecoration(
              color: AppTheme.statusError.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppTheme.radiusMD),
              border: Border.all(
                  color: AppTheme.statusError.withValues(alpha: 0.3)),
            ),
            child: Column(children: [
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
                  )),
            ]),
          ),
        ],
        if (state.phase == VoicePhase.result && state.result != null) ...[
          const SizedBox(height: AppTheme.spaceLG),
          VoiceResultCard(result: state.result!),
          const SizedBox(height: AppTheme.spaceMD),
          SizedBox(
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () {
                  ref
                      .read(fullCheckupProvider.notifier)
                      .completeVoice(state.result!);
                  ref.read(voiceProvider.notifier).reset();
                },
                icon: const Icon(Icons.arrow_forward_rounded),
                label: Text(context.l10n.checkup_continueToMotion),
              )),
        ],
        const SizedBox(height: AppTheme.spaceLG),
      ]),
    );
  }
}
