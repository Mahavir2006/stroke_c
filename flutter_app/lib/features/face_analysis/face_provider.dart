// Stroke Mitra - Face Analysis Provider
//
/// Riverpod StateNotifier managing the face symmetry check lifecycle:
/// idle → processingBaseline → baselineDone → processingTest → result.
///
/// Three-step flow all on the Face Analysis screen.
/// After baseline, the image is saved to Supabase storage for profile display.

import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'face_result.dart';
import 'face_service.dart';

// ─── Phase Enum ──────────────────────────────────────────────────────────────
enum FacePhase {
  idle,
  processingBaseline,
  baselineDone,
  processingTest,
  result,
  error,
}

// ─── State ───────────────────────────────────────────────────────────────────
class FaceState {
  final FacePhase phase;
  final String? fingerprintData;
  final FaceAnalysisResult? result;
  final String? errorMessage;

  const FaceState({
    this.phase = FacePhase.idle,
    this.fingerprintData,
    this.result,
    this.errorMessage,
  });

  bool get hasBaseline => fingerprintData != null;

  FaceState copyWith({
    FacePhase? phase,
    String? fingerprintData,
    FaceAnalysisResult? result,
    String? errorMessage,
    bool clearResult = false,
    bool clearError = false,
  }) {
    return FaceState(
      phase: phase ?? this.phase,
      fingerprintData: fingerprintData ?? this.fingerprintData,
      result: clearResult ? null : (result ?? this.result),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

// ─── Notifier ────────────────────────────────────────────────────────────────
class FaceNotifier extends StateNotifier<FaceState> {
  FaceNotifier() : super(const FaceState());

  Future<void> submitBaseline(Uint8List imageBytes) async {
    state = state.copyWith(
      phase: FacePhase.processingBaseline,
      clearError: true,
    );

    try {
      final baseline = await FaceService.captureBaseline(imageBytes);

      // Save baseline image to storage for profile display (fire-and-forget)
      _saveBaselineImage(imageBytes);

      state = state.copyWith(
        phase: FacePhase.baselineDone,
        fingerprintData: baseline.fingerprintData,
      );
    } on TimeoutException {
      state = state.copyWith(
        phase: FacePhase.error,
        errorMessage:
            'Baseline processing timed out. The server may be starting up — please try again.',
      );
    } catch (e) {
      final msg = e.toString();
      final userMessage = msg.contains('SocketException') ||
              msg.contains('Failed host lookup')
          ? 'No internet connection. Please check your network.'
          : msg.contains('Not authenticated')
              ? 'Please log in before running the face analysis.'
              : 'Baseline processing failed: $msg';
      state = state.copyWith(
        phase: FacePhase.error,
        errorMessage: userMessage,
      );
    }
  }

  Future<void> submitTest(Uint8List imageBytes) async {
    if (state.fingerprintData == null) {
      state = state.copyWith(
        phase: FacePhase.error,
        errorMessage:
            'No baseline captured yet. Please capture baseline first.',
      );
      return;
    }

    state = state.copyWith(
      phase: FacePhase.processingTest,
      clearError: true,
    );

    try {
      final result = await FaceService.analyzeTest(
        imageBytes,
        state.fingerprintData!,
      );
      state = state.copyWith(phase: FacePhase.result, result: result);
    } on TimeoutException {
      state = state.copyWith(
        phase: FacePhase.error,
        errorMessage:
            'Analysis timed out. The server may be starting up — please try again.',
      );
    } catch (e) {
      final msg = e.toString();
      final userMessage = msg.contains('SocketException') ||
              msg.contains('Failed host lookup')
          ? 'No internet connection. Please check your network.'
          : 'Analysis failed: $msg';
      state = state.copyWith(
        phase: FacePhase.error,
        errorMessage: userMessage,
      );
    }
  }

  /// Save baseline image to Supabase storage for display on profile page.
  Future<void> _saveBaselineImage(Uint8List imageBytes) async {
    try {
      final client = Supabase.instance.client;
      final userId = client.auth.currentUser?.id;
      if (userId == null) return;

      final path = '$userId/baseline.jpg';
      await client.storage.from('face-images').uploadBinary(
            path,
            imageBytes,
            fileOptions:
                const FileOptions(contentType: 'image/jpeg', upsert: true),
          );
    } catch (_) {
      // Best-effort — don't block the face analysis flow
    }
  }

  /// Go back to baseline-done step to retake the test photo only.
  void retakeTest() {
    state = state.copyWith(
      phase: FacePhase.baselineDone,
      clearResult: true,
      clearError: true,
    );
  }

  /// Full reset — start over from scratch.
  void reset() {
    state = const FaceState();
  }
}

// ─── Provider ────────────────────────────────────────────────────────────────
final faceProvider =
    StateNotifierProvider.autoDispose<FaceNotifier, FaceState>(
  (ref) => FaceNotifier(),
);
