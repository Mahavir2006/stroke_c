// Stroke Mitra - Voice Check Provider
//
/// Riverpod StateNotifier managing the full voice check lifecycle:
/// idle → recording → idle (with recording) → analyzing → result.

import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'voice_result.dart';
import 'voice_service.dart';

// ─── Phase Enum ──────────────────────────────────────────────────────────────
enum VoicePhase { idle, recording, analyzing, result, error }

// ─── State ───────────────────────────────────────────────────────────────────
class VoiceState {
  final VoicePhase phase;
  final String? recordingPath;
  final int elapsedSeconds;
  final int recordedDuration; // captured on stop
  final VoiceResult? result;
  final String? errorMessage;

  const VoiceState({
    this.phase = VoicePhase.idle,
    this.recordingPath,
    this.elapsedSeconds = 0,
    this.recordedDuration = 0,
    this.result,
    this.errorMessage,
  });

  bool get hasRecording =>
      recordingPath != null && phase != VoicePhase.recording;

  VoiceState copyWith({
    VoicePhase? phase,
    String? recordingPath,
    int? elapsedSeconds,
    int? recordedDuration,
    VoiceResult? result,
    String? errorMessage,
    bool clearResult = false,
    bool clearError = false,
  }) {
    return VoiceState(
      phase: phase ?? this.phase,
      recordingPath: recordingPath ?? this.recordingPath,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
      recordedDuration: recordedDuration ?? this.recordedDuration,
      result: clearResult ? null : (result ?? this.result),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

// ─── Notifier ────────────────────────────────────────────────────────────────
class VoiceNotifier extends StateNotifier<VoiceState> {
  final VoiceService _service = VoiceService();
  final AudioPlayer _player = AudioPlayer();
  Timer? _recordingTimer;

  VoiceNotifier() : super(const VoiceState());

  Future<void> startRecording() async {
    if (!await _service.hasPermission()) {
      state = state.copyWith(
        phase: VoicePhase.error,
        errorMessage: 'Microphone access denied. Please allow permissions.',
      );
      return;
    }

    try {
      final path = await _service.startRecording();
      state = VoiceState(phase: VoicePhase.recording, recordingPath: path);

      _recordingTimer = Timer.periodic(const Duration(seconds: 1), (t) {
        state = state.copyWith(elapsedSeconds: t.tick);
        if (t.tick >= VoiceService.maxDurationSec) {
          stopRecording();
        }
      });
    } catch (e) {
      state = state.copyWith(
        phase: VoicePhase.error,
        errorMessage: 'Could not start recording: $e',
      );
    }
  }

  Future<void> stopRecording() async {
    _recordingTimer?.cancel();
    _recordingTimer = null;

    final duration = state.elapsedSeconds;

    try {
      final path = await _service.stopRecording();
      state = state.copyWith(
        phase: VoicePhase.idle,
        recordingPath: path ?? state.recordingPath,
        recordedDuration: duration,
        elapsedSeconds: 0,
      );
    } catch (_) {
      state = state.copyWith(
        phase: VoicePhase.idle,
        recordedDuration: duration,
        elapsedSeconds: 0,
      );
    }
  }

  Future<void> analyseRecording() async {
    final path = state.recordingPath;
    if (path == null) return;

    if (state.recordedDuration < VoiceService.minDurationSec) {
      state = state.copyWith(
        phase: VoicePhase.error,
        errorMessage:
            'Recording too short. Please record at least ${VoiceService.minDurationSec} seconds.',
      );
      return;
    }

    state = state.copyWith(phase: VoicePhase.analyzing, clearError: true);

    try {
      final result = await _service.analyseAudio(path);
      state = state.copyWith(phase: VoicePhase.result, result: result);
    } on TimeoutException {
      state = state.copyWith(
        phase: VoicePhase.error,
        errorMessage:
            'Analysis timed out. The server may be starting up — please try again in a moment.',
      );
    } catch (e) {
      final msg = e.toString();
      final userMessage = msg.contains('SocketException') || msg.contains('Failed host lookup')
          ? 'No internet connection. Please check your network.'
          : 'Analysis failed: $msg';
      state = state.copyWith(
        phase: VoicePhase.error,
        errorMessage: userMessage,
      );
    }
  }

  Future<void> playRecording() async {
    final path = state.recordingPath;
    if (path != null) {
      if (kIsWeb) {
        await _player.play(UrlSource(path));
      } else {
        await _player.play(DeviceFileSource(path));
      }
    }
  }

  void reset() {
    _recordingTimer?.cancel();
    _recordingTimer = null;
    state = const VoiceState();
  }

  @override
  void dispose() {
    _recordingTimer?.cancel();
    _service.dispose();
    _player.dispose();
    super.dispose();
  }
}

// ─── Provider ────────────────────────────────────────────────────────────────
final voiceProvider =
    StateNotifierProvider.autoDispose<VoiceNotifier, VoiceState>(
  (ref) => VoiceNotifier(),
);
