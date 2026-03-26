// Stroke Mitra - Application Theme
//
/// Premium healthtech design system with Light + Dark mode support.
/// Emerald teal primary, indigo accent, warm neutrals.
/// Fonts: Inter (body) + Outfit (headings) + JetBrains Mono (metrics).

import 'package:flutter/material.dart';
import 'package:stroke_mitra/l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

// ─── Custom Theme Extension ─────────────────────────────────────────────────
class AppColors extends ThemeExtension<AppColors> {
  final Color cardBorder;
  final Color cardElevated;
  final Color successSurface;
  final Color dangerSurface;
  final Color warningSurface;
  final Color accentSurface;
  final Color primarySurface;
  final Color shimmerBase;
  final Color shimmerHighlight;
  final Gradient heroGradient;
  final Gradient ctaGradient;
  final Gradient primaryGradient;
  final Gradient darkGradient;
  final Gradient faceGradient;
  final Gradient voiceGradient;
  final Gradient motionGradient;
  final Gradient tapGradient;

  const AppColors({
    required this.cardBorder,
    required this.cardElevated,
    required this.successSurface,
    required this.dangerSurface,
    required this.warningSurface,
    required this.accentSurface,
    required this.primarySurface,
    required this.shimmerBase,
    required this.shimmerHighlight,
    required this.heroGradient,
    required this.ctaGradient,
    required this.primaryGradient,
    required this.darkGradient,
    required this.faceGradient,
    required this.voiceGradient,
    required this.motionGradient,
    required this.tapGradient,
  });

  @override
  AppColors copyWith({
    Color? cardBorder,
    Color? cardElevated,
    Color? successSurface,
    Color? dangerSurface,
    Color? warningSurface,
    Color? accentSurface,
    Color? primarySurface,
    Color? shimmerBase,
    Color? shimmerHighlight,
    Gradient? heroGradient,
    Gradient? ctaGradient,
    Gradient? primaryGradient,
    Gradient? darkGradient,
    Gradient? faceGradient,
    Gradient? voiceGradient,
    Gradient? motionGradient,
    Gradient? tapGradient,
  }) {
    return AppColors(
      cardBorder: cardBorder ?? this.cardBorder,
      cardElevated: cardElevated ?? this.cardElevated,
      successSurface: successSurface ?? this.successSurface,
      dangerSurface: dangerSurface ?? this.dangerSurface,
      warningSurface: warningSurface ?? this.warningSurface,
      accentSurface: accentSurface ?? this.accentSurface,
      primarySurface: primarySurface ?? this.primarySurface,
      shimmerBase: shimmerBase ?? this.shimmerBase,
      shimmerHighlight: shimmerHighlight ?? this.shimmerHighlight,
      heroGradient: heroGradient ?? this.heroGradient,
      ctaGradient: ctaGradient ?? this.ctaGradient,
      primaryGradient: primaryGradient ?? this.primaryGradient,
      darkGradient: darkGradient ?? this.darkGradient,
      faceGradient: faceGradient ?? this.faceGradient,
      voiceGradient: voiceGradient ?? this.voiceGradient,
      motionGradient: motionGradient ?? this.motionGradient,
      tapGradient: tapGradient ?? this.tapGradient,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      cardBorder: Color.lerp(cardBorder, other.cardBorder, t)!,
      cardElevated: Color.lerp(cardElevated, other.cardElevated, t)!,
      successSurface: Color.lerp(successSurface, other.successSurface, t)!,
      dangerSurface: Color.lerp(dangerSurface, other.dangerSurface, t)!,
      warningSurface: Color.lerp(warningSurface, other.warningSurface, t)!,
      accentSurface: Color.lerp(accentSurface, other.accentSurface, t)!,
      primarySurface: Color.lerp(primarySurface, other.primarySurface, t)!,
      shimmerBase: Color.lerp(shimmerBase, other.shimmerBase, t)!,
      shimmerHighlight: Color.lerp(shimmerHighlight, other.shimmerHighlight, t)!,
      heroGradient: t < 0.5 ? heroGradient : other.heroGradient,
      ctaGradient: t < 0.5 ? ctaGradient : other.ctaGradient,
      primaryGradient: t < 0.5 ? primaryGradient : other.primaryGradient,
      darkGradient: t < 0.5 ? darkGradient : other.darkGradient,
      faceGradient: t < 0.5 ? faceGradient : other.faceGradient,
      voiceGradient: t < 0.5 ? voiceGradient : other.voiceGradient,
      motionGradient: t < 0.5 ? motionGradient : other.motionGradient,
      tapGradient: t < 0.5 ? tapGradient : other.tapGradient,
    );
  }
}

