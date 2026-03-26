// What Is Section — 3D tilt cards, coral-violet theme
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/theme.dart';
import '../../../app/landing_theme.dart';

class WhatIsSection extends StatelessWidget {
  const WhatIsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = context.isDark;
    final w = MediaQuery.of(context).size.width;

    final cards = [
      _CardData(context.l10n.landing_clinicallyInformed, context.l10n.landing_clinicallyDesc,
          Icons.shield_outlined, LT.coral, LT.coralLight),
      _CardData(context.l10n.landing_deviceNative, context.l10n.landing_deviceDesc,
          Icons.desktop_mac_outlined, LT.midBlend, LT.midBlend),
      _CardData(context.l10n.landing_forEveryone, context.l10n.landing_forEveryoneDesc,
          Icons.people_outline, LT.violet, LT.violetLight),
    ];

    return Container(
      decoration: BoxDecoration(
        gradient: isDark
            ? const LinearGradient(
                begin: Alignment.topCenter, end: Alignment.bottomCenter,
                colors: [Color(0xFF0F0A1A), Color(0xFF1A0A10)])
            : const LinearGradient(
                begin: Alignment.topCenter, end: Alignment.bottomCenter,
                colors: [LT.bgWarm, LT.bgSection]),
      ),
      padding: const EdgeInsets.symmetric(vertical: 96, horizontal: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1160),
          child: Column(children: [
            _SectionTag(context.l10n.landing_aboutTag),
            const SizedBox(height: 16),
            _GradientHeading(context.l10n.landing_whatIsTitle),
            const SizedBox(height: 16),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Text(
                context.l10n.landing_whatIsSubtitle,
                style: GoogleFonts.inter(
                  fontSize: 17,
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.6)
                      : LT.textSecondary,
                  height: 1.75,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 64),
            Wrap(
              spacing: 24, runSpacing: 24,
              alignment: WrapAlignment.center,
              children: cards.map((c) => SizedBox(
                width: w > 900 ? (w - 48 - 48) / 3 : w > 600 ? (w - 48 - 24) / 2 : w - 48,
                child: _Tilt3DCard(data: c, isDark: isDark, theme: theme),
              )).toList(),
            ),
            const SizedBox(height: 40),
            // Disclaimer banner
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  LT.coral.withValues(alpha: isDark ? 0.12 : 0.07),
                  LT.violet.withValues(alpha: isDark ? 0.12 : 0.07),
                ]),
                border: Border.all(color: LT.coral.withValues(alpha: 0.25)),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                ShaderMask(
                  shaderCallback: (b) => const LinearGradient(
                    colors: [LT.coralLight, LT.violetLight],
                  ).createShader(b),
                  child: const Icon(Icons.info_outline, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text.rich(TextSpan(children: [
                    TextSpan(
                      text: context.l10n.landing_disclaimerPrefix,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w700,
                        foreground: Paint()
                          ..shader = const LinearGradient(
                            colors: [LT.coral, LT.violet],
                          ).createShader(const Rect.fromLTWH(0, 0, 200, 20)),
                        fontSize: 14,
                      ),
                    ),
                    TextSpan(
                      text: context.l10n.landing_disclaimerText,
                      style: GoogleFonts.inter(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.65)
                            : LT.textSecondary,
                        fontSize: 14,
                        height: 1.6,
                      ),
                    ),
                  ])),
                ),
              ]),
            ),
          ]),
        ),
      ),
    );
  }
}

// ── 3D Tilt Card ──────────────────────────────────────────────────────────
class _Tilt3DCard extends StatefulWidget {
  final _CardData data;
  final bool isDark;
  final ThemeData theme;
  const _Tilt3DCard({required this.data, required this.isDark, required this.theme});
  @override
  State<_Tilt3DCard> createState() => _Tilt3DCardState();
}

class _Tilt3DCardState extends State<_Tilt3DCard> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  Offset _tilt = Offset.zero;
  bool _hovered = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _onHover(PointerEvent e, BoxConstraints constraints) {
    final x = (e.localPosition.dx / constraints.maxWidth - 0.5) * 2;
    final y = (e.localPosition.dy / constraints.maxHeight - 0.5) * 2;
    setState(() => _tilt = Offset(x * 8, y * 8)); // max 8° tilt
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.data;
    final isDark = widget.isDark;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) {
        setState(() {
          _hovered = false;
          _tilt = Offset.zero;
        });
      },
      child: LayoutBuilder(
        builder: (context, constraints) => Listener(
          onPointerMove: (e) => _hovered ? _onHover(e, constraints) : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001) // perspective
              ..rotateX(-_tilt.dy * pi / 180)
              ..rotateY(_tilt.dx * pi / 180)
              ..translate(0.0, _hovered ? -6.0 : 0.0),
            transformAlignment: Alignment.center,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1A0F2E) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _hovered
                    ? d.accentColor.withValues(alpha: 0.4)
                    : d.accentColor.withValues(alpha: isDark ? 0.12 : 0.08),
                width: _hovered ? 1.5 : 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: d.accentColor.withValues(alpha: _hovered ? 0.22 : 0.06),
                  blurRadius: _hovered ? 48 : 20,
                  offset: Offset(0, _hovered ? 16 : 4),
                ),
              ],
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // Icon with gradient glow
              Container(
                width: 56, height: 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      d.accentColor.withValues(alpha: 0.2),
                      d.accentLight.withValues(alpha: 0.08),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: _hovered ? [
                    BoxShadow(color: d.accentColor.withValues(alpha: 0.3), blurRadius: 20),
                  ] : [],
                ),
                child: Icon(d.icon, color: d.accentColor, size: 28),
              ),
              const SizedBox(height: 20),
              Text(d.title, style: GoogleFonts.outfit(
                fontSize: 18, fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : LT.textPrimary,
              )),
              const SizedBox(height: 10),
              Text(d.desc, style: GoogleFonts.inter(
                fontSize: 14,
                color: isDark
                    ? Colors.white.withValues(alpha: 0.55)
                    : LT.textSecondary,
                height: 1.65,
              )),
              const SizedBox(height: 16),
              LayoutBuilder(builder: (context, constraints) => AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                height: 3,
                width: _hovered ? constraints.maxWidth : 0,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [d.accentColor, d.accentLight]),
                  borderRadius: BorderRadius.circular(4),
                ),
              )),
            ]),
          ),
        ),
      ),
    );
  }
}

class _CardData {
  final String title, desc;
  final IconData icon;
  final Color accentColor, accentLight;
  const _CardData(this.title, this.desc, this.icon, this.accentColor, this.accentLight);
}

class _SectionTag extends StatelessWidget {
  final String text;
  const _SectionTag(this.text);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          LT.coral.withValues(alpha: 0.12),
          LT.violet.withValues(alpha: 0.12),
        ]),
        border: Border.all(color: LT.coral.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(100),
      ),
      child: ShaderMask(
        shaderCallback: (b) => const LinearGradient(
          colors: [LT.coral, LT.violet],
        ).createShader(b),
        child: Text(
          text.toUpperCase(),
          style: GoogleFonts.inter(
            fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1.2,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class _GradientHeading extends StatelessWidget {
  final String text;
  const _GradientHeading(this.text);
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return ShaderMask(
      shaderCallback: (b) => const LinearGradient(
        colors: [LT.coral, LT.midBlend, LT.violet],
      ).createShader(b),
      child: Text(
        text,
        style: GoogleFonts.outfit(
          fontSize: w > 600 ? 40 : 30,
          fontWeight: FontWeight.w800,
          color: Colors.white,
          letterSpacing: -1.0,
          height: 1.15,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
