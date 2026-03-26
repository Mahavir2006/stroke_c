import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class PlatformCameraView extends StatefulWidget {
  final void Function(bool ready) onReadyChanged;
  final void Function(String error) onError;

  const PlatformCameraView({
    super.key,
    required this.onReadyChanged,
    required this.onError,
  });

  @override
  State<PlatformCameraView> createState() => PlatformCameraViewState();
}

class PlatformCameraViewState extends State<PlatformCameraView>
    with WidgetsBindingObserver {
  CameraController? _controller;
  bool _isInitialized = false;
  bool _isInitializing = false; // guard against concurrent init

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initCamera();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Don't interfere while initializing (e.g. permission dialog)
    if (_isInitializing) return;

    final controller = _controller;

    if (state == AppLifecycleState.inactive) {
      // App going to background — release camera
      if (controller != null && controller.value.isInitialized) {
        controller.dispose();
        _controller = null;
        if (mounted) setState(() => _isInitialized = false);
      }
    } else if (state == AppLifecycleState.resumed) {
      // App back to foreground — re-init if we disposed
      if (_controller == null) {
        _initCamera();
      }
    }
  }

  Future<void> _initCamera() async {
    if (_isInitializing) return; // prevent concurrent calls
    _isInitializing = true;

    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        widget.onError('No cameras found on this device.');
        return;
      }

      // Prefer front camera for face analysis
      final frontCamera = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      // Dispose any existing controller before creating new one
      if (_controller != null) {
        await _controller!.dispose();
        _controller = null;
      }

      final controller = CameraController(
        frontCamera,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      _controller = controller;
      await controller.initialize();

      if (!mounted) {
        controller.dispose();
        return;
      }

      debugPrint('Camera initialized: preview=${controller.value.previewSize}, '
          'isInitialized=${controller.value.isInitialized}');

      setState(() => _isInitialized = true);
      widget.onReadyChanged(true);
    } on CameraException catch (e) {
      debugPrint('CameraException: ${e.code} - ${e.description}');
      if (mounted) widget.onError(e.description ?? e.toString());
    } catch (e) {
      debugPrint('Camera init error: $e');
      if (mounted) widget.onError(e.toString());
    } finally {
      _isInitializing = false;
    }
  }

  Future<Uint8List?> captureFrame() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return null;

    try {
      final xFile = await controller.takePicture();
      return await xFile.readAsBytes();
    } catch (e) {
      debugPrint('captureFrame error: $e');
      return null;
    }
  }

  void stopCamera() {
    _controller?.dispose();
    _controller = null;
    _isInitialized = false;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    _controller = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    if (!_isInitialized || controller == null || !controller.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    // Use CameraPreview directly — the simplest, most reliable approach
    return CameraPreview(controller);
  }
}
