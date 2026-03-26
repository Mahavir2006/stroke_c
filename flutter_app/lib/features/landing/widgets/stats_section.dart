// Stats Section — Coral-violet dark background, slot-machine counters, F.A.S.T. banner
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/theme.dart';
import '../../../app/landing_theme.dart';

class StatsSection extends StatefulWidget {
  final double scrollOffset;
  const StatsSection({super.key, this.scrollOffset = 0});
  @override
  State<StatsSection> createState() => _StatsSectionState();
}

class _StatsSectionState extends State<StatsSection> with TickerProviderStateMixin {
  late AnimationController _countCtrl;
  late AnimationController _particleCtrl;
  bool _started = false;

  @override
  void initState() {
    super.initState();
    _countCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 2400));
    _particleCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 18))..repeat();
  }

  @override
  void didUpdateWidget(StatsSection old) {
    super.didUpdateWidget(old);
    if (!_started && widget.scrollOffset > 1800) {
      _started = true;
      _countCtrl.forward();
    }
  }

  @override
  void dispose() {
    _countCtrl.dispose();
    _particleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final stats = [
      _Stat(15000000, '+', context.l10n.landing_stat1Label, LT.coral),
      _Stat(80, '%', context.l10n.landing_stat2Label, LT.coralLight),
      _Stat(1900000, '', context.l10n.landing_stat3Label, LT.midBlend),
      _Stat(3, 'x', context.l10n.landing_stat4Label, LT.violetLight),
    ];

    return Stack(fit: StackFit.passthrough, children: [
      // Dark coral-violet gradient background
      Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1A0510), Color(0xFF2D0A2E), Color(0xFF0D0520)],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 96, horizontal: 24),
        child: Center(child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1160),
          child: Column(children: [
            // Tag
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  LT.coral.withValues(alpha: 0.2),
                  LT.violet.withValues(alpha: 0.2),
                ]),
                border: Border.all(color: LT.coral.withValues(alpha: 0.35)),
                borderRadius: BorderRadius.circular(100),
              ),
              child: ShaderMask(
                shaderCallback: (b) => const LinearGradient(
                  colors: [LT.coralLight, LT.violetLight],
                ).createShader(b),
                child: Text(
                  context.l10n.landing_statsTag.toUpperCase(),
                  style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700,
                      letterSpacing: 1.2, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ShaderMask(
              shaderCallback: (b) => const LinearGradient(
                colors: [LT.coralLight, LT.midBlend, LT.violetLight],
              ).createShader(b),
              child: Text(
                context.l10n.landing_statsTitle,
                style: GoogleFonts.outfit(fontSize: 40, fontWeight: FontWeight.w900,
                    color: Colors.white, letterSpacing: -1.5),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Text(context.l10n.landing_statsSubtitle,
                style: GoogleFonts.inter(fontSize: 17,
                    color: Colors.white.withValues(alpha: 0.6), height: 1.7),
                textAlign: TextAlign.center),
            ),
            const SizedBox(height: 64),

            // Stats grid
            AnimatedBuilder(animation: _countCtrl, builder: (context, _) {
              final v = Curves.easeOutCubic.transform(_countCtrl.value);
              return Wrap(spacing: 20, runSpacing: 20, alignment: WrapAlignment.center,
                children: stats.map((s) => SizedBox(
                  width: w > 900 ? (w - 48 - 60) / 4 : w > 600 ? (w - 48 - 20) / 2 : w - 48,
                  child: _StatCard(stat: s, progress: v),
                )).toList(),
              );
            }),

            const SizedBox(height: 56),

            // F.A.S.T. banner
            Container(
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  LT.coral.withValues(alpha: 0.08),
                  LT.violet.withValues(alpha: 0.08),
                ]),
                border: Border.all(color: LT.coral.withValues(alpha: 0.2)),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(children: [
                Text.rich(TextSpan(children: [
                  TextSpan(text: context.l10n.landing_fastRemember,
                      style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.w700,
                          color: Colors.white.withValues(alpha: 0.9))),
                  TextSpan(text: context.l10n.landing_fastTitle,
                      style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.w900,
                          foreground: Paint()..shader = const LinearGradient(
                            colors: [LT.coralLight, LT.violetLight],
                          ).createShader(const Rect.fromLTWH(0, 0, 200, 30)))),
                ])),
                const SizedBox(height: 28),
                Wrap(spacing: 16, runSpacing: 16, alignment: WrapAlignment.center,
                  children: [
                    _FastItem('F', context.l10n.landing_fastF, context.l10n.landing_fastFDesc, LT.coral),
                    _FastItem('A', context.l10n.landing_fastA, context.l10n.landing_fastADesc, LT.coralLight),
                    _FastItem('S', context.l10n.landing_fastS, context.l10n.landing_fastSDesc, LT.midBlend),
                    _FastItem('T', context.l10n.landing_fastT, context.l10n.landing_fastTDesc, LT.violetLight),
                  ].map((item) => SizedBox(
                    width: w > 800 ? (w - 48 - 48 - 48) / 4 : w > 500 ? (w - 48 - 16) / 2 : w - 48,
                    child: _FastCard(item: item),
                  )).toList(),
                ),
              ]),
            ),
          ]),
        )),
      ),

      // Coral-violet particle overlay
      Positioned.fill(
        child: IgnorePointer(
          child: AnimatedBuilder(
            animation: _particleCtrl,
            builder: (context, _) => CustomPaint(
              painter: _CoralVioletParticlePainter(t: _particleCtrl.value),
            ),
          ),
        ),
      ),
    ]);
  }
}

