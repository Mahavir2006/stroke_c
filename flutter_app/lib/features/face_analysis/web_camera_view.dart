// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:ui_web' as ui_web;
import 'dart:typed_data';
import 'dart:async';

import 'package:flutter/material.dart';

/// Web-native camera view using getUserMedia + HtmlElementView.
/// The [camera] package does not reliably support Flutter Web.
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

class PlatformCameraViewState extends State<PlatformCameraView> {
  html.VideoElement? _video;
  html.MediaStream? _stream;
  // Unique, stable ID for this widget instance
  late final String _viewId;
  bool _viewRegistered = false;
  bool _cameraStarted = false;

  @override
  void initState() {
    super.initState();
    _viewId = 'web-camera-${identityHashCode(this)}';
    _initCamera();
  }

  Future<void> _initCamera() async {
    // Create the video element first
    final video = html.VideoElement()
      ..autoplay = true
      ..muted = true
      ..style.width = '100%'
      ..style.height = '100%'
      ..style.objectFit = 'cover'
      ..style.transform = 'scaleX(-1)'; // mirror for selfie

    _video = video;

    // Register the platform view factory BEFORE requesting camera
    // so HtmlElementView can render immediately once setState fires
    if (!_viewRegistered) {
      ui_web.platformViewRegistry.registerViewFactory(
        _viewId,
        (int id) => _video!,
      );
      _viewRegistered = true;
    }

    // Now show the HtmlElementView (video element exists, just no stream yet)
    if (mounted) setState(() => _cameraStarted = true);

    // Request camera access
    try {
      _stream = await html.window.navigator.mediaDevices!.getUserMedia({
        'video': {'facingMode': 'user', 'width': 640, 'height': 480},
        'audio': false,
      });

      video.srcObject = _stream;

      video.onLoadedMetadata.first.then((_) {
        if (mounted) widget.onReadyChanged(true);
      });
    } catch (e) {
      if (mounted) widget.onError(e.toString());
    }
  }

  /// Capture current frame as PNG bytes.
  Future<Uint8List?> captureFrame() async {
    final video = _video;
    if (video == null || video.videoWidth == 0) return null;

    final canvas = html.CanvasElement(
      width: video.videoWidth,
      height: video.videoHeight,
    );
    canvas.context2D
      ..translate(video.videoWidth.toDouble(), 0)
      ..scale(-1, 1)
      ..drawImage(video, 0, 0);

    final blob = await canvas.toBlob('image/png');
    final reader = html.FileReader();
    final completer = Completer<Uint8List>();
    reader.onLoadEnd.listen((_) {
      final result = reader.result;
      if (result is Uint8List) {
        completer.complete(result);
      } else if (result is ByteBuffer) {
        completer.complete(result.asUint8List());
      } else {
        completer.completeError('Unexpected FileReader result type');
      }
    });
    reader.readAsArrayBuffer(blob);
    return completer.future;
  }

  void stopCamera() {
    _stream?.getTracks().forEach((t) => t.stop());
    _stream = null;
    _video?.srcObject = null;
  }

  @override
  void dispose() {
    stopCamera();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_cameraStarted) {
      return const Center(child: CircularProgressIndicator());
    }
    return HtmlElementView(viewType: _viewId);
  }
}
