import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/theme.dart';
import 'medical_report_model.dart';
import 'medical_report_provider.dart';

class MedicalReportScreen extends ConsumerStatefulWidget {
  const MedicalReportScreen({super.key});

  @override
  ConsumerState<MedicalReportScreen> createState() =>
      _MedicalReportScreenState();
}

class _MedicalReportScreenState extends ConsumerState<MedicalReportScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(medicalReportProvider).fetchHistory();
    });
  }

  Future<void> _pickAndUpload() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      withData: true,
    );

    if (result == null || result.files.isEmpty) return;

    final file = result.files.first;
    final Uint8List? bytes = file.bytes;
    final String fileName = file.name;

    if (bytes == null) return;

    if (bytes.lengthInBytes > 10 * 1024 * 1024) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.medicalReport_fileSizeLimit)),
        );
      }
      return;
    }

    await ref.read(medicalReportProvider).uploadAndAnalyze(
          fileName: fileName,
          fileBytes: bytes,
        );

    final notifier = ref.read(medicalReportProvider);
    if (mounted && notifier.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(notifier.errorMessage!)),
      );
    }
  }

  Future<void> _openPdf(BuildContext context, String filePath) async {
    try {
      final signedUrl =
          await ref.read(medicalReportServiceProvider).getSignedUrl(filePath);
      final uri = Uri.parse(signedUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(context.l10n.medicalReport_couldNotOpenPdf)));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(context.l10n.medicalReport_failedPdfLink(e.toString()))));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final notifier = ref.watch(medicalReportProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
        title: Text(context.l10n.medicalReport_title,
            style:
                GoogleFonts.outfit(fontWeight: FontWeight.w700, fontSize: 18)),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
              height: 1,
              color: theme.colorScheme.outline.withValues(alpha: 0.1)),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppTheme.spaceMD),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _UploadSection(
                  isUploading: notifier.isUploading,
                  onUpload: _pickAndUpload,
                ),
                const SizedBox(height: AppTheme.spaceLG),
                if (notifier.isUploading)
                  const _AnalyzingCard()
                else if (notifier.currentReport != null)
                  _ResultCard(
                    report: notifier.currentReport!,
                    onViewPdf: (filePath) => _openPdf(context, filePath),
                  ),
                if (notifier.currentReport != null)
                  const SizedBox(height: AppTheme.spaceLG),
                _HistorySection(
                  isLoading: notifier.isLoading,
                  history: notifier.history,
                  currentId: notifier.currentReport?.id,
                  onSelect: (r) =>
                      ref.read(medicalReportProvider).selectReport(r),
                ),
                const SizedBox(height: AppTheme.spaceLG),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Upload Section ───────────────────────────────────────────────────────────
class _UploadSection extends StatelessWidget {
  final bool isUploading;
  final VoidCallback onUpload;
  const _UploadSection({required this.isUploading, required this.onUpload});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceLG),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusLG),
        border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.15)),
      ),
      child: Column(children: [
        Icon(Icons.upload_file_rounded,
            size: 40, color: theme.colorScheme.primary.withValues(alpha: 0.7)),
        const SizedBox(height: AppTheme.spaceMD),
        Text(context.l10n.medicalReport_uploadTitle,
            style: GoogleFonts.outfit(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurface)),
        const SizedBox(height: 4),
        Text(context.l10n.medicalReport_supportedFormat,
            style: TextStyle(
                fontSize: 12,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.45))),
        const SizedBox(height: AppTheme.spaceLG),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton.icon(
            onPressed: isUploading ? null : onUpload,
            icon: isUploading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white))
                : const Icon(Icons.attach_file_rounded),
            label: Text(isUploading
                ? context.l10n.medicalReport_uploading
                : context.l10n.medicalReport_choosePdf),
          ),
        ),
      ]),
    );
  }
}

// ─── Analyzing Card ───────────────────────────────────────────────────────────
class _AnalyzingCard extends StatelessWidget {
  const _AnalyzingCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceXL),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusLG),
        border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.15)),
      ),
      child: Column(children: [
        CircularProgressIndicator(color: theme.colorScheme.primary),
        const SizedBox(height: AppTheme.spaceMD),
        Text(context.l10n.medicalReport_analyzing,
            style: GoogleFonts.outfit(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface)),
        const SizedBox(height: 4),
        Text(context.l10n.medicalReport_extracting,
            style: TextStyle(
                fontSize: 12,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.45))),
      ]),
    );
  }
}

// ─── Result Card ──────────────────────────────────────────────────────────────
class _ResultCard extends StatelessWidget {
  final MedicalReportModel report;
  final void Function(String filePath) onViewPdf;
  const _ResultCard({required this.report, required this.onViewPdf});

  Color _riskColor(BuildContext context) {
    switch (report.riskLevel) {
      case 'high_risk':
        return AppTheme.statusError;
      case 'moderate_risk':
        return AppTheme.statusWarning;
      default:
        return AppTheme.statusSuccess;
    }
  }

