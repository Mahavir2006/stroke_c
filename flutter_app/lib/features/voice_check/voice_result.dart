// Stroke Mitra - Voice Analysis Result Model
//
/// Maps the JSON response from the speech analysis API
/// at /v1/speech/analyse into typed Dart objects.

class AcousticSummary {
  final double speakingRate;
  final double pitchMeanHz;
  final double pitchVariabilityHz;
  final double pauseRatio;
  final double voicingRatio;

  const AcousticSummary({
    required this.speakingRate,
    required this.pitchMeanHz,
    required this.pitchVariabilityHz,
    required this.pauseRatio,
    required this.voicingRatio,
  });

  factory AcousticSummary.fromJson(Map<String, dynamic> json) =>
      AcousticSummary(
        speakingRate:
            (json['speaking_rate_syllables_per_sec'] as num).toDouble(),
        pitchMeanHz: (json['pitch_mean_hz'] as num).toDouble(),
        pitchVariabilityHz: (json['pitch_variability_hz'] as num).toDouble(),
        pauseRatio: (json['pause_ratio'] as num).toDouble(),
        voicingRatio: (json['voicing_ratio'] as num).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'speaking_rate_syllables_per_sec': speakingRate,
        'pitch_mean_hz': pitchMeanHz,
        'pitch_variability_hz': pitchVariabilityHz,
        'pause_ratio': pauseRatio,
        'voicing_ratio': voicingRatio,
      };
}

class VoiceResult {
  final String requestId;
  final double slurringScore; // 0-100 (higher = more slurring)
  final String severity; // "none" | "mild" | "moderate" | "severe"
  final double riskScore; // 0-100
  final String riskTier; // "low" | "moderate" | "high" | "critical"
  final double confidence; // 0-1
  final bool emergencyAlert;
  final String modelVersion;
  final int processingTimeMs;
  final AcousticSummary acousticSummary;

  const VoiceResult({
    required this.requestId,
    required this.slurringScore,
    required this.severity,
    required this.riskScore,
    required this.riskTier,
    required this.confidence,
    required this.emergencyAlert,
    required this.modelVersion,
    required this.processingTimeMs,
    required this.acousticSummary,
  });

  factory VoiceResult.fromJson(Map<String, dynamic> json) => VoiceResult(
        requestId: json['request_id'] as String,
        slurringScore: (json['slurring_score'] as num).toDouble(),
        severity: json['severity'] as String,
        riskScore: (json['risk_score'] as num).toDouble(),
        riskTier: json['risk_tier'] as String,
        confidence: (json['confidence'] as num).toDouble(),
        emergencyAlert: json['emergency_alert'] as bool,
        modelVersion: json['model_version'] as String,
        processingTimeMs: (json['processing_time_ms'] as num).toInt(),
        acousticSummary: AcousticSummary.fromJson(
          json['acoustic_summary'] as Map<String, dynamic>,
        ),
      );

  Map<String, dynamic> toJson() => {
        'request_id': requestId,
        'slurring_score': slurringScore,
        'severity': severity,
        'risk_score': riskScore,
        'risk_tier': riskTier,
        'confidence': confidence,
        'emergency_alert': emergencyAlert,
        'model_version': modelVersion,
        'processing_time_ms': processingTimeMs,
        'acoustic_summary': acousticSummary.toJson(),
      };
}
