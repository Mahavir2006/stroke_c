// Hero Section — Coral-Violet 3D immersive hero
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../app/theme.dart';
import '../../../app/landing_theme.dart';

class HeroSection extends StatefulWidget {
  const HeroSection({super.key});
  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection> with TickerProviderStateMixin {
  late AnimationController _orbCtrl;
  late AnimationController _helixCtrl;
  late AnimationController _blobCtrl;
  late AnimationController _pulseCtrl;
  late AnimationController _mouseCtrl;

  Offset _mousePos = const Offset(0.5, 0.5);
  Offset _targetMouse = const Offset(0.5, 0.5);

  @override
  void initState() {
    super.initState();
    _orbCtrl   = AnimationController(vsync: this, duration: const Duration(seconds: 14))..repeat();
    _helixCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 8))..repeat();
    _blobCtrl  = AnimationController(vsync: this, duration: const Duration(seconds: 10))..repeat();
    _pulseCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat(reverse: true);
    _mouseCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 16))..repeat();
    _mouseCtrl.addListener(_lerpMouse);
  }

  void _lerpMouse() {
    setState(() {
      _mousePos = Offset(
        _mousePos.dx + (_targetMouse.dx - _mousePos.dx) * 0.06,
        _mousePos.dy + (_targetMouse.dy - _mousePos.dy) * 0.06,
      );
    });
  }

  @override
  void dispose() {
    _orbCtrl.dispose();
    _helixCtrl.dispose();
    _blobCtrl.dispose();
    _pulseCtrl.dispose();
    _mouseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final isWide = w > 700;

    return MouseRegion(
      onHover: (e) {
        final box = context.findRenderObject() as RenderBox?;
        if (box == null) return;
        final local = box.globalToLocal(e.position);
        _targetMouse = Offset(local.dx / box.size.width, local.dy / box.size.height);
      },
      child: SizedBox(
        width: double.infinity,
        child: Stack(
          children: [
            // ── Dark base gradient (coral-violet night)
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(gradient: LT.heroGradient),
              ),
            ),

            // ── Animated mesh gradient blobs
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _orbCtrl,
                builder: (_, __) => CustomPaint(
                  painter: _MeshBlobPainter(t: _orbCtrl.value, mouse: _mousePos),
                ),
              ),
            ),

            // ── Morphing organic blob (center-left)
            Positioned(
              left: w * 0.05,
              top: h * 0.1,
              child: AnimatedBuilder(
                animation: _blobCtrl,
                builder: (_, __) => CustomPaint(
                  size: Size(isWide ? 420 : 260, isWide ? 420 : 260),
                  painter: _MorphBlobPainter(t: _blobCtrl.value),
                ),
              ),
            ),

            // ── 3D DNA Helix (right side)
            Positioned(
              right: isWide ? w * 0.04 : -40,
              top: h * 0.08,
              child: AnimatedBuilder(
                animation: _helixCtrl,
                builder: (_, __) => CustomPaint(
                  size: Size(isWide ? 160 : 100, isWide ? 500 : 320),
                  painter: _HelixPainter(t: _helixCtrl.value),
                ),
              ),
            ),

            // ── Floating orbs with mouse parallax
            ..._buildOrbs(w, h),

            // ── Dot grid
            Positioned.fill(
              child: CustomPaint(painter: _DotGridPainter()),
            ),

            // ── Radial pulse glow
            Positioned(
              top: h * 0.1,
              left: w * 0.25,
              child: AnimatedBuilder(
                animation: _pulseCtrl,
                builder: (_, __) => Container(
                  width: w * 0.6,
                  height: w * 0.6,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(colors: [
                      LT.coral.withValues(alpha: 0.06 + _pulseCtrl.value * 0.04),
                      LT.violet.withValues(alpha: 0.04 + _pulseCtrl.value * 0.02),
                      Colors.transparent,
                    ], stops: const [0.0, 0.4, 1.0]),
                  ),
                ),
              ),
            ),

            // ── Main content
            Padding(
              padding: EdgeInsets.fromLTRB(24, isWide ? 150 : 130, 24, 60),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 860),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _AnimatedBadge()
                          .animate()
                          .fadeIn(duration: 600.ms, delay: 200.ms)
                          .slideY(begin: -0.3, end: 0, duration: 600.ms, delay: 200.ms),

                      const SizedBox(height: 28),

                      // Title line 1
                      Text(
                        context.l10n.landing_heroTitle1,
                        style: GoogleFonts.outfit(
                          fontSize: isWide ? 62 : 40,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          height: 1.05,
                          letterSpacing: -2.5,
                        ),
                        textAlign: TextAlign.center,
                      )
                          .animate()
                          .fadeIn(duration: 700.ms, delay: 400.ms)
                          .slideY(begin: 0.25, end: 0, duration: 700.ms, delay: 400.ms),

                      // Title line 2 — gradient shimmer
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [LT.coralLight, LT.midBlend, LT.violetLight],
                        ).createShader(bounds),
                        child: Text(
                          context.l10n.landing_heroTitle2,
                          style: GoogleFonts.outfit(
                            fontSize: isWide ? 62 : 40,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            height: 1.05,
                            letterSpacing: -2.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                          .animate()
                          .fadeIn(duration: 700.ms, delay: 600.ms)
                          .slideY(begin: 0.25, end: 0, duration: 700.ms, delay: 600.ms),

                      const SizedBox(height: 28),

                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 580),
                        child: Text(
                          context.l10n.landing_heroSubtitle,
                          style: GoogleFonts.inter(
                            fontSize: 17,
                            color: Colors.white.withValues(alpha: 0.68),
                            height: 1.8,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                          .animate()
                          .fadeIn(duration: 700.ms, delay: 800.ms)
                          .slideY(begin: 0.15, end: 0, duration: 700.ms, delay: 800.ms),

                      const SizedBox(height: 36),

                      Wrap(
                        spacing: 16, runSpacing: 12,
                        alignment: WrapAlignment.center,
                        children: [
                          _HeroCTA(
                            label: context.l10n.common_startScreening,
                            icon: Icons.play_arrow_rounded,
                            onTap: () => context.go('/app'),
                          ),
                          const _GhostCTA(label: 'Learn More', icon: Icons.arrow_downward_rounded),
                        ],
                      )
                          .animate()
                          .fadeIn(duration: 600.ms, delay: 1000.ms)
                          .slideY(begin: 0.2, end: 0, duration: 600.ms, delay: 1000.ms),

                      const SizedBox(height: 40),

                      _TrustBadgesRow()
                          .animate()
                          .fadeIn(duration: 600.ms, delay: 1200.ms),

                      const SizedBox(height: 24),

                      _ScrollIndicator(pulseCtrl: _pulseCtrl),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildOrbs(double w, double h) {
    final orbs = [
      _OrbCfg(size: w > 600 ? 320 : 200, c1: LT.coral, c2: LT.coralDark,
          xC: 0.12, yC: 0.22, xR: 0.07, yR: 0.05, spd: 1.0, parallax: 0.025),
      _OrbCfg(size: w > 600 ? 260 : 160, c1: LT.violet, c2: LT.violetLight,
          xC: 0.85, yC: 0.38, xR: 0.05, yR: 0.07, spd: 1.4, parallax: -0.02),
      _OrbCfg(size: w > 600 ? 180 : 110, c1: LT.midBlend, c2: LT.coralLight,
          xC: 0.55, yC: 0.72, xR: 0.09, yR: 0.04, spd: 0.8, parallax: 0.015),
    ];

    return orbs.map((orb) {
      return AnimatedBuilder(
        animation: _orbCtrl,
        builder: (_, __) {
          final t = _orbCtrl.value * orb.spd * 2 * pi;
          final px = (_mousePos.dx - 0.5) * orb.parallax * w;
          final py = (_mousePos.dy - 0.5) * orb.parallax * h;
          final x = w * orb.xC + w * orb.xR * sin(t) + px;
          final y = h * orb.yC + h * orb.yR * cos(t * 0.7) + py;

          return Positioned(
            left: x - orb.size / 2,
            top: y - orb.size / 2,
            child: Container(
              width: orb.size,
              height: orb.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  orb.c1.withValues(alpha: 0.28),
                  orb.c2.withValues(alpha: 0.10),
                  Colors.transparent,
                ], stops: const [0.0, 0.5, 1.0]),
              ),
            ),
          );
        },
      );
    }).toList();
  }
}

