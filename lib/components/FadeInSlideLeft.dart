import 'dart:core';

import 'package:flutter/material.dart';

class FadeInSlideLeft extends StatefulWidget {
  final Widget child;
  final Duration duration;

  const FadeInSlideLeft({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 600),
  });

  @override
  State<FadeInSlideLeft> createState() => _FadeInSlideLeftState();
}

class _FadeInSlideLeftState extends State<FadeInSlideLeft>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize the AnimationController
    _controller = AnimationController(vsync: this, duration: widget.duration);

    // Fade animation goes from completely transparent (0.0) to opaque (1.0)
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    // Slide animation goes from right offset (e.g., dx: 0.3) to original position (dx: 0.0)
    // This creates the visual effect of moving *towards the left*
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    // Start the animation immediately upon widget insertion
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose(); // Always clean up your animation controllers
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(position: _slideAnimation, child: widget.child),
    );
  }
}
