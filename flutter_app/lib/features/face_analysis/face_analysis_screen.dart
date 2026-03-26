import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme.dart';
import '../../core/constants.dart';
import '../../shared/utils/session_service.dart';
import 'face_provider.dart';
import 'camera_view.dart';

class FaceAnalysisScreen extends ConsumerStatefulWidget {
  const FaceAnalysisScreen({super.key});

  @override
  ConsumerState<FaceAnalysisScreen> createState() => _FaceAnalysisScreenState();
}

class _FaceAnalysisScreenState extends ConsumerState<FaceAnalysisScreen> {
  final _cameraKey = GlobalKey<PlatformCameraViewState>();
  bool _isCameraReady = false;
  bool _isCameraError = false;

  bool _faceDetected = false;
  bool _ovalAligned = false;
  bool _poseValid = false;
  bool _lightingOk = false;
  bool get _allChecksPass =>
      _faceDetected && _ovalAligned && _poseValid && _lightingOk;

  FacePhase? _lastPhase;
  Timer? _analysisTimer;
  bool _isAnalyzing = false;
  bool _showCamera = true;

  @override
  void initState() {
    super.initState();
    _startPeriodicAnalysis();
  }

  void _startPeriodicAnalysis() {
    _analysisTimer?.cancel();
    _analysisTimer = Timer.periodic(
      const Duration(milliseconds: 1500),
      (_) => _analyzeCurrentFrame(),
    );
  }

  void _stopPeriodicAnalysis() {
    _analysisTimer?.cancel();
    _analysisTimer = null;
  }

  Future<void> _analyzeCurrentFrame() async {
    if (_isAnalyzing || !_isCameraReady || !mounted) return;
    _isAnalyzing = true;
    try {
      final bytes = await _cameraKey.currentState?.captureFrame();
      if (bytes == null) {
        _isAnalyzing = false;
        return;
      }
      await _runPixelAnalysis(bytes);
    } catch (_) {
    } finally {
      _isAnalyzing = false;
    }
  }

  Future<void> _runPixelAnalysis(Uint8List bytes) async {
    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    final image = frame.image;
    final byteData = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
    if (byteData == null) {
      image.dispose();
      return;
    }

    final pixels = byteData.buffer.asUint8List();
    final width = image.width;
    final height = image.height;
    image.dispose();

    double totalBrightness = 0;
    int sampleCount = 0;
    for (int i = 0; i < pixels.length; i += 16) {
      if (i + 2 >= pixels.length) break;
      totalBrightness +=
          pixels[i] * 0.299 + pixels[i + 1] * 0.587 + pixels[i + 2] * 0.114;
      sampleCount++;
    }
    final avgBrightness = sampleCount > 0 ? totalBrightness / sampleCount : 0.0;
    final lighting = avgBrightness > 45 && avgBrightness < 225;

    final csx = (width * 0.25).toInt(), cex = (width * 0.75).toInt();
    final csy = (height * 0.15).toInt(), cey = (height * 0.65).toInt();
    double cSum = 0, cSqSum = 0;
    int cCount = 0;
    for (int y = csy; y < cey; y += 3) {
      for (int x = csx; x < cex; x += 3) {
        final idx = (y * width + x) * 4;
        if (idx + 2 >= pixels.length) continue;
        final b = pixels[idx] * 0.299 +
            pixels[idx + 1] * 0.587 +
            pixels[idx + 2] * 0.114;
        cSum += b;
        cSqSum += b * b;
        cCount++;
      }
    }
    double cVar = 0;
    if (cCount > 0) {
      final m = cSum / cCount;
      cVar = (cSqSum / cCount) - (m * m);
    }
    final face = cVar > 300;

    double eSum = 0, eSqSum = 0;
    int eCount = 0;
    for (int x = 0; x < width; x += 6) {
      for (final y in [5, height - 5]) {
        final idx = (y * width + x) * 4;
        if (idx + 2 >= pixels.length) continue;
        final b = pixels[idx] * 0.299 +
            pixels[idx + 1] * 0.587 +
            pixels[idx + 2] * 0.114;
        eSum += b;
        eSqSum += b * b;
        eCount++;
      }
    }
    double eVar = 0;
    if (eCount > 0) {
      final m = eSum / eCount;
      eVar = (eSqSum / eCount) - (m * m);
    }
    final oval = face && cVar > eVar * 1.2;

    double lSum = 0, rSum = 0;
    int lCount = 0, rCount = 0;
    final midX = width ~/ 2;
    for (int y = csy; y < cey; y += 4) {
      for (int x = csx; x < midX; x += 4) {
        final idx = (y * width + x) * 4;
        if (idx + 2 >= pixels.length) continue;
        lSum += pixels[idx] * 0.299 +
            pixels[idx + 1] * 0.587 +
            pixels[idx + 2] * 0.114;
        lCount++;
      }
      for (int x = midX; x < cex; x += 4) {
        final idx = (y * width + x) * 4;
        if (idx + 2 >= pixels.length) continue;
        rSum += pixels[idx] * 0.299 +
            pixels[idx + 1] * 0.587 +
            pixels[idx + 2] * 0.114;
        rCount++;
      }
    }
    final lMean = lCount > 0 ? lSum / lCount : 0.0;
    final rMean = rCount > 0 ? rSum / rCount : 0.0;
    final symDiff = (lMean - rMean).abs() / (avgBrightness.clamp(1, 255));
    final pose = face && symDiff < 0.25;

    if (mounted) {
      setState(() {
        _lightingOk = lighting;
        _faceDetected = face;
        _ovalAligned = oval;
        _poseValid = pose;
      });
    }
  }

