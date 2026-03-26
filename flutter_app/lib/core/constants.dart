// Stroke Mitra - Application Constants
//
/// Central configuration for Supabase connection, table names,
/// and application-wide constants. Environment values are loaded
/// from .env via flutter_dotenv.

import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  AppConstants._();

  // ─── Supabase Configuration ───
  static String get supabaseUrl => dotenv.env['SUPABASE_URL'] ?? '';
  static String get supabaseAnonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? '';

  // ─── Anthropic API ───
  static String get anthropicApiKey => dotenv.env['ANTHROPIC_API_KEY'] ?? '';

  // ─── Table Names ───
  static const String tableSessions = 'sessions';
  static const String tableSessionData = 'session_data';

  // ─── Storage Buckets ───
  static const String bucketRecordings = 'recordings';
  static const String bucketMedicalPdfs = 'medical-pdfs';

  // ─── Table Names (Additional) ───
  static const String tableMedicalReports = 'medical_reports';
  static const String tableProfiles = 'profiles';

  // ─── Data Types ───
  static const String dataTypeFace = 'face';
  static const String dataTypeVoice = 'voice';
  static const String dataTypeMotion = 'motion';
  static const String dataTypeTap = 'tap';

  // ─── App Info ───
  static const String appName = 'Stroke Mitra';
  static const String appTagline = 'Detect Stroke Early. Save Lives.';
  static const String appVersion = '1.0.0';

  // ─── Speech Analysis API ───
  static const String speechApiBaseUrl =
      'https://dhruvb1906-strokemitra-api.hf.space';
  static const Duration speechApiTimeout = Duration(seconds: 120);

  // ─── Face Symmetry API ───
  static const String faceApiBaseUrl =
      'https://smfacefeature-production.up.railway.app';
  static const Duration faceApiTimeout = Duration(seconds: 120);

  // ─── Emergency Numbers ───
  static const String emergencyNumber = '112';
  static const String ambulanceNumber = '108';

  // ─── Voice Prompt ───
  static const String voicePrompt =
      'The quick brown fox jumps over the lazy dog.';

  // ─── Medical Disclaimer ───
  static const String disclaimerTitle = 'Prototype Screening Tool';
  static const String disclaimerBody =
      'This application is for demonstration and research purposes only. '
      'It is not a medical device and does not provide a diagnosis. '
      'If you suspect a stroke, call emergency services immediately.';
}
