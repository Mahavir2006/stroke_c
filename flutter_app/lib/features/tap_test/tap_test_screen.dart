import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../app/theme.dart';
import '../../core/constants.dart';
import '../../shared/utils/session_service.dart';
import 'tap_scoring.dart';
import 'tap_test_provider.dart';
import 'tap_test_service.dart';

const double _kArenaHeight = 340.0;
const double _kButtonSize = 72.0;

class TapTestScreen extends ConsumerWidget {
  const TapTestScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final state = ref.watch(tapTestProvider);
    final notifier = ref.read(tapTestProvider.notifier);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spaceMD),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(children: [
            Icon(Icons.touch_app_rounded,
                color: theme.colorScheme.primary, size: 24),
            const SizedBox(width: 8),
            Text(context.l10n.tap_title,
                style: AppTheme.headingMD.copyWith(
                  color: theme.colorScheme.onSurface,
                )),
          ]),
          const SizedBox(height: AppTheme.spaceMD),
          _buildPhase(context, state, notifier),
          const SizedBox(height: AppTheme.spaceLG),
        ],
      ),
    );
  }

  Widget _buildPhase(
      BuildContext context, TapTestState state, TapTestNotifier notifier) {
    switch (state.phase) {
      case TestPhase.instructionRight:
        return TapInstructionCard(
            hand: ActiveHand.right,
            onStart: (w, h) => notifier.startTest(w, h));
      case TestPhase.testingRight:
      case TestPhase.testingLeft:
        return TapArenaSection(state: state, notifier: notifier);
      case TestPhase.rest:
        return TapRestScreen(secondsLeft: state.restSecondsLeft);
      case TestPhase.instructionLeft:
        return TapInstructionCard(
            hand: ActiveHand.left, onStart: (w, h) => notifier.startTest(w, h));
      case TestPhase.result:
        return TapCombinedResultCard(
          result: state.dualResult!,
          onSave: () async {
            await SessionService.submitData('temp-session',
                AppConstants.dataTypeTap, state.dualResult!.toJson());
            notifier.reset();
          },
          onRetry: notifier.reset,
        );
    }
  }
}

class TapInstructionCard extends StatelessWidget {
  final ActiveHand hand;
  final void Function(double w, double h) onStart;
  const TapInstructionCard({super.key, required this.hand, required this.onStart});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;
    final isRight = hand == ActiveHand.right;
    final label = isRight ? context.l10n.tap_rightHand : context.l10n.tap_leftHand;
    final instruction = isRight
        ? context.l10n.tap_rightInstruction
        : context.l10n.tap_leftInstruction;

    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        _StepDot(active: isRight, label: '1'),
        Container(width: 32, height: 2, color: colors.cardBorder),
        _StepDot(active: !isRight, label: '2'),
      ]),
      const SizedBox(height: AppTheme.spaceLG),
      Center(child: _HandIllustration(hand: hand)),
      const SizedBox(height: AppTheme.spaceMD),
      Center(
        child: Text(label,
            style: GoogleFonts.outfit(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: theme.colorScheme.primary,
            )),
      ),
      const SizedBox(height: AppTheme.spaceMD),
      Container(
        padding: const EdgeInsets.all(AppTheme.spaceMD),
        decoration: BoxDecoration(
          color: colors.primarySurface,
          borderRadius: BorderRadius.circular(AppTheme.radiusMD),
          border: Border.all(
              color: theme.colorScheme.primary.withValues(alpha: 0.2)),
        ),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(Icons.info_outline, color: theme.colorScheme.primary, size: 20),
          const SizedBox(width: AppTheme.spaceSM),
          Expanded(
            child: Text(instruction,
                style: GoogleFonts.inter(
                    fontSize: 15,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    height: 1.6)),
          ),
        ]),
      ),
      const SizedBox(height: AppTheme.spaceLG),
      LayoutBuilder(builder: (context, constraints) {
        final w = constraints.maxWidth;
        return Column(children: [
          Container(
            width: w,
            height: _kArenaHeight,
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(AppTheme.radiusLG),
              border: Border.all(color: colors.cardBorder, width: 2),
            ),
            child: Center(
              child: Icon(Icons.touch_app_rounded,
                  size: 64, color: theme.colorScheme.outline),
            ),
          ),
          const SizedBox(height: AppTheme.spaceMD),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: () => onStart(w, _kArenaHeight),
              icon: const Icon(Icons.play_arrow_rounded),
              label: Text(isRight ? context.l10n.tap_startRightTest : context.l10n.tap_startLeftTest),
            ),
          ),
        ]);
      }),
    ]);
  }
}