class _Stat {
  final int value; final String suffix, label; final Color color;
  const _Stat(this.value, this.suffix, this.label, this.color);
}

class _StatCard extends StatefulWidget {
  final _Stat stat; final double progress;
  const _StatCard({required this.stat, required this.progress});
  @override
  State<_StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<_StatCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final count = (widget.stat.value * widget.progress).toInt();
    final formatted = count > 999999
        ? '${(count / 1000000).toStringAsFixed(1)}M'
        : count > 999 ? '${(count / 1000).toStringAsFixed(0)}K' : count.toString();

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            widget.stat.color.withValues(alpha: _hovered ? 0.15 : 0.07),
            LT.violet.withValues(alpha: _hovered ? 0.1 : 0.04),
          ]),
          border: Border.all(color: _hovered
              ? widget.stat.color.withValues(alpha: 0.4)
              : widget.stat.color.withValues(alpha: 0.15)),
          borderRadius: BorderRadius.circular(20),
          boxShadow: _hovered ? [
            BoxShadow(color: widget.stat.color.withValues(alpha: 0.25), blurRadius: 30),
          ] : [],
        ),
        transform: Matrix4.identity()..translate(0.0, _hovered ? -4.0 : 0.0),
        child: Column(children: [
          ShaderMask(
            shaderCallback: (b) => LinearGradient(
              colors: [widget.stat.color, LT.violetLight],
            ).createShader(b),
            child: Text('$formatted${widget.stat.suffix}',
              style: GoogleFonts.outfit(fontSize: 38, fontWeight: FontWeight.w900,
                  color: Colors.white, letterSpacing: -1.5, height: 1)),
          ),
          const SizedBox(height: 10),
          Text(widget.stat.label, style: GoogleFonts.inter(
              fontSize: 13, color: Colors.white.withValues(alpha: 0.6), height: 1.5),
              textAlign: TextAlign.center),
        ]),
      ),
    );
  }
}

class _FastItem {
  final String letter, word, desc; final Color color;
  const _FastItem(this.letter, this.word, this.desc, this.color);
}

class _FastCard extends StatefulWidget {
  final _FastItem item;
  const _FastCard({required this.item});
  @override
  State<_FastCard> createState() => _FastCardState();
}

class _FastCardState extends State<_FastCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: _hovered ? LinearGradient(colors: [
            widget.item.color.withValues(alpha: 0.18),
            LT.violet.withValues(alpha: 0.1),
          ]) : null,
          color: _hovered ? null : Colors.white.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _hovered ? widget.item.color.withValues(alpha: 0.4) : Colors.transparent,
          ),
          boxShadow: _hovered ? [
            BoxShadow(color: widget.item.color.withValues(alpha: 0.2), blurRadius: 20),
          ] : [],
        ),
        child: Column(children: [
          ShaderMask(
            shaderCallback: (b) => LinearGradient(
              colors: [widget.item.color, LT.violetLight],
            ).createShader(b),
            child: Text(widget.item.letter, style: GoogleFonts.outfit(
                fontSize: 36, fontWeight: FontWeight.w900, color: Colors.white, height: 1)),
          ),
          const SizedBox(height: 6),
          Text(widget.item.word, style: GoogleFonts.inter(
              fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
          const SizedBox(height: 4),
          Text(widget.item.desc, style: GoogleFonts.inter(
              fontSize: 12, color: Colors.white.withValues(alpha: 0.55)),
              textAlign: TextAlign.center),
        ]),
      ),
    );
  }
}

class _CoralVioletParticlePainter extends CustomPainter {
  final double t;
  _CoralVioletParticlePainter({required this.t});

  @override
  void paint(Canvas canvas, Size size) {
    final rng = Random(42);
    final colors = [LT.coral, LT.coralLight, LT.midBlend, LT.violet, LT.violetLight];

    for (int i = 0; i < 30; i++) {
      final baseX = rng.nextDouble();
      final baseY = rng.nextDouble();
      final speed = 0.15 + rng.nextDouble() * 0.4;
      final sz = 1.0 + rng.nextDouble() * 2.5;
      final phase = rng.nextDouble() * 2 * pi;

      final angle = t * speed * 2 * pi + phase;
      final x = size.width * baseX + sin(angle) * 18;
      final y = size.height * baseY + cos(angle * 0.7) * 12;
      final alpha = (0.06 + 0.1 * sin(angle * 1.3)).clamp(0.02, 0.18);

      canvas.drawCircle(
        Offset(x, y), sz,
        Paint()..color = colors[i % colors.length].withValues(alpha: alpha),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _CoralVioletParticlePainter old) => old.t != t;
}
