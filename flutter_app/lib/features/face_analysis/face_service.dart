// Stroke Mitra - Face Analysis Service
//
/// Communicates with the face symmetry CV engine at /analyze.
/// Two-step flow:
///   1. mode=baseline + image → returns fingerprint_data
///   2. mode=analyze + image + fingerprint_data → returns verdict

import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/constants.dart';
import 'face_result.dart';

class FaceService {
  /// Returns the current user's Supabase JWT access token (sanitized).
  static String? get _authToken {
    final token = Supabase.instance.client.auth.currentSession?.accessToken;
    if (token == null) return null;
    // Strip any non-printable ASCII characters that could corrupt URLs server-side
    return token.replaceAll(RegExp(r'[^\x20-\x7E]'), '').trim();
  }

  /// Sends a baseline image to get fingerprint_data back.
  static Future<FaceBaselineResult> captureBaseline(
      Uint8List imageBytes) async {
    final token = _authToken;
    if (token == null) throw Exception('Not authenticated');

    final uri = Uri.parse('${AppConstants.faceApiBaseUrl}/analyze');
    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..fields['mode'] = 'baseline'
      ..files.add(http.MultipartFile.fromBytes(
        'image',
        imageBytes,
        filename: 'baseline.jpg',
        contentType: MediaType('image', 'jpeg'),
      ));

    final streamed =
        await request.send().timeout(AppConstants.faceApiTimeout);
    final response = await http.Response.fromStream(streamed);

    if (response.statusCode != 200) {
      throw Exception(
        'API returned ${response.statusCode}: ${response.body}',
      );
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return FaceBaselineResult.fromJson(json);
  }

  /// Sends a test image + fingerprint_data to get symmetry verdict.
  static Future<FaceAnalysisResult> analyzeTest(
    Uint8List imageBytes,
    String fingerprintData,
  ) async {
    final token = _authToken;
    if (token == null) throw Exception('Not authenticated');

    final uri = Uri.parse('${AppConstants.faceApiBaseUrl}/analyze');
    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..fields['mode'] = 'analyze'
      ..fields['fingerprint_data'] = fingerprintData
      ..files.add(http.MultipartFile.fromBytes(
        'image',
        imageBytes,
        filename: 'test.jpg',
        contentType: MediaType('image', 'jpeg'),
      ));

    final streamed =
        await request.send().timeout(AppConstants.faceApiTimeout);
    final response = await http.Response.fromStream(streamed);

    if (response.statusCode != 200) {
      throw Exception(
        'API returned ${response.statusCode}: ${response.body}',
      );
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return FaceAnalysisResult.fromJson(json);
  }

  /// Fire-and-forget health check to warm the CV engine.
  static Future<void> pingHealthCheck() async {
    try {
      await http
          .get(Uri.parse('${AppConstants.faceApiBaseUrl}/health'))
          .timeout(const Duration(seconds: 10));
    } catch (_) {
      // Best-effort warm-up — swallow all errors.
    }
  }
}