class _OrbCfg {
  final double size, xC, yC, xR, yR, spd, parallax;
  final Color c1, c2;
  const _OrbCfg({required this.size, required this.c1, required this.c2,
    required this.xC, required this.yC, required this.xR, required this.yR,
    required this.spd, required this.parallax});
}

// ── Mesh Blob Painter ──────────────────────────────────────────────────────
class _MeshBlobPainter extends CustomPainter {
  final double t;
  final Offset mouse;
  _MeshBlobPainter({required this.t, required this.mouse});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..maskFilter = const MaskFilter.blur(BlurStyle.normal, 90);

    // Coral blob — follows mouse slightly
    final c1x = size.width * (0.25 + 0.12 * sin(t * 2 * pi) + (mouse.dx - 0.5) * 0.08);
    final c1y = size.height * (0.35 + 0.08 * cos(t * 2 * pi * 0.7) + (mouse.dy - 0.5) * 0.06);
    paint.shader = RadialGradient(colors: [
      LT.coral.withValues(alpha: 0.22),
      LT.coralDark.withValues(alpha: 0.08),
      Colors.transparent,
    ]).createShader(Rect.fromCircle(center: Offset(c1x, c1y), radius: size.width * 0.38));
    canvas.drawCircle(Offset(c1x, c1y), size.width * 0.38, paint);

