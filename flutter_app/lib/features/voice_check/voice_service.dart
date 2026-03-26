// Stroke Mitra - Voice Service
//
/// Manages audio recording lifecycle and communicates with the
/// speech analysis API at /v1/speech/analyse.
/// Handles both web (blob URLs) and native (file paths) platforms.

import 'dart:convert';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

import '../../core/constants.dart';
import 'voice_result.dart';

class VoiceService {
  final AudioRecorder _recorder = AudioRecorder();

  static const int minDurationSec = 5;
  static const int maxDurationSec = 10;

  // ─── Recording ───

  Future<bool> hasPermission() => _recorder.hasPermission();

  /// Starts recording. On native platforms, records to a temp file.
  /// On web, the recorder handles blob storage internally.
  /// Returns the recording path (or empty string on web since path is
  /// only known after stop).
  Future<String> startRecording() async {
    if (kIsWeb) {
      // Web: record without a path — the recorder stores as a blob.
      // Use opus for better web compatibility.
      await _recorder.start(
        const RecordConfig(
          encoder: AudioEncoder.opus,
          numChannels: 1,
          sampleRate: 16000,
        ),
        path: '',
      );
      return '';
    } else {
      final dir = await getTemporaryDirectory();
      final path = '${dir.path}/stroke_mitra_recording.m4a';
      await _recorder.start(
        const RecordConfig(
          encoder: AudioEncoder.aacLc,
          numChannels: 1,
          sampleRate: 44100,
        ),
        path: path,
      );
      return path;
    }
  }

  /// Stops recording and returns the path/URL to the audio.
  /// On web this is a blob URL, on native it's a file path.
  Future<String?> stopRecording() => _recorder.stop();

  // ─── API ───

  /// Sends the recorded audio to the speech analysis endpoint.
  /// On web, fetches the blob URL bytes. On native, reads from file path.
  Future<VoiceResult> analyseAudio(
    String filePath, {
    int? patientAge,
    double? onsetHours,
  }) async {
    final uri = Uri.parse(
      '${AppConstants.speechApiBaseUrl}/v1/speech/analyse',
    );
    final request = http.MultipartRequest('POST', uri);

    if (kIsWeb) {
      // Web: filePath is a blob URL — fetch the bytes
      final blobResponse = await http.get(Uri.parse(filePath));
      request.files.add(http.MultipartFile.fromBytes(
        'audio_file',
        blobResponse.bodyBytes,
        filename: 'recording.ogg',
        contentType: MediaType('audio', 'ogg'),
      ));
    } else {
      request.files.add(
        await http.MultipartFile.fromPath('audio_file', filePath),
      );
    }

    if (patientAge != null) {
      request.fields['patient_age'] = patientAge.toString();
    }
    if (onsetHours != null) {
      request.fields['onset_hours'] = onsetHours.toString();
    }

    final streamed = await request.send().timeout(
          AppConstants.speechApiTimeout,
        );
    final response = await http.Response.fromStream(streamed);

    if (response.statusCode != 200) {
      throw Exception(
        'API returned ${response.statusCode}: ${response.body}',
      );
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return VoiceResult.fromJson(json);
  }

  /// Fire-and-forget health check to warm the ML model on HF Spaces.
  static Future<void> pingHealthCheck() async {
    try {
      await http
          .get(Uri.parse('${AppConstants.speechApiBaseUrl}/healthz'))
          .timeout(const Duration(seconds: 10));
    } catch (_) {
      // Best-effort warm-up — swallow all errors.
    }
  }

  void dispose() {
    _recorder.dispose();
  }
}
