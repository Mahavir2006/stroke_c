// Features Section — Coral-violet 3D tilt feature cards
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/theme.dart';
import '../../../app/landing_theme.dart';

class FeaturesSection extends StatelessWidget {
  const FeaturesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final w = MediaQuery.of(context).size.width;

    // Coral-violet spectrum across 6 features
    final features = [
      _Feat(Icons.camera_alt_outlined, context.l10n.landing_feat1Title,
          context.l10n.landing_feat1Desc, context.l10n.landing_feat1Tag,
          LT.coral, LT.coralLight),
      _Feat(Icons.mic_none_outlined, context.l10n.landing_feat2Title,
          context.l10n.landing_feat2Desc, context.l10n.landing_feat2Tag,
          const Color(0xFFD63B6E), const Color(0xFFE8608A)),
      _Feat(Icons.show_chart, context.l10n.landing_feat3Title,
          context.l10n.landing_feat3Desc, context.l10n.landing_feat3Tag,
          LT.midBlend, const Color(0xFFC44090)),
      _Feat(Icons.access_time, context.l10n.landing_feat4Title,
          context.l10n.landing_feat4Desc, context.l10n.landing_feat4Tag,
          const Color(0xFF9B35D4), const Color(0xFFB060E8)),
      _Feat(Icons.lock_outline, context.l10n.landing_feat5Title,
          context.l10n.landing_feat5Desc, context.l10n.landing_feat5Tag,
          LT.violet, LT.violetLight),
      _Feat(Icons.shield_outlined, context.l10n.landing_feat6Title,
          context.l10n.landing_feat6Desc, context.l10n.landing_feat6Tag,
          LT.violetDark, LT.violet),
    ];

    return Container(
      decoration: BoxDecoration(
        gradient: isDark
            ? const LinearGradient(
                begin: Alignment.topCenter, end: Alignment.bottomCenter,
                colors: [Color(0xFF1A0A10), Color(0xFF0D0520)])
            : const LinearGradient(
                begin: Alignment.topCenter, end: Alignment.bottomCenter,
                colors: [LT.bgWarm, LT.bgCool]),
      ),
      padding: const EdgeInsets.symmetric(vertical: 96, horizontal: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1160),
          child: Column(children: [
            _SectionTag(context.l10n.landing_featuresTag),
            const SizedBox(height: 16),
            _GradientHeading(context.l10n.landing_featuresTitle),
            const SizedBox(height: 16),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Text(
                context.l10n.landing_featuresSubtitle,
                style: GoogleFonts.inter(
                  fontSize: 17,
                  color: isDark ? Colors.white.withValues(alpha: 0.6) : LT.textSecondary,
                  height: 1.75,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 64),
            Wrap(
              spacing: 20, runSpacing: 20,
              alignment: WrapAlignment.center,
              children: features.map((f) => SizedBox(
                width: w > 900 ? (w - 48 - 40) / 3 : w > 600 ? (w - 48 - 20) / 2 : w - 48,
                child: _FeatureCard(feat: f, isDark: isDark),
              )).toList(),
            ),
          ]),
        ),
      ),
    );
  }
}

class _Feat {
  final IconData icon;
  final String title, desc, tag;
  final Color color, colorLight;
  const _Feat(this.icon, this.title, this.desc, this.tag, this.color, this.colorLight);
}

class _FeatureCard extends StatefulWidget {
  final _Feat feat;
  final bool isDark;
  const _FeatureCard({required this.feat, required this.isDark});
  @override
  State<_FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<_FeatureCard> with SingleTickerProviderStateMixin {
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

  void _onHover(PointerEvent e, BoxConstraints c) {
    final x = (e.localPosition.dx / c.maxWidth - 0.5) * 2;
    final y = (e.localPosition.dy / c.maxHeight - 0.5) * 2;
    setState(() => _tilt = Offset(x * 7, y * 7));
  }

  @override
  Widget build(BuildContext context) {
    final f = widget.feat;
    final isDark = widget.isDark;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() { _hovered = false; _tilt = Offset.zero; }),
      child: LayoutBuilder(
        builder: (context, constraints) => Listener(
          onPointerMove: (e) => _hovered ? _onHover(e, constraints) : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 280),
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateX(-_tilt.dy * pi / 180)
              ..rotateY(_tilt.dx * pi / 180)
              ..translate(0.0, _hovered ? -6.0 : 0.0),
            transformAlignment: Alignment.center,
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1A0F2E) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _hovered
                    ? f.color.withValues(alpha: 0.45)
                    : f.color.withValues(alpha: isDark ? 0.12 : 0.08),
                width: _hovered ? 1.5 : 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: f.color.withValues(alpha: _hovered ? 0.22 : 0.05),
                  blurRadius: _hovered ? 48 : 16,
                  offset: Offset(0, _hovered ? 14 : 2),
                ),
              ],
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 52, height: 52,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    f.color.withValues(alpha: 0.18),
                    f.colorLight.withValues(alpha: 0.08),
                  ]),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: _hovered ? [
                    BoxShadow(color: f.color.withValues(alpha: 0.3), blurRadius: 16),
                  ] : [],
                ),
                child: Icon(f.icon, color: f.color, size: 26),
              ),
              const SizedBox(height: 14),
              ShaderMask(
                shaderCallback: (b) => LinearGradient(
                  colors: [f.color, f.colorLight],
                ).createShader(b),
                child: Text(f.tag, style: GoogleFonts.inter(
                  fontSize: 11, fontWeight: FontWeight.w700,
                  letterSpacing: 0.9, color: Colors.white,
                )),
              ),
              const SizedBox(height: 8),
              Text(f.title, style: GoogleFonts.outfit(
                fontSize: 16, fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : LT.textPrimary,
              )),
              const SizedBox(height: 8),
              Text(f.desc, style: GoogleFonts.inter(
                fontSize: 14,
                color: isDark ? Colors.white.withValues(alpha: 0.55) : LT.textSecondary,
                height: 1.65,
              )),
              const SizedBox(height: 14),
              LayoutBuilder(builder: (context, constraints) => AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                height: 3,
                width: _hovered ? constraints.maxWidth : 0,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [f.color, f.colorLight]),
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

// ── Shared section widgets ─────────────────────────────────────────────────
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