    // Violet blob
    final c2x = size.width * (0.72 + 0.09 * cos(t * 2 * pi * 1.2) - (mouse.dx - 0.5) * 0.06);
    final c2y = size.height * (0.55 + 0.1 * sin(t * 2 * pi * 0.6) - (mouse.dy - 0.5) * 0.04);
    paint.shader = RadialGradient(colors: [
      LT.violet.withValues(alpha: 0.18),
      LT.violetDark.withValues(alpha: 0.06),
      Colors.transparent,
    ]).createShader(Rect.fromCircle(center: Offset(c2x, c2y), radius: size.width * 0.32));
    canvas.drawCircle(Offset(c2x, c2y), size.width * 0.32, paint);

    // Mid blend
    final c3x = size.width * (0.5 + 0.06 * sin(t * 2 * pi * 0.9));
    final c3y = size.height * (0.2 + 0.05 * cos(t * 2 * pi * 1.1));
    paint.shader = RadialGradient(colors: [
      LT.midBlend.withValues(alpha: 0.12),
      Colors.transparent,
    ]).createShader(Rect.fromCircle(center: Offset(c3x, c3y), radius: size.width * 0.25));
    canvas.drawCircle(Offset(c3x, c3y), size.width * 0.25, paint);
  }

  @override
  bool shouldRepaint(covariant _MeshBlobPainter old) => old.t != t || old.mouse != mouse;
}

// ── Morphing Organic Blob ──────────────────────────────────────────────────
class _MorphBlobPainter extends CustomPainter {
  final double t;
  _MorphBlobPainter({required this.t});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width * 0.38;
    const points = 8;