class _HandIllustration extends StatelessWidget {
  final ActiveHand hand;
  const _HandIllustration({required this.hand});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isRight = hand == ActiveHand.right;
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.1),
        shape: BoxShape.circle,
        border: Border.all(
            color: theme.colorScheme.primary.withValues(alpha: 0.3), width: 2),
      ),
      child: Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()..scale(isRight ? 1.0 : -1.0, 1.0),
        child: Icon(Icons.back_hand_rounded,
            size: 52, color: theme.colorScheme.primary),
      ),
    );
  }
}

class _StepDot extends StatelessWidget {
  final bool active;
  final String label;
  const _StepDot({required this.active, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: active
            ? theme.colorScheme.primary
            : theme.colorScheme.outline.withValues(alpha: 0.3),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(label,
            style: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: active
                  ? Colors.white
                  : theme.colorScheme.onSurface.withValues(alpha: 0.5),
            )),
      ),
    );
  }
}

class TapArenaSection extends StatelessWidget {
  final TapTestState state;
  final TapTestNotifier notifier;
  const TapArenaSection({super.key, required this.state, required this.notifier});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isRight = state.activeHand == ActiveHand.right;
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Container(
        padding: const EdgeInsets.symmetric(
            vertical: AppTheme.spaceSM, horizontal: AppTheme.spaceMD),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary,
          borderRadius: BorderRadius.circular(AppTheme.radiusMD),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()..scale(isRight ? 1.0 : -1.0, 1.0),
            child: const Icon(Icons.back_hand_rounded,
                size: 20, color: Colors.white),
          ),
          const SizedBox(width: 8),
          Text(
            isRight ? context.l10n.tap_rightHandCaps : context.l10n.tap_leftHandCaps,
            style: GoogleFonts.outfit(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: 1.2),
          ),
        ]),
      ),
      const SizedBox(height: AppTheme.spaceMD),
      LayoutBuilder(builder: (context, constraints) {
        return Column(children: [
          GestureDetector(
            onTapDown: (d) => notifier.registerTap(d.localPosition),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppTheme.radiusLG),
              child: Container(
                width: constraints.maxWidth,
                height: _kArenaHeight,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF0B1120), Color(0xFF0B2027)],
                  ),
                  borderRadius: BorderRadius.circular(AppTheme.radiusLG),
                  border:
                      Border.all(color: theme.colorScheme.primary, width: 2),
                ),
                child: _RunningArena(state: state),
              ),
            ),
          ),
          const SizedBox(height: AppTheme.spaceMD),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: OutlinedButton.icon(
              onPressed: notifier.stopTest,
              icon: const Icon(Icons.stop_rounded),
              label: Text(context.l10n.common_stopEarly),
              style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.statusError,
                  side:
                      const BorderSide(color: AppTheme.statusError, width: 2)),
            ),
          ),
        ]);
      }),
    ]);
  }
}

class _RunningArena extends StatelessWidget {
  final TapTestState state;
  const _RunningArena({required this.state});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: _kArenaHeight,
      child: Stack(children: [
        Positioned(
          top: 16,
          left: 0,
          right: 0,
          child: Center(
            child: Text(context.l10n.tap_taps(state.hitCount),
                style: GoogleFonts.outfit(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: Colors.white)),
          ),
        ),
        Positioned(
          top: 16,
          right: 16,
          child: Text(
              '${TapTestService.testDurationSeconds - state.elapsedSeconds}s',
              style: GoogleFonts.outfit(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.slate400)),
        ),
        Positioned(
          left: state.buttonX,
          top: state.buttonY,
          width: _kButtonSize,
          height: _kButtonSize,
          child: _TapButton(flash: state.lastHitFlash),
        ),
      ]),
    );
  }
}

class _TapButton extends StatelessWidget {
  final bool flash;
  const _TapButton({required this.flash});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final button = Container(
      width: _kButtonSize,
      height: _kButtonSize,
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.8),
            blurRadius: 24,
            spreadRadius: 6,
          ),
        ],
      ),
      child: const Icon(Icons.touch_app_rounded, color: Colors.white, size: 34),
    );

    if (flash) {
      return button
          .animate()
          .scale(
              begin: const Offset(1.0, 1.0),
              end: const Offset(1.3, 1.3),
              duration: 150.ms)
          .then()
          .scale(
              begin: const Offset(1.3, 1.3),
              end: const Offset(1.0, 1.0),
              duration: 150.ms);
    }
    return button;
  }
}

