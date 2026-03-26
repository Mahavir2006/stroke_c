/// Medical Report Screen
///
/// Upload PDF medical reports, analyze with AI, view results and history.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../app/theme.dart';
import '../../shared/widgets/gradient_card.dart';
import '../../shared/widgets/status_chip.dart';
import '../../shared/widgets/medical_report_history_tile.dart';
import 'medical_report_provider.dart';

class MedicalReportScreen extends ConsumerStatefulWidget {
  const MedicalReportScreen({super.key});

  @override
  ConsumerState<MedicalReportScreen> createState() =>
      _MedicalReportScreenState();
}

class _MedicalReportScreenState extends ConsumerState<MedicalReportScreen> {
  PlatformFile? _selectedFile;

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        withData: true,
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          _selectedFile = result.files.first;
        });
        ref
            .read(medicalReportProvider.notifier)
            .setSelectedFile(_selectedFile!.name);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to pick file: $e')),
        );
      }
    }
  }

  Future<void> _analyzeReport() async {
    if (_selectedFile == null || _selectedFile!.bytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a PDF file first')),
      );
      return;
    }

    await ref.read(medicalReportProvider.notifier).analyzeReport(
          _selectedFile!.bytes!,
          _selectedFile!.name,
        );

    final state = ref.read(medicalReportProvider);
    if (state.state == MedicalReportState.error && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.errorMessage ?? 'Analysis failed'),
          backgroundColor: AppTheme.statusError,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;
    final state = ref.watch(medicalReportProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Medical Report Analyzer',
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.w700,
            fontSize: 19,
          ),
        ),
        backgroundColor: theme.scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spaceMD),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Section 1: Upload Card
                GradientCard(
                  gradient: colors.faceGradient,
                  leftStripe: true,
                  child: Column(
                    children: [
                      // Icon
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          gradient: colors.faceGradient,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.health_and_safety,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                      const SizedBox(height: AppTheme.spaceMD),

                      // Title
                      Text(
                        'Analyze Medical Report',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),

                      // Subtitle
                      Text(
                        'Upload a PDF to assess stroke risk',
                        style: TextStyle(
                          fontSize: 14,
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.6),
                        ),
                      ),
                      const SizedBox(height: AppTheme.spaceLG),

                      // Upload area
                      GestureDetector(
                        onTap: state.state == MedicalReportState.idle ||
                                state.state == MedicalReportState.error
                            ? _pickFile
                            : null,
                        child: DottedBorder(
                          color:
                              theme.colorScheme.primary.withValues(alpha: 0.4),
                          strokeWidth: 2,
                          dashPattern: const [8, 4],
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(AppTheme.radiusMD),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(AppTheme.spaceLG),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.upload_file_rounded,
                                  size: 40,
                                  color: theme.colorScheme.primary
                                      .withValues(alpha: 0.6),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _selectedFile != null
                                      ? _selectedFile!.name
                                      : 'Tap to select PDF',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: _selectedFile != null
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                    color: _selectedFile != null
                                        ? theme.colorScheme.primary
                                        : theme.colorScheme.onSurface
                                            .withValues(alpha: 0.5),
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppTheme.spaceMD),

                      // Analyze button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _selectedFile != null &&
                                  (state.state == MedicalReportState.idle ||
                                      state.state == MedicalReportState.error)
                              ? _analyzeReport
                              : null,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(AppTheme.radiusMD),
                            ),
                          ),
                          child: const Text(
                            'Analyze Report',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      // Progress indicator
                      if (state.state != MedicalReportState.idle &&
                          state.state != MedicalReportState.success &&
                          state.state != MedicalReportState.error) ...[
                        const SizedBox(height: AppTheme.spaceMD),
                        LinearProgressIndicator(
                          borderRadius:
                              BorderRadius.circular(AppTheme.radiusSM),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          state.statusMessage,
                          style: TextStyle(
                            fontSize: 13,
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // Section 2: Result Card
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: state.state == MedicalReportState.success &&
                          state.analysisResult != null
                      ? Column(
                          key: const ValueKey('result'),
                          children: [
                            const SizedBox(height: AppTheme.spaceLG),
                            _buildResultCard(
                              theme,
                              colors,
                              state.analysisResult!,
                            ),
                          ],
                        )
                      : const SizedBox.shrink(key: ValueKey('empty')),
                ),

                // Section 3: History
                const SizedBox(height: AppTheme.spaceLG),
                Text(
                  'PREVIOUS REPORTS',
                  style: AppTheme.labelTag.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.35),
                  ),
                ),
                const SizedBox(height: AppTheme.spaceMD),

                if (state.history.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(AppTheme.spaceLG),
                      child: Text(
                        'No previous reports',
                        style: TextStyle(
                          fontSize: 14,
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.4),
                        ),
                      ),
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.history.length,
                    itemBuilder: (context, index) {
                      return MedicalReportHistoryTile(
                        report: state.history[index],
                      );
                    },
                  ),

                const SizedBox(height: AppTheme.spaceLG),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResultCard(
    ThemeData theme,
    AppColors colors,
    Map<String, dynamic> result,
  ) {
    final riskLevel = result['risk_level'] as String;
    final riskLabel = result['risk_label'] as String;
    final riskSummary = result['risk_summary'] as String;
    final detectedConditions =
        List<String>.from(result['detected_conditions'] ?? []);

    final isHighRisk = riskLevel == 'high';
    final cardColor = isHighRisk
        ? AppTheme.statusError.withValues(alpha: 0.08)
        : AppTheme.statusSuccess.withValues(alpha: 0.08);
    final iconColor =
        isHighRisk ? AppTheme.statusError : AppTheme.statusSuccess;
    final icon =
        isHighRisk ? Icons.warning_amber_rounded : Icons.check_circle_outline;

    return GradientCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon and title
          Row(
            children: [
              Icon(icon, color: iconColor, size: 48),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  riskLabel,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: iconColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spaceMD),

          // Detected conditions
          if (detectedConditions.isNotEmpty) ...[
            Text(
              'Detected Conditions:',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: detectedConditions
                  .map((condition) => StatusChip(
                        label: condition,
                        color: iconColor,
                        showDot: false,
                      ))
                  .toList(),
            ),
            const SizedBox(height: AppTheme.spaceMD),
          ],

          // Summary
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(AppTheme.radiusMD),
            ),
            child: Text(
              riskSummary,
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
              ),
            ),
          ),
          const SizedBox(height: AppTheme.spaceMD),

          // Disclaimer
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isHighRisk
                  ? AppTheme.statusError.withValues(alpha: 0.1)
                  : AppTheme.statusSuccess.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppTheme.radiusMD),
              border: Border.all(
                color: iconColor.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  isHighRisk ? Icons.warning_rounded : Icons.info_outline,
                  color: iconColor,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    isHighRisk
                        ? 'Please consult a physician immediately'
                        : 'Continue regular health checkups',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: iconColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