// ─── Static Color Constants (kept for backward compat during migration) ─────
class AppTheme {
  AppTheme._();

  // ─── Primary — Emerald Teal ───
  static const Color primary = Color(0xFF0B6B5D);
  static const Color primaryLight = Color(0xFF14B8A6);
  static const Color primaryDark = Color(0xFF065F53);

  // ─── Accent — Indigo ───
  static const Color accent = Color(0xFF6366F1);
  static const Color accentLight = Color(0xFF818CF8);

  // ─── Secondary — Sage Green ───
  static const Color secondary = Color(0xFF4CB88C);

  // ─── Extended Palette ───
  static const Color blue50 = Color(0xFFEFF8FF);
  static const Color blue100 = Color(0xFFDBEFFE);
  static const Color blue400 = Color(0xFF38BDF8);
  static const Color blue500 = Color(0xFF0EA5E9);
  static const Color blue600 = Color(0xFF0284C7);
  static const Color blue700 = Color(0xFF0369A1);
  static const Color blue900 = Color(0xFF0C4A6E);

  static const Color teal50 = Color(0xFFF0FDFA);
  static const Color teal100 = Color(0xFFCCFBF1);
  static const Color teal400 = Color(0xFF2DD4BF);
  static const Color teal500 = Color(0xFF14B8A6);
  static const Color teal600 = Color(0xFF0D9488);
  static const Color teal700 = Color(0xFF0B6B5D);

  static const Color indigo50 = Color(0xFFEEF2FF);
  static const Color indigo100 = Color(0xFFE0E7FF);
  static const Color indigo400 = Color(0xFF818CF8);
  static const Color indigo500 = Color(0xFF6366F1);
  static const Color indigo600 = Color(0xFF4F46E5);

  static const Color orange400 = Color(0xFFFB923C);
  static const Color orange500 = Color(0xFFF97316);
  static const Color orange600 = Color(0xFFEA580C);

  static const Color amber400 = Color(0xFFFBBF24);
  static const Color amber500 = Color(0xFFF59E0B);

  static const Color green400 = Color(0xFF4ADE80);
  static const Color green500 = Color(0xFF22C55E);
  static const Color green600 = Color(0xFF16A34A);

  static const Color red400 = Color(0xFFF87171);
  static const Color red500 = Color(0xFFEF4444);
  static const Color red600 = Color(0xFFDC2626);

  // ─── Slate Palette ───
  static const Color slate50 = Color(0xFFF8FAFC);
  static const Color slate100 = Color(0xFFF1F5F9);
  static const Color slate200 = Color(0xFFE2E8F0);
  static const Color slate300 = Color(0xFFCBD5E1);
  static const Color slate400 = Color(0xFF94A3B8);
  static const Color slate500 = Color(0xFF64748B);
  static const Color slate600 = Color(0xFF475569);
  static const Color slate700 = Color(0xFF334155);
  static const Color slate800 = Color(0xFF1E293B);
  static const Color slate900 = Color(0xFF0F172A);
  static const Color slate950 = Color(0xFF020617);

  // ─── Backgrounds ───
  static const Color bgApp = Color(0xFFFAFBFC);
  static const Color bgCard = Colors.white;
  static const Color bgDark = Color(0xFF0B1120);
  static const Color bgDarkCard = Color(0xFF1E293B);

  // ─── Status Colors ───
  static const Color statusSuccess = Color(0xFF22C55E);
  static const Color statusWarning = Color(0xFFF59E0B);
  static const Color statusError = Color(0xFFEF4444);