class TapRestScreen extends StatelessWidget {
  final int secondsLeft;
  const TapRestScreen({super.key, required this.secondsLeft});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceXL),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusLG),
        border: Border.all(color: colors.cardBorder),
      ),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Icon(Icons.check_circle_rounded,
            color: AppTheme.statusSuccess, size: 56),
        const SizedBox(height: AppTheme.spaceMD),
        Text(context.l10n.tap_rightDone,
            style: GoogleFonts.outfit(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: theme.colorScheme.onSurface,
            ),
            textAlign: TextAlign.center),
        const SizedBox(height: AppTheme.spaceSM),
        Text(context.l10n.tap_switchLeft,
            style: GoogleFonts.inter(
              fontSize: 16,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              height: 1.5,
            ),
            textAlign: TextAlign.center),
        const SizedBox(height: AppTheme.spaceXL),
        Container(
          width: 88,
          height: 88,
          decoration: BoxDecoration(
            color: colors.primarySurface,
            shape: BoxShape.circle,
            border: Border.all(color: theme.colorScheme.primary, width: 3),
          ),
          child: Center(
            child: Text('$secondsLeft',
                style: GoogleFonts.outfit(
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  color: theme.colorScheme.primary,
                )),
          ),
        ),
        const SizedBox(height: AppTheme.spaceMD),
        Text(
            context.l10n.tap_startingLeft(secondsLeft, secondsLeft == 1 ? '' : 's'),
            style: GoogleFonts.inter(
                fontSize: 14,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5)),
            textAlign: TextAlign.center),
      ]),
    );
  }
}

class TapCombinedResultCard extends StatelessWidget {
  final DualTapResult result;
  final VoidCallback onSave;
  final VoidCallback onRetry;

  const TapCombinedResultCard({
    super.key,
    required this.result,
    required this.onSave,
    required this.onRetry,
  });

  Color _riskColor(OverallRisk r) {
    switch (r) {
      case OverallRisk.abnormal:
        return AppTheme.statusError;
      case OverallRisk.borderline:
        return AppTheme.statusWarning;
      case OverallRisk.normal:
        return AppTheme.statusSuccess;
    }
  }

  Color _handRiskColor(HandRisk r) {
    switch (r) {
      case HandRisk.abnormal:
        return AppTheme.statusError;
      case HandRisk.borderline:
        return AppTheme.statusWarning;
      case HandRisk.normal:
        return AppTheme.statusSuccess;
    }
  }

  IconData _riskIcon(OverallRisk r) {
    switch (r) {
      case OverallRisk.abnormal:
        return Icons.warning_rounded;
      case OverallRisk.borderline:
        return Icons.info_rounded;
      case OverallRisk.normal:
        return Icons.check_circle_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;
    final overallColor = _riskColor(result.overallRisk);
    final maxTaps =
        result.rightTaps > result.leftTaps ? result.rightTaps : result.leftTaps;
    final rightFill = maxTaps == 0 ? 0.0 : result.rightTaps / maxTaps;
    final leftFill = maxTaps == 0 ? 0.0 : result.leftTaps / maxTaps;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusLG),
        border: Border.all(color: overallColor.withValues(alpha: 0.3)),
        boxShadow: context.isDark ? [] : AppTheme.shadowSM,
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Container(
          padding: const EdgeInsets.all(AppTheme.spaceLG),
          decoration: BoxDecoration(
            color: overallColor.withValues(alpha: 0.08),
            borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppTheme.radiusLG)),
          ),
          child: Column(children: [
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(_riskIcon(result.overallRisk),
                  color: overallColor, size: 28),
              const SizedBox(width: 8),
              Text(TapScoring.overallRiskLabel(result.overallRisk),
                  style: GoogleFonts.outfit(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: overallColor)),
            ]),
            if (result.lateralisedDeficit) ...[
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spaceSM, vertical: 4),
                decoration: BoxDecoration(
                    color: AppTheme.statusError.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(AppTheme.radiusSM)),
                child: Text(context.l10n.tap_lateralisedDeficit,
                    style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.statusError)),
              ),
            ],
          ]),
        ),
        Padding(
          padding: const EdgeInsets.all(AppTheme.spaceLG),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Row(children: [
              Expanded(
                  child: _HandScoreBox(
                      hand: ActiveHand.right,
                      taps: result.rightTaps,
                      risk: result.rightRisk,
                      color: _handRiskColor(result.rightRisk))),
              const SizedBox(width: AppTheme.spaceMD),
              Expanded(
                  child: _HandScoreBox(
                      hand: ActiveHand.left,
                      taps: result.leftTaps,
                      risk: result.leftRisk,
                      color: _handRiskColor(result.leftRisk))),
            ]),
            const SizedBox(height: AppTheme.spaceLG),
            Divider(color: colors.cardBorder),
            const SizedBox(height: AppTheme.spaceMD),
            Text(context.l10n.tap_asymmetryAnalysis,
                style: AppTheme.headingSM
                    .copyWith(color: theme.colorScheme.onSurface)),
            const SizedBox(height: AppTheme.spaceSM),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(context.l10n.tap_asymmetryIndex,
                  style: GoogleFonts.inter(
                      fontSize: 14,
                      color:
                          theme.colorScheme.onSurface.withValues(alpha: 0.5))),
              Text('${result.asymmetryPercent.toStringAsFixed(1)}%',
                  style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.onSurface)),
            ]),
            const SizedBox(height: 6),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(context.l10n.tap_assessment,
                  style: GoogleFonts.inter(
                      fontSize: 14,
                      color:
                          theme.colorScheme.onSurface.withValues(alpha: 0.5))),
              Text(TapScoring.asymmetryLabelString(result.asymmetryLabel),
                  style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: _riskColor(result.overallRisk))),
            ]),
            const SizedBox(height: AppTheme.spaceMD),
            _AsymmetryBar(
                rightFill: rightFill,
                leftFill: leftFill,
                rightTaps: result.rightTaps,
                leftTaps: result.leftTaps),
            const SizedBox(height: AppTheme.spaceLG),
            Divider(color: colors.cardBorder),
            const SizedBox(height: AppTheme.spaceMD),
            Container(
              padding: const EdgeInsets.all(AppTheme.spaceMD),
              decoration: BoxDecoration(
                  color: overallColor.withValues(alpha: 0.07),
                  borderRadius: BorderRadius.circular(AppTheme.radiusMD)),
              child: Text(result.interpretation,
                  style: GoogleFonts.inter(
                      fontSize: 14,
                      color: overallColor,
                      fontWeight: FontWeight.w500,
                      height: 1.6)),
            ),
            const SizedBox(height: AppTheme.spaceLG),
            Row(children: [
              Expanded(
                  child: SizedBox(
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: onSave,
                        icon: const Icon(Icons.save_rounded),
                        label: Text(context.l10n.common_saveAndContinue),
                      ))),
              const SizedBox(width: AppTheme.spaceSM),
              Expanded(
                  child: SizedBox(
                      height: 52,
                      child: OutlinedButton.icon(
                        onPressed: onRetry,
                        icon: const Icon(Icons.refresh_rounded),
                        label: Text(context.l10n.common_testAgain),
                      ))),
            ]),
          ]),
        ),
      ]),
    );
  }
}

