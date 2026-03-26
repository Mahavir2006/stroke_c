// CTA Section — Coral-violet gradient, pulsing emergency button
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../app/theme.dart';
import '../../../app/landing_theme.dart';

class CTASection extends StatefulWidget {
  const CTASection({super.key});
  @override
  State<CTASection> createState() => _CTASectionState();
}

class _CTASectionState extends State<CTASection> with TickerProviderStateMixin {
  late AnimationController _pulseCtrl;
  late AnimationController _orbCtrl;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 2))
      ..repeat(reverse: true);
    _orbCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 12))
      ..repeat();
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    _orbCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      // Coral-violet dark gradient
      Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1A0510), Color(0xFF2D0A2E), Color(0xFF0D0520)],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 24),
        child: Center(child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: Column(children: [
            // Pulsing icon
            AnimatedBuilder(
              animation: _pulseCtrl,
              builder: (context, _) {
                final scale = 1.0 + _pulseCtrl.value * 0.1;
                return Transform.scale(
                  scale: scale,
                  child: Container(
                    width: 84, height: 84,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [LT.coral, LT.midBlend, LT.violet],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: LT.coral.withValues(alpha: 0.35 + _pulseCtrl.value * 0.25),
                          blurRadius: 28 + _pulseCtrl.value * 20,
                          spreadRadius: _pulseCtrl.value * 5,
                        ),
                        BoxShadow(
                          color: LT.violet.withValues(alpha: 0.2 + _pulseCtrl.value * 0.15),
                          blurRadius: 40 + _pulseCtrl.value * 20,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.favorite_rounded, color: Colors.white, size: 38),
                  ),
                );
              },
            ),
            const SizedBox(height: 32),
            ShaderMask(
              shaderCallback: (b) => const LinearGradient(
                colors: [LT.coralLight, LT.midBlend, LT.violetLight],
              ).createShader(b),
              child: Text(
                context.l10n.landing_ctaTitle1,
                style: GoogleFonts.outfit(fontSize: 42, fontWeight: FontWeight.w900,
                    color: Colors.white, letterSpacing: -1.5, height: 1.1),
                textAlign: TextAlign.center,
              ),
            ),
            Text(
              context.l10n.landing_ctaTitle2,
              style: GoogleFonts.outfit(fontSize: 42, fontWeight: FontWeight.w900,
                  color: Colors.white.withValues(alpha: 0.9), letterSpacing: -1.5, height: 1.1),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              context.l10n.landing_ctaSubtitle,
              style: GoogleFonts.inter(fontSize: 17,
                  color: Colors.white.withValues(alpha: 0.65), height: 1.75),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            Wrap(spacing: 16, runSpacing: 12, alignment: WrapAlignment.center, children: [
              _CTAButton(
                label: context.l10n.landing_ctaStart,
                icon: Icons.play_arrow_rounded,
                onTap: () => context.go('/app'),
              ),
              _EmergencyButton(
                label: context.l10n.landing_ctaEmergency,
                icon: Icons.phone,
                onTap: () => launchUrl(Uri.parse('tel:112')),
                pulseCtrl: _pulseCtrl,
              ),
            ]),
            const SizedBox(height: 24),
            Text(context.l10n.landing_ctaFree,
              style: GoogleFonts.inter(fontSize: 13,
                  color: Colors.white.withValues(alpha: 0.35)),
              textAlign: TextAlign.center,
            ),
          ]),
        )),
      ),

      // Animated coral orb top-left
      Positioned(
        top: -40, left: -60,
        child: AnimatedBuilder(
          animation: _orbCtrl,
          builder: (_, __) {
            final t = _orbCtrl.value * 2 * pi;
            return Transform.translate(
              offset: Offset(sin(t) * 20, cos(t * 0.7) * 15),
              child: Container(
                width: 240, height: 240,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(colors: [
                    LT.coral.withValues(alpha: 0.18),
                    Colors.transparent,
                  ]),
                ),
              ),
            );
          },
        ),
      ),

      // Animated violet orb bottom-right
      Positioned(
        bottom: -30, right: -50,
        child: AnimatedBuilder(
          animation: _orbCtrl,
          builder: (_, __) {
            final t = _orbCtrl.value * 2 * pi;
            return Transform.translate(
              offset: Offset(cos(t * 1.2) * 15, sin(t * 0.8) * 20),
              child: Container(
                width: 200, height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(colors: [
                    LT.violet.withValues(alpha: 0.15),
                    Colors.transparent,
                  ]),
                ),
              ),
            );
          },
        ),
      ),
    ]);
  }
}

class _CTAButton extends StatefulWidget {
  final String label; final IconData icon; final VoidCallback onTap;
  const _CTAButton({required this.label, required this.icon, required this.onTap});
  @override
  State<_CTAButton> createState() => _CTAButtonState();
}

class _CTAButtonState extends State<_CTAButton> {
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
          padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 17),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [LT.coral, LT.midBlend, LT.violet]),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [BoxShadow(
              color: LT.midBlend.withValues(alpha: _hovered ? 0.65 : 0.35),
              blurRadius: _hovered ? 36 : 18,
              offset: const Offset(0, 6),
            )],
          ),
          transform: Matrix4.identity()..scale(_hovered ? 1.04 : 1.0),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(widget.icon, color: Colors.white, size: 22),
            const SizedBox(width: 10),
            Text(widget.label, style: GoogleFonts.inter(
                fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
          ]),
        ),
      ),
    );
  }
}

class _EmergencyButton extends StatefulWidget {
  final String label; final IconData icon;
  final VoidCallback onTap; final AnimationController pulseCtrl;
  const _EmergencyButton({required this.label, required this.icon,
      required this.onTap, required this.pulseCtrl});
  @override
  State<_EmergencyButton> createState() => _EmergencyButtonState();
}

class _EmergencyButtonState extends State<_EmergencyButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: widget.pulseCtrl,
          builder: (context, _) => AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 17),
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(
                color: LT.coral.withValues(alpha: _hovered ? 0.8 : 0.45 + widget.pulseCtrl.value * 0.2),
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: _hovered ? [
                BoxShadow(color: LT.coral.withValues(alpha: 0.3), blurRadius: 24),
              ] : [],
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(widget.icon, color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Text(widget.label, style: GoogleFonts.inter(
                  fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
            ]),
          ),
        ),
      ),
    );
  }
}
