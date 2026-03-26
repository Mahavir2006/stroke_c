/// Medical Report Provider
///
/// State management for medical report analysis workflow.
/// States: idle → picking → uploading → extracting → analyzing → success → error

import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'medical_report_service.dart';
import '../auth/providers/auth_provider.dart';

enum MedicalReportState {
  idle,
  picking,
  uploading,
  extracting,
  analyzing,
  success,
  error,
}

class MedicalReportData {
  final MedicalReportState state;
  final String statusMessage;
  final Map<String, dynamic>? analysisResult;
  final List<Map<String, dynamic>> history;
  final String? selectedFileName;
  final String? errorMessage;

  MedicalReportData({
    required this.state,
    required this.statusMessage,
    this.analysisResult,
    required this.history,
    this.selectedFileName,
    this.errorMessage,
  });

  MedicalReportData copyWith({
    MedicalReportState? state,
    String? statusMessage,
    Map<String, dynamic>? analysisResult,
    List<Map<String, dynamic>>? history,
    String? selectedFileName,
    String? errorMessage,
  }) {
    return MedicalReportData(
      state: state ?? this.state,
      statusMessage: statusMessage ?? this.statusMessage,
      analysisResult: analysisResult ?? this.analysisResult,
      history: history ?? this.history,
      selectedFileName: selectedFileName ?? this.selectedFileName,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class MedicalReportNotifier extends StateNotifier<MedicalReportData> {
  final String userId;

  MedicalReportNotifier(this.userId)
      : super(MedicalReportData(
          state: MedicalReportState.idle,
          statusMessage: 'Ready to analyze',
          history: [],
        )) {
    loadHistory();
  }

  Future<void> loadHistory() async {
    try {
      final history = await MedicalReportService.fetchHistory(userId);
      state = state.copyWith(history: history);
    } catch (e) {
      // Silent fail for history load
    }
  }

  void setSelectedFile(String fileName) {
    state = state.copyWith(
      selectedFileName: fileName,
      state: MedicalReportState.idle,
      statusMessage: 'Ready to analyze',
    );
  }

  Future<void> analyzeReport(Uint8List fileBytes, String fileName) async {
    try {
      // Step 1: Uploading
      state = state.copyWith(
        state: MedicalReportState.uploading,
        statusMessage: 'Uploading PDF...',
      );

      final uploadResult = await MedicalReportService.uploadPdf(
        bytes: fileBytes,
        fileName: fileName,
        userId: userId,
      );

      // Step 2: Extracting
      state = state.copyWith(
        state: MedicalReportState.extracting,
        statusMessage: 'Extracting text from PDF...',
      );

      final extractedText =
          await MedicalReportService.extractTextFromPdf(fileBytes);

      if (extractedText.isEmpty) {
        throw Exception('No text found in PDF');
      }

      // Step 3: Analyzing
      state = state.copyWith(
        state: MedicalReportState.analyzing,
        statusMessage: 'Analyzing with AI...',
      );

      final result =
          await MedicalReportService.analyzeWithClaude(extractedText);

      // Step 4: Saving
      state = state.copyWith(
        statusMessage: 'Saving results...',
      );

      await MedicalReportService.saveReport(
        userId: userId,
        fileName: fileName,
        fileUrl: uploadResult.url,
        filePath: uploadResult.path,
        extractedText: extractedText,
        result: result,
      );

      // Step 5: Success
      state = state.copyWith(
        state: MedicalReportState.success,
        statusMessage: 'Analysis complete',
        analysisResult: result,
      );

      // Reload history
      await loadHistory();
    } catch (e) {
      state = state.copyWith(
        state: MedicalReportState.error,
        statusMessage: 'Analysis failed',
        errorMessage: e.toString(),
      );
    }
  }

  void reset() {
    state = MedicalReportData(
      state: MedicalReportState.idle,
      statusMessage: 'Ready to analyze',
      history: state.history,
    );
  }
}

final medicalReportProvider =
    StateNotifierProvider<MedicalReportNotifier, MedicalReportData>((ref) {
  final user = ref.watch(currentUserProvider);
  final userId = user?.id ?? '';
  return MedicalReportNotifier(userId);
});
