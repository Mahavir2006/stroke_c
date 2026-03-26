import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme.dart';
import '../../tap_test/tap_test_provider.dart';
import '../../tap_test/tap_test_screen.dart'
    show
        TapInstructionCard,
        TapArenaSection,
        TapRestScreen,
        TapCombinedResultCard;
import '../full_checkup_provider.dart';

class CheckupTapStep extends ConsumerWidget {
  const CheckupTapStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(tapTestProvider);
    final notifier = ref.read(tapTestProvider.notifier);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spaceMD),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(children: [
          Icon(Icons.touch_app_rounded,
              color: Theme.of(context).colorScheme.primary, size: 22),
          const SizedBox(width: 8),
          Text(context.l10n.tap_title,
              style: AppTheme.headingMD
                  .copyWith(color: Theme.of(context).colorScheme.onSurface)),
        ]),
        const SizedBox(height: AppTheme.spaceMD),
        _buildPhase(context, state, notifier, ref),
        const SizedBox(height: AppTheme.spaceLG),
      ]),
    );
  }

  Widget _buildPhase(BuildContext context, TapTestState state,
      TapTestNotifier notifier, WidgetRef ref) {
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
          onSave: () {
            ref
                .read(fullCheckupProvider.notifier)
                .completeTap(state.dualResult!);
            ref.read(tapTestProvider.notifier).reset();
          },
          onRetry: notifier.reset,
        );
    }
  }
}
