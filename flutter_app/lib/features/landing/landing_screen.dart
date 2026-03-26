// Stroke Mitra - Landing Screen
// Full marketing landing page with scroll-triggered animations.

import 'package:flutter/material.dart';
import 'widgets/hero_section.dart';
import 'widgets/what_is_section.dart';
import 'widgets/how_it_works_section.dart';
import 'widgets/features_section.dart';
import 'widgets/stats_section.dart';
import 'widgets/cta_section.dart';
import 'widgets/landing_footer.dart';
import 'widgets/landing_nav.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});
  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final ScrollController _scrollCtrl = ScrollController();
  double _scrollOffset = 0;

  @override
  void initState() {
    super.initState();
    _scrollCtrl.addListener(_onScroll);
  }

  void _onScroll() {
    setState(() => _scrollOffset = _scrollCtrl.offset);
  }

  @override
  void dispose() {
    _scrollCtrl.removeListener(_onScroll);
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollCtrl,
            child: Column(
              children: [
                const HeroSection(),
                _ScrollReveal(scrollOffset: _scrollOffset, triggerOffset: 300, child: const WhatIsSection()),
                _ScrollReveal(scrollOffset: _scrollOffset, triggerOffset: 800, child: const HowItWorksSection()),
                _ScrollReveal(scrollOffset: _scrollOffset, triggerOffset: 1400, child: const FeaturesSection()),
                StatsSection(scrollOffset: _scrollOffset),
                _ScrollReveal(scrollOffset: _scrollOffset, triggerOffset: 2800, child: const CTASection()),
                const LandingFooter(),
              ],
            ),
          ),
          LandingNav(scrollOffset: _scrollOffset),
        ],
      ),
    );
  }
}

/// Wraps a child and animates it in when the scroll reaches the trigger offset.
class _ScrollReveal extends StatelessWidget {
  final double scrollOffset;
  final double triggerOffset;
  final Widget child;

  const _ScrollReveal({
    required this.scrollOffset,
    required this.triggerOffset,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final progress = ((scrollOffset - triggerOffset + 400) / 400).clamp(0.0, 1.0);
    final curved = Curves.easeOutCubic.transform(progress);

    return AnimatedOpacity(
      opacity: curved,
      duration: const Duration(milliseconds: 100),
      child: Transform.translate(
        offset: Offset(0, 30 * (1 - curved)),
        child: child,
      ),
    );
  }
}