  // ─── Gradient Definitions ───
  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0B6B5D), Color(0xFF0D9488), Color(0xFF0EA5E9)],
  );

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [teal700, teal500],
  );

  static const LinearGradient ctaGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [indigo500, teal500],
  );

  static const LinearGradient darkGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [slate900, Color(0xFF0C4A6E)],
  );

  // Per-test gradients
  static const LinearGradient faceGradient = LinearGradient(
    colors: [Color(0xFF0B6B5D), Color(0xFF14B8A6)],
  );
  static const LinearGradient voiceGradient = LinearGradient(
    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
  );
  static const LinearGradient motionGradient = LinearGradient(
    colors: [Color(0xFFF59E0B), Color(0xFFF97316)],
  );
  static const LinearGradient tapGradient = LinearGradient(
    colors: [Color(0xFF0EA5E9), Color(0xFF3B82F6)],
  );

  // ─── Text Styles ───
  static TextStyle get displayLG => GoogleFonts.outfit(
        fontSize: 36,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.5,
        height: 1.1,
      );

  static TextStyle get headingXL => GoogleFonts.outfit(
        fontSize: 40,
        fontWeight: FontWeight.w900,
        letterSpacing: -1.5,
        height: 1.08,
      );

  static TextStyle get headingLG => GoogleFonts.outfit(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
        height: 1.15,
      );

  static TextStyle get headingMD => GoogleFonts.outfit(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        height: 1.2,
      );

  static TextStyle get headingSM => GoogleFonts.outfit(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.3,
      );

  static TextStyle get bodyLG => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.7,
      );

  static TextStyle get bodyMD => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.65,
      );

  static TextStyle get bodySM => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.6,
      );

  static TextStyle get labelTag => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8,
      );

  static TextStyle get metricLG => GoogleFonts.jetBrainsMono(
        fontSize: 28,
        fontWeight: FontWeight.w600,
      );

  static TextStyle get metricMD => GoogleFonts.jetBrainsMono(
        fontSize: 20,
        fontWeight: FontWeight.w500,
      );

  static TextStyle get metricSM => GoogleFonts.jetBrainsMono(
        fontSize: 14,
        fontWeight: FontWeight.w500,
      );

  // ─── Border Radius ───
  static const double radiusSM = 4.0;
  static const double radiusMD = 12.0;
  static const double radiusLG = 16.0;
  static const double radiusXL = 24.0;
  static const double radius2XL = 32.0;

  // ─── Spacing ───
  static const double spaceXS = 4.0;
  static const double spaceSM = 8.0;
  static const double spaceMD = 16.0;
  static const double spaceLG = 24.0;
  static const double spaceXL = 40.0;
  static const double space2XL = 64.0;
  static const double space3XL = 96.0;

  // ─── Shadows ───
  static List<BoxShadow> get shadowSM => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ];

  static List<BoxShadow> get shadowMD => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.06),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> get shadowLG => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.08),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
      ];

  static List<BoxShadow> shadowColored(Color color) => [
        BoxShadow(
          color: color.withValues(alpha: 0.25),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ];

  // ─── Light Theme ───
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: bgApp,
      colorScheme: ColorScheme.light(
        primary: primary,
        onPrimary: Colors.white,
        secondary: accent,
        onSecondary: Colors.white,
        tertiary: secondary,
        surface: bgCard,
        onSurface: slate900,
        error: statusError,
        onError: Colors.white,
        outline: slate200,
        surfaceContainerHighest: slate100,
      ),
      textTheme: _buildTextTheme(Brightness.light),
      appBarTheme: AppBarTheme(
        backgroundColor: bgCard,
        foregroundColor: slate900,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: GoogleFonts.outfit(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: slate900,
        ),
      ),
      cardTheme: CardThemeData(
        color: bgCard,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLG),
          side: BorderSide(color: slate200.withValues(alpha: 0.6)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMD),
          ),
          elevation: 0,
          textStyle: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          side: BorderSide(color: primary.withValues(alpha: 0.3), width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMD),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: slate50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMD),
          borderSide: BorderSide(color: slate200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMD),
          borderSide: BorderSide(color: slate200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMD),
          borderSide: BorderSide(color: primary, width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: GoogleFonts.inter(fontSize: 14, color: slate400),
      ),
      dividerTheme: DividerThemeData(
        color: slate200.withValues(alpha: 0.6),
        thickness: 1,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: bgCard,
        selectedItemColor: primary,
        unselectedItemColor: slate400,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w400,
        ),
      ),
      extensions: const [_lightAppColors],
    );
  }

  // ─── Dark Theme ───
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: bgDark,
      colorScheme: ColorScheme.dark(
        primary: teal400,
        onPrimary: slate900,
        secondary: indigo400,
        onSecondary: Colors.white,
        tertiary: green400,
        surface: bgDarkCard,
        onSurface: const Color(0xFFF1F5F9),
        error: red400,
        onError: Colors.white,
        outline: slate700,
        surfaceContainerHighest: const Color(0xFF273548),
      ),
      textTheme: _buildTextTheme(Brightness.dark),
      appBarTheme: AppBarTheme(
        backgroundColor: bgDark,
        foregroundColor: const Color(0xFFF1F5F9),
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: GoogleFonts.outfit(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: const Color(0xFFF1F5F9),
        ),
      ),
      cardTheme: CardThemeData(
        color: bgDarkCard,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLG),
          side: BorderSide(color: slate700.withValues(alpha: 0.5)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: teal400,
          foregroundColor: slate900,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMD),
          ),
          elevation: 0,
          textStyle: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: teal400,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          side: BorderSide(color: teal400.withValues(alpha: 0.3), width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMD),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF273548),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMD),
          borderSide: BorderSide(color: slate700),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMD),
          borderSide: BorderSide(color: slate700),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMD),
          borderSide: BorderSide(color: teal400, width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: GoogleFonts.inter(fontSize: 14, color: slate500),
      ),
      dividerTheme: DividerThemeData(
        color: slate700.withValues(alpha: 0.5),
        thickness: 1,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: bgDarkCard,
        selectedItemColor: teal400,
        unselectedItemColor: slate500,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w400,
        ),
      ),
      extensions: const [_darkAppColors],
    );
  }

  // ─── Shared text theme builder ───
  static TextTheme _buildTextTheme(Brightness brightness) {
    final isLight = brightness == Brightness.light;
    final primary = isLight ? slate900 : const Color(0xFFF1F5F9);
    final secondary = isLight ? slate500 : slate400;

    return GoogleFonts.interTextTheme().copyWith(
      displayLarge: headingXL.copyWith(color: primary),
      displayMedium: headingLG.copyWith(color: primary),
      headlineMedium: headingMD.copyWith(color: primary),
      titleLarge: headingSM.copyWith(color: primary),
      bodyLarge: bodyLG.copyWith(color: secondary),
      bodyMedium: bodyMD.copyWith(color: secondary),
      bodySmall: bodySM.copyWith(color: secondary),
    );
  }

  // ─── Light Mode App Colors ───
  static const _lightAppColors = AppColors(
    cardBorder: Color(0xFFE2E8F0),
    cardElevated: Colors.white,
    successSurface: Color(0xFFF0FDF4),
    dangerSurface: Color(0xFFFEF2F2),
    warningSurface: Color(0xFFFFFBEB),
    accentSurface: Color(0xFFEEF2FF),
    primarySurface: Color(0xFFF0FDFA),
    shimmerBase: Color(0xFFE2E8F0),
    shimmerHighlight: Color(0xFFF8FAFC),
    heroGradient: heroGradient,
    ctaGradient: ctaGradient,
    primaryGradient: primaryGradient,
    darkGradient: darkGradient,
    faceGradient: faceGradient,
    voiceGradient: voiceGradient,
    motionGradient: motionGradient,
    tapGradient: tapGradient,
  );

  // ─── Dark Mode App Colors ───
  static const _darkAppColors = AppColors(
    cardBorder: Color(0xFF334155),
    cardElevated: Color(0xFF273548),
    successSurface: Color(0xFF052E16),
    dangerSurface: Color(0xFF450A0A),
    warningSurface: Color(0xFF451A03),
    accentSurface: Color(0xFF1E1B4B),
    primarySurface: Color(0xFF042F2E),
    shimmerBase: Color(0xFF334155),
    shimmerHighlight: Color(0xFF475569),
    heroGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF042F2E), Color(0xFF0B6B5D), Color(0xFF0C4A6E)],
    ),
    ctaGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF4F46E5), Color(0xFF0D9488)],
    ),
    primaryGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF0D9488), Color(0xFF2DD4BF)],
    ),
    darkGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF020617), Color(0xFF0C4A6E)],
    ),
    faceGradient: LinearGradient(
      colors: [Color(0xFF0D9488), Color(0xFF2DD4BF)],
    ),
    voiceGradient: LinearGradient(
      colors: [Color(0xFF818CF8), Color(0xFFA78BFA)],
    ),
    motionGradient: LinearGradient(
      colors: [Color(0xFFFBBF24), Color(0xFFFB923C)],
    ),
    tapGradient: LinearGradient(
      colors: [Color(0xFF38BDF8), Color(0xFF60A5FA)],
    ),
  );
}

/// Helper to get AppColors from context
extension AppColorsExtension on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
}

/// Helper to get AppLocalizations from context
extension L10nExtension on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