class _HandScoreBox extends StatelessWidget {
  final ActiveHand hand;
  final int taps;
  final HandRisk risk;
  final Color color;

  const _HandScoreBox({
    required this.hand,
    required this.taps,
    required this.risk,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isRight = hand == ActiveHand.right;
    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceMD),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(AppTheme.radiusMD),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Column(children: [
        Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()..scale(isRight ? 1.0 : -1.0, 1.0),
          child: Icon(Icons.back_hand_rounded, size: 28, color: color),
        ),
        const SizedBox(height: 6),
        Text(isRight ? context.l10n.tap_rightHand : context.l10n.tap_leftHand,
            style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6))),
        const SizedBox(height: 4),
        Text(context.l10n.tap_tapsCount(taps),
            style: GoogleFonts.outfit(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: theme.colorScheme.onSurface)),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppTheme.radiusSM)),
          child: Text(TapScoring.handRiskLabel(risk),
              style: GoogleFonts.inter(
                  fontSize: 12, fontWeight: FontWeight.w700, color: color)),
        ),
      ]),
    );
  }
}

class _AsymmetryBar extends StatelessWidget {
  final double rightFill;
  final double leftFill;
  final int rightTaps;
  final int leftTaps;

  const _AsymmetryBar({
    required this.rightFill,
    required this.leftFill,
    required this.rightTaps,
    required this.leftTaps,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text('R: $rightTaps',
            style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.primary)),
        Text('L: $leftTaps',
            style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.secondary)),
      ]),
      const SizedBox(height: 6),
      LayoutBuilder(builder: (context, constraints) {
        final w = constraints.maxWidth;
        return Row(children: [
          Container(
            width: w / 2,
            height: 12,
            alignment: Alignment.centerRight,
            child: Container(
              width: (w / 2) * rightFill,
              height: 12,
              decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius:
                      const BorderRadius.horizontal(left: Radius.circular(6))),
            ),
          ),
          Container(
            width: w / 2,
            height: 12,
            alignment: Alignment.centerLeft,
            child: Container(
              width: (w / 2) * leftFill,
              height: 12,
              decoration: BoxDecoration(
                  color: theme.colorScheme.secondary,
                  borderRadius:
                      const BorderRadius.horizontal(right: Radius.circular(6))),
            ),
          ),
        ]);
      }),
      const SizedBox(height: 4),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(context.l10n.common_right,
            style: GoogleFonts.inter(
                fontSize: 11,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.4))),
        Text(context.l10n.common_left,
            style: GoogleFonts.inter(
                fontSize: 11,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.4))),
      ]),
    ]);
  }
}