  Future<void> _captureAndSubmit({required bool isBaseline}) async {
    if (!_isCameraReady) return;
    _stopPeriodicAnalysis();
    try {
      final bytes = await _cameraKey.currentState?.captureFrame();
      if (bytes == null) {
        _startPeriodicAnalysis();
        return;
      }
      if (isBaseline) {
        ref.read(faceProvider.notifier).submitBaseline(bytes);
      } else {
        ref.read(faceProvider.notifier).submitTest(bytes);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.face_captureFailed(e.toString()))),
        );
      }
      _startPeriodicAnalysis();
    }
  }

  int _currentStep(FaceState state) {
    switch (state.phase) {
      case FacePhase.idle:
      case FacePhase.processingBaseline:
        return 0;
      case FacePhase.baselineDone:
      case FacePhase.processingTest:
        return 1;
      case FacePhase.result:
        return 2;
      case FacePhase.error:
        return state.hasBaseline ? 1 : 0;
    }
  }

  @override
  void dispose() {
    _stopPeriodicAnalysis();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;
    final state = ref.watch(faceProvider);
    final step = _currentStep(state);

    // Manage camera visibility based on phase
    if (_lastPhase != state.phase) {
      final needsCamera = state.phase == FacePhase.idle ||
          state.phase == FacePhase.baselineDone ||
          state.phase == FacePhase.error;
      if (needsCamera && !_showCamera) {
        setState(() {
          _showCamera = true;
          _isCameraReady = false;
          _isCameraError = false;
        });
        _startPeriodicAnalysis();
      } else if (!needsCamera && _showCamera) {
        _stopPeriodicAnalysis();
        _cameraKey.currentState?.stopCamera();
        setState(() {
          _showCamera = false;
        });
      }
      _lastPhase = state.phase;
    }

    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(children: [
          Icon(Icons.camera_alt_rounded,
              color: theme.colorScheme.primary, size: 24),
          const SizedBox(width: 8),
          Text(context.l10n.face_title,
              style: AppTheme.headingMD
                  .copyWith(color: theme.colorScheme.onSurface)),
        ]),
        const SizedBox(height: AppTheme.spaceMD),
        FaceStepIndicator(currentStep: step),
        const SizedBox(height: AppTheme.spaceLG),
        if (state.phase == FacePhase.result)
          _buildResultView(state, theme, colors)
        else if (state.phase == FacePhase.processingBaseline ||
            state.phase == FacePhase.processingTest)
          _buildProcessingView(state, theme)
        else
          _buildCameraView(state, step, theme),
        if (state.phase == FacePhase.error && state.errorMessage != null) ...[
          const SizedBox(height: AppTheme.spaceMD),
          _buildErrorBanner(state.errorMessage!),
        ],
      ]),
    );
  }

  Widget _buildCameraView(FaceState state, int step, ThemeData theme) {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Text(
        step == 0
            ? context.l10n.face_stepBaseline
            : context.l10n.face_stepTest,
        style: AppTheme.labelTag.copyWith(color: theme.colorScheme.primary),
      ),
      const SizedBox(height: 4),
      Text(
        step == 0
            ? context.l10n.face_baselineInstruction
            : context.l10n.face_testInstruction,
        style: AppTheme.bodySM.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
      ),
      const SizedBox(height: AppTheme.spaceMD),
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppTheme.radiusLG),
          border: Border.all(
              color: theme.colorScheme.primary.withValues(alpha: 0.3),
              width: 2),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppTheme.radiusLG - 1),
          child: AspectRatio(
            aspectRatio: 3 / 4,
            child: _isCameraError
                ? _buildErrorPlaceholder(theme)
                : Stack(fit: StackFit.expand, children: [
                    if (_showCamera)
                      PlatformCameraView(
                        key: _cameraKey,
                        onReadyChanged: (ready) {
                          if (mounted) setState(() => _isCameraReady = ready);
                        },
                        onError: (err) {
                          debugPrint('WebCamera error: $err');
                          if (mounted) setState(() => _isCameraError = true);
                        },
                      ),
                    if (!_isCameraReady && !_isCameraError)
                      Container(
                        color: theme.colorScheme.surfaceContainerHighest,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(
                                  strokeWidth: 3,
                                  color: theme.colorScheme.primary),
                              const SizedBox(height: 12),
                              Text(context.l10n.face_startingCamera,
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: theme.colorScheme.onSurface
                                          .withValues(alpha: 0.5))),
                            ]),
                      ),
                    // Oval overlay
                    Center(
                      child: CustomPaint(
                        size: Size(MediaQuery.of(context).size.width * 0.45,
                            MediaQuery.of(context).size.width * 0.6),
                        painter: OvalWithCrosshairPainter(
                            color: Colors.white.withValues(alpha: 0.8)),
                      ),
                    ),
                  ]),
          ),
        ),
      ),
      const SizedBox(height: AppTheme.spaceSM),
      Center(
          child: Text(context.l10n.face_alignFace,
              style: AppTheme.bodySM.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5)))),
      const SizedBox(height: AppTheme.spaceMD),
      _buildParameterDots(theme),
      const SizedBox(height: AppTheme.spaceLG),
      SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: _allChecksPass && _isCameraReady
              ? () => _captureAndSubmit(isBaseline: step == 0)
              : null,
          icon: const Icon(Icons.camera_alt_rounded),
          label: Text(step == 0 ? context.l10n.face_captureBaseline : context.l10n.face_captureTestPhoto),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(AppTheme.spaceMD),
            textStyle:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    ]);
  }

  Widget _buildErrorPlaceholder(ThemeData theme) {
    return Container(
      color: theme.colorScheme.surfaceContainerHighest,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Icon(Icons.videocam_off_rounded,
            size: 48, color: AppTheme.statusError),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            context.l10n.face_cameraBlocked,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13),
          ),
        ),
        const SizedBox(height: 16),
        OutlinedButton(
          onPressed: () => setState(() {
            _isCameraError = false;
            _isCameraReady = false;
          }),
          child: Text(context.l10n.face_retry),
        ),
      ]),
    );
  }

  Widget _buildParameterDots(ThemeData theme) {
    final checks = [
      (context.l10n.face_faceDetected, _faceDetected),
      (context.l10n.face_ovalAligned, _ovalAligned),
      (context.l10n.face_poseValid, _poseValid),
      (context.l10n.face_lightingOk, _lightingOk),
    ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: checks.map((check) {
        final isActive = check.$2;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Column(children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive
                    ? AppTheme.statusSuccess
                    : theme.colorScheme.outline,
              ),
            ),
            const SizedBox(height: 4),
            Text(check.$1,
                style: TextStyle(
                  fontSize: 10,
                  color: isActive
                      ? AppTheme.statusSuccess
                      : theme.colorScheme.onSurface.withValues(alpha: 0.4),
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                )),
          ]),
        );
      }).toList(),
    );
  }

  Widget _buildProcessingView(FaceState state, ThemeData theme) {
    final isBaseline = state.phase == FacePhase.processingBaseline;
    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceXL),
      child: Column(children: [
        SizedBox(
            width: 56,
            height: 56,
            child: CircularProgressIndicator(
                strokeWidth: 4, color: theme.colorScheme.primary)),
        const SizedBox(height: AppTheme.spaceLG),
        Text(isBaseline ? context.l10n.face_processingBaseline : context.l10n.face_analyzingSymmetry,
            style: AppTheme.headingSM
                .copyWith(color: theme.colorScheme.onSurface)),
        const SizedBox(height: AppTheme.spaceSM),
        Text(context.l10n.face_serverWarmup,
            style: AppTheme.bodySM.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5)),
            textAlign: TextAlign.center),
      ]),
    );
  }

  Widget _buildResultView(FaceState state, ThemeData theme, AppColors colors) {
    final result = state.result;
    if (result == null) return const SizedBox.shrink();
    final isNormal = result.isNormal;
    final verdictColor =
        isNormal ? AppTheme.statusSuccess : AppTheme.statusError;

    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceMD),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusLG),
        border: Border.all(color: colors.cardBorder),
      ),
      child: Column(children: [
        Text(context.l10n.face_stepResult,
            style: AppTheme.labelTag.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5))),
        const SizedBox(height: AppTheme.spaceMD),
        Container(
          padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spaceLG, vertical: AppTheme.spaceMD),
          decoration: BoxDecoration(
            color: verdictColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppTheme.radiusMD),
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(isNormal ? Icons.check_circle_rounded : Icons.warning_rounded,
                color: verdictColor, size: 28),
            const SizedBox(width: 10),
            Text(result.verdict,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: verdictColor)),
          ]),
        ).animate().scale(duration: 400.ms, curve: Curves.easeOutBack),
        const SizedBox(height: AppTheme.spaceLG),
        ...result.raw.entries
            .where((e) => !['verdict', 'result', 'status', 'symmetry_status']
                .contains(e.key))
            .map((entry) => Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: AppTheme.spaceXS),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                            child: Text(_formatKey(entry.key),
                                style: TextStyle(
                                    fontSize: 14,
                                    color: theme.colorScheme.onSurface
                                        .withValues(alpha: 0.5)))),
                        const SizedBox(width: 12),
                        Flexible(
                            child: Text(_formatValue(entry.value),
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: theme.colorScheme.onSurface),
                                textAlign: TextAlign.end)),
                      ]),
                )),
        const SizedBox(height: AppTheme.spaceLG),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppTheme.spaceMD),
          decoration: BoxDecoration(
            color: verdictColor.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(AppTheme.radiusMD),
          ),
          child: Text(
            isNormal
                ? context.l10n.face_normalResult
                : context.l10n.face_abnormalResult,
            style: AppTheme.bodySM.copyWith(color: verdictColor),
            textAlign: TextAlign.center,
          ),
        ),
        if (!isNormal) ...[
          const SizedBox(height: AppTheme.spaceMD),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppTheme.spaceMD),
            decoration: BoxDecoration(
              color: AppTheme.statusError.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppTheme.radiusMD),
              border: Border.all(
                  color: AppTheme.statusError.withValues(alpha: 0.3)),
            ),
            child: Column(children: [
              const Icon(Icons.emergency_rounded,
                  color: AppTheme.statusError, size: 28),
              const SizedBox(height: 8),
              Text(
                  context.l10n.emergency_suspectStroke,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.statusError),
                  textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Text(
                  context.l10n.emergency_numbers(AppConstants.emergencyNumber, AppConstants.ambulanceNumber),
                  style: const TextStyle(
                      fontSize: 13, color: AppTheme.statusError)),
            ]),
          ),
        ],
        const SizedBox(height: AppTheme.spaceLG),
        Row(children: [
          Expanded(
              child: OutlinedButton.icon(
            onPressed: () => ref.read(faceProvider.notifier).reset(),
            icon: const Icon(Icons.refresh_rounded, size: 16),
            label: Text(context.l10n.common_testAgain),
          )),
          const SizedBox(width: AppTheme.spaceMD),
          Expanded(
              child: ElevatedButton.icon(
            onPressed: () {
              SessionService.submitData(
                  'temp-session', AppConstants.dataTypeFace, result.toJson());
              ref.read(faceProvider.notifier).reset();
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(context.l10n.common_resultsSaved)));
              }
            },
            icon: const Icon(Icons.save_rounded, size: 16),
            label: Text(context.l10n.common_saveAndContinue),
          )),
        ]),
      ]),
    );
  }

  Widget _buildErrorBanner(String message) {
    final state = ref.read(faceProvider);
    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceMD),
      decoration: BoxDecoration(
        color: AppTheme.statusError.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppTheme.radiusMD),
        border: Border.all(color: AppTheme.statusError.withValues(alpha: 0.2)),
      ),
      child: Column(children: [
        Row(children: [
          const Icon(Icons.error_outline_rounded,
              color: AppTheme.statusError, size: 20),
          const SizedBox(width: 8),
          Expanded(
              child: Text(message,
                  style: const TextStyle(
                      fontSize: 13, color: AppTheme.statusError))),
        ]),
        const SizedBox(height: AppTheme.spaceSM),
        SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                if (state.hasBaseline) {
                  ref.read(faceProvider.notifier).retakeTest();
                } else {
                  ref.read(faceProvider.notifier).reset();
                }
              },
              icon: const Icon(Icons.refresh_rounded, size: 16),
              label: Text(context.l10n.common_tryAgain),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.statusError,
                side: BorderSide(
                    color: AppTheme.statusError.withValues(alpha: 0.3)),
              ),
            )),
      ]),
    );
  }

  String _formatKey(String key) => key
      .replaceAll('_', ' ')
      .split(' ')
      .map((w) => w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1)}')
      .join(' ');

  String _formatValue(dynamic value) {
    if (value is double) {
      if (value >= 0 && value <= 1) {
        return '${(value * 100).toStringAsFixed(1)}%';
      }
      return value.toStringAsFixed(2);
    }
    return value.toString();
  }
}

