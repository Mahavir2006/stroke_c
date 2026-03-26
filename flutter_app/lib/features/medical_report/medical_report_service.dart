/// Medical Report Service
///
/// Handles PDF extraction, upload to Supabase Storage,
/// Claude API analysis, and database persistence.

import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/constants.dart';
import '../../core/supabase_client.dart';

class MedicalReportService {
  MedicalReportService._();

  static final _client = SupabaseClientManager.client;

  /// Step 1: Extract text from PDF bytes using syncfusion_flutter_pdf
  static Future<String> extractTextFromPdf(Uint8List bytes) async {
    try {
      final document = PdfDocument(inputBytes: bytes);
      final extractor = PdfTextExtractor(document);
      final text = extractor.extractText();
      document.dispose();
      return text.trim();
    } catch (e) {
      throw Exception('Failed to extract text from PDF: $e');
    }
  }

  /// Step 2: Upload PDF to Supabase Storage bucket 'medical-pdfs'
  /// Storage path: '{userId}/medical_reports/{timestamp}_{filename}'
  /// Return signed URL (7-day expiry)
  static Future<({String url, String path})> uploadPdf({
    required Uint8List bytes,
    required String fileName,
    required String userId,
  }) async {
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final path = '$userId/medical_reports/${timestamp}_$fileName';

      await _client.storage.from(AppConstants.bucketMedicalPdfs).uploadBinary(
            path,
            bytes,
            fileOptions: const FileOptions(
              contentType: 'application/pdf',
              upsert: true,
            ),
          );

      final signedUrl = await _client.storage
          .from(AppConstants.bucketMedicalPdfs)
          .createSignedUrl(path, 604800); // 7 days

      return (url: signedUrl, path: path);
    } catch (e) {
      throw Exception('Failed to upload PDF: $e');
    }
  }

  /// Step 3: Analyze text via Claude API
  /// POST https://api.anthropic.com/v1/messages
  /// Model: claude-sonnet-4-20250514
  /// Return JSON: { detected_conditions[], risk_level, risk_label, risk_summary }
  static Future<Map<String, dynamic>> analyzeWithClaude(
      String extractedText) async {
    try {
      final apiKey = AppConstants.anthropicApiKey;
      if (apiKey.isEmpty) {
        throw Exception('Anthropic API key not configured');
      }

      final systemPrompt =
          '''You are a medical report analyzer specializing in stroke risk assessment.

Analyze the provided medical report text and detect the following conditions that increase stroke risk:
- High cholesterol
- High LDL cholesterol
- High blood sugar / diabetes
- High HbA1c
- Hypertension / high blood pressure
- High triglycerides
- Elevated CRP (C-reactive protein)
- High BMI / obesity
- Insulin resistance
- High uric acid

Return your analysis in the following JSON format:
{
  "detected_conditions": ["condition1", "condition2", ...],
  "risk_level": "high" or "normal",
  "risk_label": "High Risk" or "Normal",
  "risk_summary": "A brief 2-3 sentence summary of the findings"
}

If 2 or more risk factors are detected, set risk_level to "high". Otherwise, set it to "normal".
Be precise and only include conditions that are explicitly mentioned or clearly indicated in the report.''';

      final response = await http.post(
        Uri.parse('https://api.anthropic.com/v1/messages'),
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': apiKey,
          'anthropic-version': '2023-06-01',
        },
        body: jsonEncode({
          'model': 'claude-sonnet-4-20250514',
          'max_tokens': 1024,
          'system': systemPrompt,
          'messages': [
            {
              'role': 'user',
              'content': 'Analyze this medical report:\n\n$extractedText',
            }
          ],
        }),
      );

      if (response.statusCode != 200) {
        throw Exception(
            'Claude API error: ${response.statusCode} - ${response.body}');
      }

      final data = jsonDecode(response.body);
      final content = data['content'][0]['text'] as String;

      // Extract JSON from response (Claude might wrap it in markdown)
      final jsonMatch = RegExp(r'\{[\s\S]*\}').firstMatch(content);
      if (jsonMatch == null) {
        throw Exception('Failed to parse Claude response');
      }

      final result = jsonDecode(jsonMatch.group(0)!) as Map<String, dynamic>;
      return result;
    } catch (e) {
      throw Exception('Failed to analyze with Claude: $e');
    }
  }

  /// Step 4: Save result to medical_reports table
  /// Also update profiles.last_medical_report_at and profiles.medical_risk_summary
  static Future<void> saveReport({
    required String userId,
    required String fileName,
    required String fileUrl,
    required String filePath,
    required String extractedText,
    required Map<String, dynamic> result,
  }) async {
    try {
      // Save to medical_reports table
      await _client.from(AppConstants.tableMedicalReports).insert({
        'user_id': userId,
        'file_name': fileName,
        'file_path': filePath,
        'file_url': fileUrl,
        'extracted_text': extractedText,
        'detected_conditions': result['detected_conditions'],
        'risk_level': result['risk_level'],
        'risk_label': result['risk_label'],
        'risk_summary': result['risk_summary'],
        'analyzed_at': DateTime.now().toIso8601String(),
      });

      // Update profiles table
      await _client.from(AppConstants.tableProfiles).update({
        'last_medical_report_at': DateTime.now().toIso8601String(),
        'medical_risk_summary': result['risk_summary'],
      }).eq('id', userId);
    } catch (e) {
      throw Exception('Failed to save report: $e');
    }
  }

  /// Step 5: Fetch history ordered by analyzed_at DESC
  static Future<List<Map<String, dynamic>>> fetchHistory(String userId) async {
    try {
      final response = await _client
          .from(AppConstants.tableMedicalReports)
          .select()
          .eq('user_id', userId)
          .order('analyzed_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Failed to fetch history: $e');
    }
  }
}