    final path = Path();
    for (int i = 0; i <= points * 3; i++) {
      final angle = (i / points) * 2 * pi;
      final noise = 1.0 +
          0.18 * sin(angle * 2 + t * 2 * pi) +
          0.10 * cos(angle * 3 + t * 2 * pi * 1.3) +
          0.07 * sin(angle * 5 + t * 2 * pi * 0.7);
      final x = cx + r * noise * cos(angle);
      final y = cy + r * noise * sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    final paint = Paint()
      ..shader = const RadialGradient(
        colors: [LT.coral, LT.midBlend, LT.violet],
        stops: [0.0, 0.5, 1.0],
      ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: r * 1.2))
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 40)
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, paint..color = LT.coral.withValues(alpha: 0.12));

    // Stroke outline
    final strokePaint = Paint()
      ..shader = const LinearGradient(
        colors: [LT.coralLight, LT.violetLight],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..maskFilter = null;
    canvas.drawPath(path, strokePaint..color = LT.coralLight.withValues(alpha: 0.25));
  }

  @override
  bool shouldRepaint(covariant _MorphBlobPainter old) => old.t != t;
}

// ── 3D DNA Helix Painter ───────────────────────────────────────────────────
class _HelixPainter extends CustomPainter {
  final double t;
  _HelixPainter({required this.t});

  @override
  void paint(Canvas canvas, Size size) {
    const segments = 60;
    const radius = 28.0;

    for (int i = 0; i < segments; i++) {
      final progress = i / segments;
      final y = size.height * progress;
      final angle1 = progress * 4 * pi + t * 2 * pi;
      final angle2 = angle1 + pi;

      // 3D depth via cosine (z-axis simulation)
      final z1 = cos(angle1);
      final z2 = cos(angle2);

      final x1 = size.width / 2 + radius * sin(angle1);
      final x2 = size.width / 2 + radius * sin(angle2);

      final alpha1 = (0.3 + 0.5 * (z1 + 1) / 2).clamp(0.1, 0.9);
      final alpha2 = (0.3 + 0.5 * (z2 + 1) / 2).clamp(0.1, 0.9);
      final r1 = (2.5 + 2.0 * (z1 + 1) / 2).clamp(1.0, 5.0);
      final r2 = (2.5 + 2.0 * (z2 + 1) / 2).clamp(1.0, 5.0);

      // Strand 1 — coral
      canvas.drawCircle(
        Offset(x1, y),
        r1,
        Paint()..color = LT.coralLight.withValues(alpha: alpha1),
      );

      // Strand 2 — violet
      canvas.drawCircle(
        Offset(x2, y),
        r2,
        Paint()..color = LT.violetLight.withValues(alpha: alpha2),
      );

      // Cross-links every ~5 segments
      if (i % 5 == 0) {
        final linkAlpha = ((z1 + z2) / 2 * 0.3 + 0.1).clamp(0.05, 0.35);
        canvas.drawLine(
          Offset(x1, y),
          Offset(x2, y),
          Paint()
            ..color = LT.midBlend.withValues(alpha: linkAlpha)
            ..strokeWidth = 1.0,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _HelixPainter old) => old.t != t;
}

// ── Dot Grid ──────────────────────────────────────────────────────────────
class _DotGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withValues(alpha: 0.04);
    const spacing = 48.0;
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 1.2, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

// ── Animated Badge ─────────────────────────────────────────────────────────
class _AnimatedBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          LT.coral.withValues(alpha: 0.15),
          LT.violet.withValues(alpha: 0.15),
        ]),
        border: Border.all(color: LT.coralLight.withValues(alpha: 0.25)),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Container(
          width: 8, height: 8,
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [LT.coralLight, LT.violetLight]),
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: LT.coral.withValues(alpha: 0.6), blurRadius: 8)],
          ),
        ),
        const SizedBox(width: 10),
        Text(
          context.l10n.landing_aiPowered,
          style: GoogleFonts.inter(
            fontSize: 13, fontWeight: FontWeight.w600,
            color: Colors.white.withValues(alpha: 0.88),
            letterSpacing: 0.3,
          ),
        ),
      ]),
    );
  }
}

