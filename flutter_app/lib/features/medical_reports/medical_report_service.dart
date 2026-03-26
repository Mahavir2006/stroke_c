import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../../core/supabase_client.dart';
import 'medical_report_model.dart';

class _AnalysisResult {
  final String riskLevel;
  final String riskLabel;
  final String riskSummary;
  final List<String> detectedConditions;
  const _AnalysisResult({
    required this.riskLevel,
    required this.riskLabel,
    required this.riskSummary,
    required this.detectedConditions,
  });
}

class MedicalReportService {
  final _client = SupabaseClientManager.client;
  static const _bucket = 'medical-pdfs';
  static const _table = 'medical_reports';

  // ─── Keyword lists ────────────────────────────────────────────────────────

  static const _highRiskKeywords = [
    'high cholesterol',
    'hypercholesterolemia',
    'elevated ldl',
    'low hdl',
    'high blood sugar',
    'hyperglycemia',
    'type 2 diabetes',
    'diabetes mellitus',
    'hypertension',
    'high blood pressure',
    'elevated blood pressure',
    'atrial fibrillation',
    'afib',
    'irregular heartbeat',
    'obesity',
    'morbid obesity',
    'smoker',
    'smoking history',
    'current smoker',
    'blood clot',
    'thrombosis',
    'deep vein thrombosis',
    'carotid stenosis',
    'carotid artery disease',
    'coronary artery disease',
    'heart disease',
    'heart failure',
    'high triglycerides',
    'dyslipidemia',
  ];

  static const _moderateRiskKeywords = [
    'borderline cholesterol',
    'pre-diabetes',
    'prediabetes',
    'impaired fasting',
    'overweight',
    'elevated bmi',
    'family history of stroke',
    'family history of heart disease',
    'mild hypertension',
    'prehypertension',
    'former smoker',
    'ex-smoker',
    'elevated triglycerides',
    'borderline ldl',
  ];

  // ─── Upload & Analyze ─────────────────────────────────────────────────────

  Future<MedicalReportModel> uploadAndAnalyze({
    required String fileName,
    required Uint8List fileBytes,
  }) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception('Not authenticated');

    // 1. Upload to Supabase Storage
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final safeName = fileName.replaceAll(RegExp(r'[^a-zA-Z0-9._-]'), '_');
    final storagePath = '$userId/medical_reports/${timestamp}_$safeName';

    await _client.storage.from(_bucket).uploadBinary(
          storagePath,
          fileBytes,
          fileOptions: const FileOptions(contentType: 'application/pdf'),
        );

    // Private bucket — store path only, generate signed URLs on demand
    const fileUrl = null;

    // 2. Extract text from PDF
    final extractedText = _extractTextFromPdf(fileBytes);
    final pageCount = _getPageCount(fileBytes);

    // 3. Analyze text
    final analysis = _analyzeReport(extractedText);

    // 4. Save to medical_reports table
    final now = DateTime.now().toUtc();
    final inserted = await _client
        .from(_table)
        .insert({
          'user_id': userId,
          'file_name': fileName,
          'file_path': storagePath,
          'file_url': fileUrl,
          'extracted_text': extractedText,
          'detected_conditions': analysis.detectedConditions,
          'risk_level': analysis.riskLevel,
          'risk_label': analysis.riskLabel,
          'risk_summary': analysis.riskSummary,
          'metadata': {'page_count': pageCount},
          'analyzed_at': now.toIso8601String(),
        })
        .select()
        .single();

    // 5. Update profiles table
    final totalReports = await _client
        .from(_table)
        .select('id')
        .eq('user_id', userId)
        .count(CountOption.exact);

    await _client.from('profiles').update({
      'last_medical_report_at': now.toIso8601String(),
      'medical_risk_summary': {
        'last_risk_level': analysis.riskLevel,
        'total_reports': totalReports.count,
      },
    }).eq('id', userId);

    return MedicalReportModel.fromJson(inserted);
  }

  // ─── Signed URL (private bucket) ─────────────────────────────────────────

  /// Generates a fresh signed URL valid for 1 hour.
  Future<String> getSignedUrl(String filePath) async {
    return _client.storage
        .from(_bucket)
        .createSignedUrl(filePath, 3600); // 1 hour
  }

  // ─── Fetch history ────────────────────────────────────────────────────────

  Future<List<MedicalReportModel>> fetchHistory() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return [];

    final rows = await _client
        .from(_table)
        .select()
        .eq('user_id', userId)
        .order('analyzed_at', ascending: false);

    return (rows as List).map((r) => MedicalReportModel.fromJson(r)).toList();
  }

  // ─── PDF text extraction ──────────────────────────────────────────────────

  String _extractTextFromPdf(Uint8List bytes) {
    try {
      final doc = PdfDocument(inputBytes: bytes);
      final extractor = PdfTextExtractor(doc);
      final buffer = StringBuffer();
      for (int i = 0; i < doc.pages.count; i++) {
        buffer.write(extractor.extractText(startPageIndex: i, endPageIndex: i));
        buffer.write(' ');
      }
      doc.dispose();
      return buffer.toString();
    } catch (_) {
      return '';
    }
  }

  int _getPageCount(Uint8List bytes) {
    try {
      final doc = PdfDocument(inputBytes: bytes);
      final count = doc.pages.count;
      doc.dispose();
      return count;
    } catch (_) {
      return 0;
    }
  }

  // ─── Keyword analysis ─────────────────────────────────────────────────────

  _AnalysisResult _analyzeReport(String text) {
    final lower = text.toLowerCase();

    final highMatches =
        _highRiskKeywords.where((kw) => lower.contains(kw)).toList();
    final moderateMatches =
        _moderateRiskKeywords.where((kw) => lower.contains(kw)).toList();

    final String riskLevel;
    final String riskLabel;
    final String riskSummary;
    final List<String> detected;

    if (highMatches.isNotEmpty) {
      riskLevel = 'high_risk';
      riskLabel = 'High Risk of Stroke';
      detected = highMatches;
      riskSummary =
          'Report indicates ${highMatches.length} high-risk condition${highMatches.length > 1 ? 's' : ''}: ${_joinConditions(highMatches)}.';
    } else if (moderateMatches.isNotEmpty) {
      riskLevel = 'moderate_risk';
      riskLabel = 'Moderate Risk of Stroke';
      detected = moderateMatches;
      riskSummary =
          'Report shows ${moderateMatches.length} moderate-risk indicator${moderateMatches.length > 1 ? 's' : ''}: ${_joinConditions(moderateMatches)}.';
    } else {
      riskLevel = 'normal';
      riskLabel = 'Normal — No Major Risk Factors Detected';
      detected = [];
      riskSummary =
          'No significant stroke risk factors detected in this report.';
    }

    return _AnalysisResult(
      riskLevel: riskLevel,
      riskLabel: riskLabel,
      riskSummary: riskSummary,
      detectedConditions: detected,
    );
  }

  String _joinConditions(List<String> conditions) {
    if (conditions.length <= 3) return conditions.join(', ');
    return '${conditions.take(3).join(', ')} and ${conditions.length - 3} more';
  }
}