// ─── Step Indicator ──────────────────────────────────────────────────────────
class FaceStepIndicator extends StatelessWidget {
  final int currentStep;
  const FaceStepIndicator({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final steps = [context.l10n.face_stepBaseline_label, context.l10n.face_stepTest_label, context.l10n.face_stepResult_label];
    return Row(
      children: List.generate(steps.length, (i) {
        final isActive = i == currentStep;
        final isCompleted = i < currentStep;
        final color = isActive
            ? theme.colorScheme.primary
            : isCompleted
                ? AppTheme.statusSuccess
                : theme.colorScheme.outline;
        return Expanded(
          child: Column(children: [
            Text(steps[i],
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isActive || isCompleted
                      ? FontWeight.w600
                      : FontWeight.w400,
                  color: color,
                )),
            const SizedBox(height: 6),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: 3,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                  color: color, borderRadius: BorderRadius.circular(2)),
            ),
          ]),
        );
      }),
    );
  }
}

// ─── Dashed Oval with Crosshair ──────────────────────────────────────────────
class OvalWithCrosshairPainter extends CustomPainter {
  final Color color;
  const OvalWithCrosshairPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    final path = Path()..addOval(Rect.fromLTWH(0, 0, size.width, size.height));
    for (final metric in path.computeMetrics()) {
      double d = 0;
      bool draw = true;
      while (d < metric.length) {
        final len = draw ? 8.0 : 6.0;
        final end = (d + len).clamp(0, metric.length).toDouble();
        if (draw) canvas.drawPath(metric.extractPath(d, end), paint);
        d = end;
        draw = !draw;
      }
    }
    final crossPaint = Paint()
      ..color = color.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    final cx = size.width / 2, cy = size.height / 2;
    final rx = size.width / 2 * 0.85, ry = size.height / 2 * 0.85;
    _dashedLine(canvas, Offset(cx, cy - ry), Offset(cx, cy + ry), crossPaint);
    _dashedLine(canvas, Offset(cx - rx, cy), Offset(cx + rx, cy), crossPaint);
  }

  void _dashedLine(Canvas canvas, Offset a, Offset b, Paint paint) {
    final p = Path()
      ..moveTo(a.dx, a.dy)
      ..lineTo(b.dx, b.dy);
    for (final m in p.computeMetrics()) {
      double d = 0;
      bool draw = true;
      while (d < m.length) {
        final len = draw ? 6.0 : 4.0;
        final end = (d + len).clamp(0, m.length).toDouble();
        if (draw) canvas.drawPath(m.extractPath(d, end), paint);
        d = end;
        draw = !draw;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
