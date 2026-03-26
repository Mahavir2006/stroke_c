import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../face_analysis/face_result.dart';
import '../voice_check/voice_result.dart';
import '../motion_test/motion_service.dart';
import '../tap_test/tap_scoring.dart';

enum CheckupStep { face, voice, motion, tap, report }

class FullCheckupState {
  final CheckupStep currentStep;
  final FaceAnalysisResult? faceResult;
  final VoiceResult? voiceResult;
  final MotionResult? motionResult;
  final DualTapResult? tapResult;

  const FullCheckupState({
    this.currentStep = CheckupStep.face,
    this.faceResult,
    this.voiceResult,
    this.motionResult,
    this.tapResult,
  });

  bool get allDone =>
      faceResult != null &&
      voiceResult != null &&
      motionResult != null &&
      tapResult != null;

  FullCheckupState copyWith({
    CheckupStep? currentStep,
    FaceAnalysisResult? faceResult,
    VoiceResult? voiceResult,
    MotionResult? motionResult,
    DualTapResult? tapResult,
  }) {
    return FullCheckupState(
      currentStep: currentStep ?? this.currentStep,
      faceResult: faceResult ?? this.faceResult,
      voiceResult: voiceResult ?? this.voiceResult,
      motionResult: motionResult ?? this.motionResult,
      tapResult: tapResult ?? this.tapResult,
    );
  }
}

class FullCheckupNotifier extends StateNotifier<FullCheckupState> {
  FullCheckupNotifier() : super(const FullCheckupState());

  void completeFace(FaceAnalysisResult result) {
    state = state.copyWith(
      faceResult: result,
      currentStep: CheckupStep.voice,
    );
  }

  void completeVoice(VoiceResult result) {
    state = state.copyWith(
      voiceResult: result,
      currentStep: CheckupStep.motion,
    );
  }

  void completeMotion(MotionResult result) {
    state = state.copyWith(
      motionResult: result,
      currentStep: CheckupStep.tap,
    );
  }

  void completeTap(DualTapResult result) {
    state = state.copyWith(
      tapResult: result,
      currentStep: CheckupStep.report,
    );
  }

  void reset() {
    state = const FullCheckupState();
  }
}

final fullCheckupProvider =
    StateNotifierProvider<FullCheckupNotifier, FullCheckupState>(
  (ref) => FullCheckupNotifier(),
);
