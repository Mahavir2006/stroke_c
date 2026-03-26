/// Medical Report History Tile
///
/// Shows date, file name, risk badge, and expandable detected conditions list.

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../app/theme.dart';
import 'status_chip.dart';

class MedicalReportHistoryTile extends StatelessWidget {
  final Map<String, dynamic> report;

  const MedicalReportHistoryTile({
    super.key,
    required this.report,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final analyzedAt = DateTime.parse(report['analyzed_at'] as String);
    final formattedDate = DateFormat('MMMM dd, yyyy').format(analyzedAt);
    final fileName = report['file_name'] as String;
    final riskLevel = report['risk_level'] as String;
    final riskLabel = report['risk_label'] as String;
    final detectedConditions =
        List<String>.from(report['detected_conditions'] ?? []);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusMD),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Theme(
        data: theme.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          leading: Icon(
            Icons.description_outlined,
            color: theme.colorScheme.primary,
            size: 24,
          ),
          title: Text(
            fileName,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              formattedDate,
              style: TextStyle(
                fontSize: 12,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ),
          trailing: riskLevel == 'high'
              ? StatusChip.danger(riskLabel)
              : StatusChip.success(riskLabel),
          children: [
            if (detectedConditions.isNotEmpty) ...[
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Detected Conditions:',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: detectedConditions
                    .map((condition) => StatusChip(
                          label: condition,
                          color: theme.colorScheme.primary,
                          showDot: false,
                        ))
                    .toList(),
              ),
            ] else ...[
              Text(
                'No risk factors detected',
                style: TextStyle(
                  fontSize: 12,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
