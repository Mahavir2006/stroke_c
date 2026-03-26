// Gradient-accented card with optional gradient border or left stripe.
// Used throughout the app for test cards, result sections, etc.

import 'package:flutter/material.dart';
import '../../app/theme.dart';

class GradientCard extends StatelessWidget {
  final Widget child;
  final Gradient? gradient;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final bool leftStripe;
  final VoidCallback? onTap;

  const GradientCard({
    super.key,
    required this.child,
    this.gradient,
    this.padding = const EdgeInsets.all(AppTheme.spaceLG),
    this.borderRadius = AppTheme.radiusLG,
    this.leftStripe = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;

    Widget card = Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: colors.cardBorder.withValues(alpha: 0.4)),
        boxShadow: AppTheme.shadowSM,
      ),
      child: leftStripe && gradient != null
          ? Row(
              children: [
                Container(
                  width: 4,
                  decoration: BoxDecoration(
                    gradient: gradient,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(borderRadius),
                      bottomLeft: Radius.circular(borderRadius),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(padding: padding, child: child),
                ),
              ],
            )
          : Padding(padding: padding, child: child),
    );

    if (onTap != null) {
      card = GestureDetector(
        onTap: onTap,
        child: card,
      );
    }

    return card;
  }
}

/// A card with a gradient icon circle — used for dashboard test cards.
class GradientIconCard extends StatefulWidget {
  final IconData icon;
  final Gradient gradient;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const GradientIconCard({
    super.key,
    required this.icon,
    required this.gradient,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  State<GradientIconCard> createState() => _GradientIconCardState();
}

class _GradientIconCardState extends State<GradientIconCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: Container(
          padding: const EdgeInsets.all(AppTheme.spaceLG),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(AppTheme.radiusLG),
            border: Border.all(
              color: _pressed
                  ? theme.colorScheme.primary.withValues(alpha: 0.3)
                  : colors.cardBorder.withValues(alpha: 0.4),
            ),
            boxShadow: _pressed ? AppTheme.shadowMD : AppTheme.shadowSM,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gradient icon circle
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: widget.gradient,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: (widget.gradient as LinearGradient)
                          .colors
                          .first
                          .withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Icon(widget.icon, color: Colors.white, size: 24),
              ),
              const SizedBox(height: AppTheme.spaceMD),
              Text(
                widget.title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
