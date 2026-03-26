class MedicalReportModel {
  final String id;
  final String userId;
  final String fileName;
  final String filePath;
  final String? fileUrl;
  final String? extractedText;
  final List<String> detectedConditions;
  final String riskLevel; // 'normal' | 'moderate_risk' | 'high_risk'
  final String riskLabel;
  final String? riskSummary;
  final Map<String, dynamic> metadata;
  final DateTime? analyzedAt;
  final DateTime createdAt;

  const MedicalReportModel({
    required this.id,
    required this.userId,
    required this.fileName,
    required this.filePath,
    this.fileUrl,
    this.extractedText,
    required this.detectedConditions,
    required this.riskLevel,
    required this.riskLabel,
    this.riskSummary,
    required this.metadata,
    this.analyzedAt,
    required this.createdAt,
  });

  factory MedicalReportModel.fromJson(Map<String, dynamic> json) {
    final conditions = json['detected_conditions'];
    return MedicalReportModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      fileName: json['file_name'] as String,
      filePath: json['file_path'] as String,
      fileUrl: json['file_url'] as String?,
      extractedText: json['extracted_text'] as String?,
      detectedConditions: conditions is List
          ? List<String>.from(conditions.map((e) => e.toString()))
          : [],
      riskLevel: json['risk_level'] as String? ?? 'normal',
      riskLabel: json['risk_label'] as String? ?? 'Normal',
      riskSummary: json['risk_summary'] as String?,
      metadata: (json['metadata'] as Map<String, dynamic>?) ?? {},
      analyzedAt: json['analyzed_at'] != null
          ? DateTime.parse(json['analyzed_at'] as String)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'file_name': fileName,
        'file_path': filePath,
        'file_url': fileUrl,
        'extracted_text': extractedText,
        'detected_conditions': detectedConditions,
        'risk_level': riskLevel,
        'risk_label': riskLabel,
        'risk_summary': riskSummary,
        'metadata': metadata,
        'analyzed_at': analyzedAt?.toIso8601String(),
        'created_at': createdAt.toIso8601String(),
      };
}
