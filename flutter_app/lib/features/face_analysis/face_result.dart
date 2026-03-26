// Stroke Mitra - Face Analysis Result Models
//
/// Maps the JSON responses from the face symmetry CV engine
/// at /analyze for both baseline and analysis modes.

class FaceBaselineResult {
  final String fingerprintData;
  final Map<String, dynamic> raw;

  const FaceBaselineResult({
    required this.fingerprintData,
    required this.raw,
  });

  factory FaceBaselineResult.fromJson(Map<String, dynamic> json) {
    final fingerprint = json['fingerprint_data'];
    return FaceBaselineResult(
      fingerprintData:
          fingerprint is String ? fingerprint : fingerprint.toString(),
      raw: json,
    );
  }
}

class FaceAnalysisResult {
  final String verdict; // e.g. "Normal", "Problem", "Asymmetry Detected"
  final Map<String, dynamic> raw;

  const FaceAnalysisResult({
    required this.verdict,
    required this.raw,
  });

  factory FaceAnalysisResult.fromJson(Map<String, dynamic> json) {
    // Try common field names for the verdict
    final verdict = json['verdict'] ??
        json['result'] ??
        json['status'] ??
        json['symmetry_status'] ??
        'Unknown';

    return FaceAnalysisResult(
      verdict: verdict is String ? verdict : verdict.toString(),
      raw: json,
    );
  }

  bool get isNormal {
    final v = verdict.toLowerCase();
    return v.contains('normal') ||
        v.contains('fine') ||
        v.contains('symmetric') ||
        v.contains('no asymmetry');
  }

  Map<String, dynamic> toJson() => raw;
}