  IconData get _riskIcon {
    switch (report.riskLevel) {
      case 'high_risk':
        return Icons.warning_rounded;
      case 'moderate_risk':
        return Icons.info_rounded;
      default:
        return Icons.check_circle_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _riskColor(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusLG),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1.5),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Container(
          padding: const EdgeInsets.all(AppTheme.spaceMD),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08),
            borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppTheme.radiusLG)),
          ),
          child: Row(children: [
            Icon(_riskIcon, color: color, size: 24),
            const SizedBox(width: 10),
            Expanded(
              child: Text(report.riskLabel,
                  style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: color)),
            ),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.all(AppTheme.spaceMD),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            Row(children: [
              Icon(Icons.picture_as_pdf_rounded,
                  size: 14,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.4)),
              const SizedBox(width: 6),
              Expanded(
                child: Text(report.fileName,
                    style: TextStyle(
                        fontSize: 12,
                        color: theme.colorScheme.onSurface
                            .withValues(alpha: 0.5))),
              ),
              if (report.analyzedAt != null)
                Text(_formatDate(report.analyzedAt!),
                    style: TextStyle(
                        fontSize: 11,
                        color: theme.colorScheme.onSurface
                            .withValues(alpha: 0.4))),
            ]),
            if (report.riskSummary != null) ...[
              const SizedBox(height: AppTheme.spaceMD),
              Text(report.riskSummary!,
                  style: TextStyle(
                      fontSize: 13,
                      color:
                          theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      height: 1.5)),
            ],
            if (report.detectedConditions.isNotEmpty) ...[
              const SizedBox(height: AppTheme.spaceMD),
              Text(context.l10n.medicalReport_detectedConditions,
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface
                          .withValues(alpha: 0.5))),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: report.detectedConditions
                    .map((c) => _ConditionChip(label: c, color: color))
                    .toList(),
              ),
            ],
            if (report.detectedConditions.isEmpty &&
                report.riskLevel == 'normal') ...[
              const SizedBox(height: AppTheme.spaceMD),
              Row(children: [
                const Icon(Icons.check_circle_outline_rounded,
                    size: 16, color: AppTheme.statusSuccess),
                const SizedBox(width: 6),
                Text(context.l10n.medicalReport_noRiskFactors,
                    style: const TextStyle(
                        fontSize: 13, color: AppTheme.statusSuccess)),
              ]),
            ],
            if (report.filePath.isNotEmpty) ...[
              const SizedBox(height: AppTheme.spaceLG),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => onViewPdf(report.filePath),
                  icon: const Icon(Icons.open_in_new_rounded, size: 16),
                  label: Text(context.l10n.medicalReport_viewPdf),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: color,
                    side: BorderSide(color: color.withValues(alpha: 0.4)),
                  ),
                ),
              ),
            ],
          ]),
        ),
      ]),
    );
  }

  String _formatDate(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
  }
}

class _ConditionChip extends StatelessWidget {
  final String label;
  final Color color;
  const _ConditionChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Text(label,
          style: TextStyle(
              fontSize: 11, fontWeight: FontWeight.w500, color: color)),
    );
  }
}

// ─── History Section ──────────────────────────────────────────────────────────
class _HistorySection extends StatelessWidget {
  final bool isLoading;
  final List<MedicalReportModel> history;
  final String? currentId;
  final void Function(MedicalReportModel) onSelect;

  const _HistorySection({
    required this.isLoading,
    required this.history,
    required this.currentId,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(context.l10n.medicalReport_pastReports,
          style: GoogleFonts.outfit(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface)),
      const SizedBox(height: AppTheme.spaceMD),
      if (isLoading)
        const Center(child: CircularProgressIndicator())
      else if (history.isEmpty)
        _EmptyState()
      else
        ...history.map((r) => _HistoryTile(
              report: r,
              isSelected: r.id == currentId,
              onTap: () => onSelect(r),
            )),
    ]);
  }
}

class _HistoryTile extends StatelessWidget {
  final MedicalReportModel report;
  final bool isSelected;
  final VoidCallback onTap;
  const _HistoryTile(
      {required this.report, required this.isSelected, required this.onTap});

  Color _dotColor() {
    switch (report.riskLevel) {
      case 'high_risk':
        return AppTheme.statusError;
      case 'moderate_risk':
        return AppTheme.statusWarning;
      default:
        return AppTheme.statusSuccess;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dot = _dotColor();
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(AppTheme.spaceMD),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withValues(alpha: 0.06)
              : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(AppTheme.radiusMD),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary.withValues(alpha: 0.3)
                : theme.colorScheme.outline.withValues(alpha: 0.12),
          ),
        ),
        child: Row(children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: dot, shape: BoxShape.circle),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              Text(report.fileName,
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
              const SizedBox(height: 2),
              Text(report.riskLabel,
                  style: TextStyle(fontSize: 11, color: dot)),
            ]),
          ),
          const SizedBox(width: 8),
          if (report.analyzedAt != null)
            Text(_formatDate(report.analyzedAt!),
                style: TextStyle(
                    fontSize: 11,
                    color:
                        theme.colorScheme.onSurface.withValues(alpha: 0.4))),
          const SizedBox(width: 4),
          Icon(Icons.chevron_right_rounded,
              size: 18,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.3)),
        ]),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceXL),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusLG),
        border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.12)),
      ),
      child: Column(children: [
        Icon(Icons.folder_open_rounded,
            size: 48,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.2)),
        const SizedBox(height: AppTheme.spaceMD),
        Text(context.l10n.medicalReport_noReports,
            style: GoogleFonts.outfit(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.4))),
        const SizedBox(height: 4),
        Text(context.l10n.medicalReport_uploadPrompt,
            style: TextStyle(
                fontSize: 12,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.3)),
            textAlign: TextAlign.center),
      ]),
    );
  }
}