// How It Works Section — Coral-violet timeline with 3D animated step cards
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/theme.dart';
import '../../../app/landing_theme.dart';

class HowItWorksSection extends StatelessWidget {
  const HowItWorksSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final w = MediaQuery.of(context).size.width;
    final isWide = w > 700;

    final steps = [
      _Step('01', context.l10n.landing_step1Title, context.l10n.landing_step1Desc,
          context.l10n.landing_step1Detail1, Icons.camera_alt_outlined, LT.coral, LT.coralLight),
      _Step('02', context.l10n.landing_step2Title, context.l10n.landing_step2Desc,
          context.l10n.landing_step2Detail1, Icons.mic_none_outlined, LT.midBlend, LT.midBlend),
      _Step('03', context.l10n.landing_step3Title, context.l10n.landing_step3Desc,
          context.l10n.landing_step3Detail1, Icons.description_outlined, LT.violet, LT.violetLight),
    ];

    return Container(
      decoration: BoxDecoration(
        gradient: isDark
            ? const LinearGradient(
                begin: Alignment.topCenter, end: Alignment.bottomCenter,
                colors: [Color(0xFF0D0520), Color(0xFF0F0A1A)])
            : const LinearGradient(
                begin: Alignment.topCenter, end: Alignment.bottomCenter,
                colors: [LT.bgSection, LT.bgWarm]),
      ),
      padding: const EdgeInsets.symmetric(vertical: 96, horizontal: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(children: [
            _SectionTag(context.l10n.landing_howItWorksTag),
            const SizedBox(height: 16),
            _GradientHeading(context.l10n.landing_howItWorksTitle),
            const SizedBox(height: 16),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Text(
                context.l10n.landing_howItWorksSubtitle,
                style: GoogleFonts.inter(
                  fontSize: 17,
                  color: isDark ? Colors.white.withValues(alpha: 0.6) : LT.textSecondary,
                  height: 1.75,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 64),

            // Timeline — no IntrinsicHeight, uses Stack for spine line
            ...List.generate(steps.length, (i) {
              final step = steps[i];
              final isLast = i == steps.length - 1;
              final circleSize = isWide ? 52.0 : 44.0;
              final spineWidth = isWide ? 80.0 : 56.0;

              return Padding(
                padding: EdgeInsets.only(bottom: isLast ? 0 : 28),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Spine column: circle + line drawn via Stack
                    SizedBox(
                      width: spineWidth,
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          // Vertical line behind circle (only if not last)
                          if (!isLast)
                            Positioned(
                              top: circleSize,
                              bottom: -28,
                              left: spineWidth / 2 - 1,
                              child: Container(
                                width: 2,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      step.color.withValues(alpha: 0.5),
                                      steps[i + 1].color.withValues(alpha: 0.5),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          // Number circle
                          Container(
                            width: circleSize,
                            height: circleSize,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [step.color, step.colorLight],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: step.color.withValues(alpha: 0.45),
                                  blurRadius: 20,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(step.num, style: GoogleFonts.outfit(
                                fontSize: 15, fontWeight: FontWeight.w900, color: Colors.white,
                              )),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Card
                    Expanded(child: _StepCard(step: step, isDark: isDark)),
                  ],
                ),
              );
            }),
          ]),
        ),
      ),
    );
  }
}

class _Step {
  final String num, title, desc, detail;
  final IconData icon;
  final Color color, colorLight;
  const _Step(this.num, this.title, this.desc, this.detail, this.icon, this.color, this.colorLight);
}

class _StepCard extends StatefulWidget {
  final _Step step;
  final bool isDark;
  const _StepCard({required this.step, required this.isDark});
  @override
  State<_StepCard> createState() => _StepCardState();
}

class _StepCardState extends State<_StepCard> with SingleTickerProviderStateMixin {
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
    setState(() => _tilt = Offset(x * 6, y * 6));
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.step;
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
              ..translate(0.0, _hovered ? -5.0 : 0.0),
            transformAlignment: Alignment.center,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1A0F2E) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _hovered
                    ? s.color.withValues(alpha: 0.45)
                    : s.color.withValues(alpha: isDark ? 0.12 : 0.1),
                width: _hovered ? 1.5 : 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: s.color.withValues(alpha: _hovered ? 0.2 : 0.05),
                  blurRadius: _hovered ? 40 : 12,
                  offset: Offset(0, _hovered ? 12 : 2),
                ),
              ],
            ),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                width: 52, height: 52,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    s.color.withValues(alpha: 0.18),
                    s.colorLight.withValues(alpha: 0.08),
                  ]),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: _hovered ? [
                    BoxShadow(color: s.color.withValues(alpha: 0.25), blurRadius: 16),
                  ] : [],
                ),
                child: Icon(s.icon, size: 26, color: s.color),
              ),
              const SizedBox(width: 16),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(s.title, style: GoogleFonts.outfit(
                  fontSize: 18, fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : LT.textPrimary,
                )),
                const SizedBox(height: 8),
                Text(s.desc, style: GoogleFonts.inter(
                  fontSize: 14,
                  color: isDark ? Colors.white.withValues(alpha: 0.55) : LT.textSecondary,
                  height: 1.65,
                )),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      s.color.withValues(alpha: 0.12),
                      s.colorLight.withValues(alpha: 0.06),
                    ]),
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(color: s.color.withValues(alpha: 0.2)),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(Icons.auto_awesome, size: 12, color: s.color),
                    const SizedBox(width: 6),
                    Text(s.detail, style: GoogleFonts.inter(
                      fontSize: 12, fontWeight: FontWeight.w600, color: s.color,
                    )),
                  ]),
                ),
                const SizedBox(height: 12),
                LayoutBuilder(builder: (context, constraints) => AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  height: 2,
                  width: _hovered ? constraints.maxWidth : 0,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [s.color, s.colorLight]),
                    borderRadius: BorderRadius.circular(4),
                  ),
                )),
              ])),
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
