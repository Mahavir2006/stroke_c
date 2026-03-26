// Stroke Mitra — Landing Page Theme
// Coral-to-Violet dual tone with seamless blending

import 'package:flutter/material.dart';

class LT {
  LT._();

  // ── Core palette ──────────────────────────────────────────────────────────
  static const Color coral       = Color(0xFFE8445A);
  static const Color coralLight  = Color(0xFFFF6B7A);
  static const Color coralDark   = Color(0xFFC2185B);
  static const Color violet      = Color(0xFF7C3AED);
  static const Color violetLight = Color(0xFF9F67F5);
  static const Color violetDark  = Color(0xFF5B21B6);
  static const Color midBlend    = Color(0xFFAB2D7A); // coral ↔ violet midpoint

  // ── Backgrounds ───────────────────────────────────────────────────────────
  static const Color bgWarm      = Color(0xFFFFF8F6); // hero warm cream
  static const Color bgCool      = Color(0xFFF5F0FF); // footer cool lavender
  static const Color bgCard      = Colors.white;
  static const Color bgSection   = Color(0xFFFDF6FF); // slight lavender tint

  // ── Text ──────────────────────────────────────────────────────────────────
  static const Color textPrimary   = Color(0xFF1A0A0F);
  static const Color textSecondary = Color(0xFF6B4C5E);
  static const Color textMuted     = Color(0xFF9E7A8A);

  // ── Gradients ─────────────────────────────────────────────────────────────
  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1A0510), Color(0xFF2D0A2E), Color(0xFF0D0520)],
    stops: [0.0, 0.5, 1.0],
  );

  static const LinearGradient coralViolet = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [coral, midBlend, violet],
  );

  static const LinearGradient coralVioletDiag = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [coral, midBlend, violet],
  );

  static const LinearGradient pageFade = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [bgWarm, bgSection, bgCool],
    stops: [0.0, 0.5, 1.0],
  );

  // ── Shadows ───────────────────────────────────────────────────────────────
  static List<BoxShadow> coralGlow(double alpha) => [
    BoxShadow(color: coral.withValues(alpha: alpha), blurRadius: 32, offset: const Offset(0, 8)),
  ];

  static List<BoxShadow> violetGlow(double alpha) => [
    BoxShadow(color: violet.withValues(alpha: alpha), blurRadius: 32, offset: const Offset(0, 8)),
  ];

  static List<BoxShadow> blendGlow(double alpha) => [
    BoxShadow(color: midBlend.withValues(alpha: alpha), blurRadius: 40, offset: const Offset(0, 10)),
  ];
}
