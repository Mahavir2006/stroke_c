// Landing Nav — Coral-violet glassmorphism navbar
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/theme.dart';
import '../../../app/landing_theme.dart';

class LandingNav extends StatelessWidget {
  final double scrollOffset;
  const LandingNav({super.key, this.scrollOffset = 0});

  @override
  Widget build(BuildContext context) {
    final bgAlpha = (scrollOffset / 200).clamp(0.0, 0.88);
    final scrolled = scrollOffset > 20;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          decoration: BoxDecoration(
            gradient: scrolled
                ? LinearGradient(colors: [
                    LT.bgWarm.withValues(alpha: bgAlpha),
                    LT.bgCool.withValues(alpha: bgAlpha),
                  ])
                : null,
            color: scrolled ? null : Colors.transparent,
            border: Border(bottom: BorderSide(
              color: scrolled
                  ? LT.coral.withValues(alpha: 0.12)
                  : Colors.transparent,
            )),
          ),
          child: SafeArea(
            bottom: false,
            child: Row(children: [
              // Logo
              Container(
                width: 34, height: 34,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [LT.coral, LT.midBlend, LT.violet],
                  ),
                  borderRadius: BorderRadius.circular(9),
                  boxShadow: [
                    BoxShadow(color: LT.coral.withValues(alpha: 0.4), blurRadius: 12),
                  ],
                ),
                child: const Icon(Icons.favorite_rounded, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 10),
              ShaderMask(
                shaderCallback: (b) => LinearGradient(
                  colors: scrolled
                      ? [LT.coral, LT.violet]
                      : [Colors.white, Colors.white],
                ).createShader(b),
                child: Text(
                  'Stroke Mitra',
                  style: GoogleFonts.outfit(
                    fontSize: 20, fontWeight: FontWeight.w800,
                    color: Colors.white, letterSpacing: -0.5,
                  ),
                ),
              ),
              const Spacer(),
              _NavButton(label: context.l10n.landing_nav_checkSymptoms, onTap: () => context.go('/app')),
            ]),
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatefulWidget {
  final String label; final VoidCallback onTap;
  const _NavButton({required this.label, required this.onTap});
  @override
  State<_NavButton> createState() => _NavButtonState();
}

class _NavButtonState extends State<_NavButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 11),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [LT.coral, LT.midBlend, LT.violet]),
            borderRadius: BorderRadius.circular(11),
            boxShadow: [
              BoxShadow(
                color: LT.midBlend.withValues(alpha: _hovered ? 0.55 : 0.3),
                blurRadius: _hovered ? 22 : 12,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          transform: Matrix4.identity()..scale(_hovered ? 1.04 : 1.0),
          child: Text(widget.label, style: GoogleFonts.inter(
            fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white,
          )),
        ),
      ),
    );
  }
}
