import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'medical_report_model.dart';
import 'medical_report_service.dart';

class MedicalReportNotifier extends ChangeNotifier {
  final MedicalReportService _service;

  MedicalReportNotifier(this._service);

  bool isLoading = false;
  bool isUploading = false;
  MedicalReportModel? currentReport;
  List<MedicalReportModel> history = [];
  String? errorMessage;

  Future<void> fetchHistory() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      history = await _service.fetchHistory();
      if (history.isNotEmpty && currentReport == null) {
        currentReport = history.first;
      }
    } catch (e) {
      errorMessage = 'Failed to load reports: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> uploadAndAnalyze({
    required String fileName,
    required Uint8List fileBytes,
  }) async {
    isUploading = true;
    errorMessage = null;
    notifyListeners();
    try {
      final result = await _service.uploadAndAnalyze(
        fileName: fileName,
        fileBytes: fileBytes,
      );
      currentReport = result;
      history = [result, ...history];
    } catch (e) {
      errorMessage = 'Upload failed: $e';
    } finally {
      isUploading = false;
      notifyListeners();
    }
  }

  void selectReport(MedicalReportModel report) {
    currentReport = report;
    notifyListeners();
  }

  void clearCurrentReport() {
    currentReport = null;
    notifyListeners();
  }
}

final medicalReportServiceProvider = Provider<MedicalReportService>(
  (_) => MedicalReportService(),
);

final medicalReportProvider = ChangeNotifierProvider<MedicalReportNotifier>(
  (ref) => MedicalReportNotifier(ref.read(medicalReportServiceProvider)),
);
