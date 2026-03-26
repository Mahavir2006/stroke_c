// Landing Footer — Coral-violet dark footer
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../app/theme.dart';
import '../../../app/landing_theme.dart';

class LandingFooter extends StatelessWidget {
  const LandingFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A0510), Color(0xFF0D0520)],
        ),
      ),
      padding: const EdgeInsets.fromLTRB(24, 64, 24, 32),
      child: Center(child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1160),
        child: Column(children: [
          w > 700
              ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Expanded(child: _Brand(context)),
                  const SizedBox(width: 48),
                  Expanded(flex: 2, child: _Links(context)),
                ])
              : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  _Brand(context),
                  const SizedBox(height: 32),
                  _Links(context),
                ]),
          const SizedBox(height: 48),
          Divider(color: LT.coral.withValues(alpha: 0.12)),
          const SizedBox(height: 24),
          Text(context.l10n.landing_footerCopyright,
              style: GoogleFonts.inter(fontSize: 13,
                  color: Colors.white.withValues(alpha: 0.3)),
              textAlign: TextAlign.center),
          const SizedBox(height: 6),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Text(context.l10n.landing_footerDisclaimer,
              style: GoogleFonts.inter(fontSize: 12,
                  color: Colors.white.withValues(alpha: 0.25), height: 1.6),
              textAlign: TextAlign.center),
          ),
        ]),
      )),
    );
  }
}

class _Brand extends StatelessWidget {
  final BuildContext ctx;
  const _Brand(this.ctx);
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Container(
          width: 34, height: 34,
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [LT.coral, LT.midBlend, LT.violet]),
            borderRadius: BorderRadius.circular(9),
            boxShadow: [BoxShadow(color: LT.coral.withValues(alpha: 0.4), blurRadius: 12)],
          ),
          child: const Icon(Icons.favorite_rounded, color: Colors.white, size: 18),
        ),
        const SizedBox(width: 10),
        ShaderMask(
          shaderCallback: (b) => const LinearGradient(
            colors: [LT.coralLight, LT.violetLight],
          ).createShader(b),
          child: Text(ctx.l10n.appName, style: GoogleFonts.outfit(
              fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white)),
        ),
      ]),
      const SizedBox(height: 12),
      Text(ctx.l10n.landing_footerTagline,
        style: GoogleFonts.inter(fontSize: 14,
            color: Colors.white.withValues(alpha: 0.4), height: 1.6)),
    ]);
  }
}

class _Links extends StatelessWidget {
  final BuildContext ctx;
  const _Links(this.ctx);
  @override
  Widget build(BuildContext context) {
    return Wrap(spacing: 32, runSpacing: 24, children: [
      _Col(ctx.l10n.landing_footerScreening, [
        _Link(ctx.l10n.landing_footer_faceAnalysis, () => ctx.go('/face'), LT.coral),
        _Link(ctx.l10n.landing_footer_speechCheck, () => ctx.go('/voice'), LT.midBlend),
        _Link(ctx.l10n.landing_footer_motionTest, () => ctx.go('/motion'), LT.violet),
      ]),
      _Col(ctx.l10n.landing_footerLearn, [
        _Link(ctx.l10n.landing_footerWhatIs, null, null),
        _Link(ctx.l10n.landing_footerHowItWorks, null, null),
        _Link(ctx.l10n.landing_footerWhyEarly, null, null),
      ]),
      _Col(ctx.l10n.landing_footerEmergency, [
        _Link(ctx.l10n.landing_footerCall112, () => launchUrl(Uri.parse('tel:112')), LT.coral, isEmergency: true),
        _Link(ctx.l10n.landing_footerAmbulance108, () => launchUrl(Uri.parse('tel:108')), LT.coral, isEmergency: true),
      ]),
    ]);
  }
}

class _Col extends StatelessWidget {
  final String title; final List<Widget> children;
  const _Col(this.title, this.children);
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      ShaderMask(
        shaderCallback: (b) => const LinearGradient(
          colors: [LT.coral, LT.violet],
        ).createShader(b),
        child: Text(title.toUpperCase(), style: GoogleFonts.inter(
            fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1, color: Colors.white)),
      ),
      const SizedBox(height: 16),
      ...children,
    ]);
  }
}

class _Link extends StatefulWidget {
  final String text; final VoidCallback? onTap;
  final Color? accentColor; final bool isEmergency;
  const _Link(this.text, this.onTap, this.accentColor, {this.isEmergency = false});
  @override
  State<_Link> createState() => _LinkState();
}

class _LinkState extends State<_Link> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: GoogleFonts.inter(
              fontSize: 14,
              color: widget.isEmergency
                  ? LT.coral
                  : _hovered
                      ? (widget.accentColor ?? Colors.white)
                      : Colors.white.withValues(alpha: 0.4),
              fontWeight: widget.isEmergency ? FontWeight.w600 : FontWeight.w400,
            ),
            child: Text(widget.text),
          ),
        ),
      ),
    );
  }
}
