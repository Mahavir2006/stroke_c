// Colored status chip with dot indicator.
// Used for risk levels, test status, etc.

import 'package:flutter/material.dart';
import '../../app/theme.dart';

class StatusChip extends StatelessWidget {
  final String label;
  final Color color;
  final bool showDot;
  final IconData? icon;

  const StatusChip({
    super.key,
    required this.label,
    required this.color,
    this.showDot = true,
    this.icon,
  });

  factory StatusChip.success(String label) => StatusChip(
        label: label,
        color: AppTheme.statusSuccess,
      );

  factory StatusChip.warning(String label) => StatusChip(
        label: label,
        color: AppTheme.statusWarning,
      );

  factory StatusChip.danger(String label) => StatusChip(
        label: label,
        color: AppTheme.statusError,
      );

  factory StatusChip.info(String label) => StatusChip(
        label: label,
        color: AppTheme.accent,
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showDot) ...[
            Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
          ],
          if (icon != null) ...[
            Icon(icon, color: color, size: 14),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