// ── Hero CTA ───────────────────────────────────────────────────────────────
class _HeroCTA extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const _HeroCTA({required this.label, required this.icon, required this.onTap});
  @override
  State<_HeroCTA> createState() => _HeroCTAState();
}

class _HeroCTAState extends State<_HeroCTA> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.symmetric(horizontal: 34, vertical: 17),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [LT.coral, LT.midBlend, LT.violet],
            ),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: LT.midBlend.withValues(alpha: _hovered ? 0.65 : 0.38),
                blurRadius: _hovered ? 36 : 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          transform: Matrix4.identity()..scale(_hovered ? 1.05 : 1.0),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(widget.icon, color: Colors.white, size: 22),
            const SizedBox(width: 10),
            Text(widget.label, style: GoogleFonts.inter(
              fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white,
            )),
          ]),
        ),
      ),
    );
  }
}

// ── Ghost CTA ──────────────────────────────────────────────────────────────
class _GhostCTA extends StatefulWidget {
  final String label;
  final IconData icon;
  const _GhostCTA({required this.label, required this.icon});
  @override
  State<_GhostCTA> createState() => _GhostCTAState();
}

class _GhostCTAState extends State<_GhostCTA> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.symmetric(horizontal: 34, vertical: 17),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: _hovered ? 0.14 : 0.07),
          border: Border.all(color: Colors.white.withValues(alpha: _hovered ? 0.35 : 0.18)),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(widget.icon, color: Colors.white.withValues(alpha: 0.8), size: 20),
          const SizedBox(width: 10),
          Text(widget.label, style: GoogleFonts.inter(
            fontSize: 16, fontWeight: FontWeight.w600,
            color: Colors.white.withValues(alpha: 0.88),
          )),
        ]),
      ),
    );
  }
}

// ── Trust Badges ───────────────────────────────────────────────────────────
class _TrustBadgesRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Wrap(
        spacing: 24, runSpacing: 8,
        alignment: WrapAlignment.center,
        children: [
          _TrustItem(icon: Icons.lock_outline, text: context.l10n.landing_trustPrivate),
          _TrustDot(),
          _TrustItem(icon: Icons.bolt_outlined, text: context.l10n.landing_trustFast),
          _TrustDot(),
          _TrustItem(icon: Icons.cloud_off_outlined, text: context.l10n.landing_trustNoData),
        ],
      ),
    );
  }
}

class _TrustItem extends StatelessWidget {
  final IconData icon;
  final String text;
  const _TrustItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      ShaderMask(
        shaderCallback: (b) => const LinearGradient(
          colors: [LT.coralLight, LT.violetLight],
        ).createShader(b),
        child: Icon(icon, size: 15, color: Colors.white),
      ),
      const SizedBox(width: 6),
      Text(text, style: GoogleFonts.inter(
        fontSize: 13, fontWeight: FontWeight.w500,
        color: Colors.white.withValues(alpha: 0.6),
      )),
    ]);
  }
}

class _TrustDot extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    width: 4, height: 4,
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: 0.2),
      shape: BoxShape.circle,
    ),
  );
}

// ── Scroll Indicator ───────────────────────────────────────────────────────
class _ScrollIndicator extends StatelessWidget {
  final AnimationController pulseCtrl;
  const _ScrollIndicator({required this.pulseCtrl});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: pulseCtrl,
      builder: (_, __) => Opacity(
        opacity: 0.35 + pulseCtrl.value * 0.35,
        child: Transform.translate(
          offset: Offset(0, pulseCtrl.value * 7),
          child: ShaderMask(
            shaderCallback: (b) => const LinearGradient(
              colors: [LT.coralLight, LT.violetLight],
            ).createShader(b),
            child: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white, size: 30),
          ),
        ),
      ),
    );
  }
}
