import 'dart:math';
import 'package:flutter/material.dart';

enum AnimationEffect {
  fadeIn,
  fadeOut,

  slideLeft,
  slideRight,
  slideUp,
  slideDown,

  scaleIn,
  scaleOut,

  flipX,
  flipY,

  rotate,

  bounce,
}

class SimpleAnimationComponent extends StatefulWidget {
  final Widget child;

  final List<AnimationEffect> effects;

  final Duration duration;
  final Duration delay;

  final Curve curve;

  final bool repeat;

  const SimpleAnimationComponent({
    super.key,
    required this.child,
    this.effects = const [AnimationEffect.fadeIn],
    this.duration = const Duration(milliseconds: 600),
    this.delay = Duration.zero,
    this.curve = Curves.easeOut,
    this.repeat = false,
  });

  @override
  State<SimpleAnimationComponent> createState() =>
      _SimpleAnimationComponentState();
}

class _SimpleAnimationComponentState extends State<SimpleAnimationComponent>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(vsync: this, duration: widget.duration);

    Future.delayed(widget.delay, () {
      if (!mounted) return;

      if (widget.repeat) {
        controller.repeat(reverse: true);
      } else {
        controller.forward();
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  bool has(AnimationEffect e) => widget.effects.contains(e);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: CurvedAnimation(parent: controller, curve: widget.curve),
      builder: (_, child) {
        double t = controller.value;

        //--------------------------------
        // OPACITY
        //--------------------------------

        double opacity = 1;

        if (has(AnimationEffect.fadeIn)) {
          opacity *= t;
        }

        if (has(AnimationEffect.fadeOut)) {
          opacity *= (1 - t);
        }

        //--------------------------------
        // TRANSLATE
        //--------------------------------

        Offset offset = Offset.zero;

        const distance = 80.0;

        if (has(AnimationEffect.slideLeft)) {
          offset += Offset((1 - t) * distance, 0);
        }

        if (has(AnimationEffect.slideRight)) {
          offset += Offset(-(1 - t) * distance, 0);
        }

        if (has(AnimationEffect.slideUp)) {
          offset += Offset(0, (1 - t) * distance);
        }

        if (has(AnimationEffect.slideDown)) {
          offset += Offset(0, -(1 - t) * distance);
        }

        //--------------------------------
        // SCALE
        //--------------------------------

        double scale = 1;

        if (has(AnimationEffect.scaleIn)) {
          scale *= .7 + (.3 * t);
        }

        if (has(AnimationEffect.scaleOut)) {
          scale *= 1 - (.3 * t);
        }

        //--------------------------------
        // ROTATION
        //--------------------------------

        double rotation = 0;

        if (has(AnimationEffect.rotate)) {
          rotation += (1 - t) * .4;
        }

        //--------------------------------
        // FLIP
        //--------------------------------

        Matrix4 matrix = Matrix4.identity();

        if (has(AnimationEffect.flipX)) {
          matrix.rotateX(pi * (1 - t));
        }

        if (has(AnimationEffect.flipY)) {
          matrix.rotateY(pi * (1 - t));
        }

        //--------------------------------
        // BOUNCE
        //--------------------------------

        if (has(AnimationEffect.bounce)) {
          final bounce = sin(t * pi * 3) * (1 - t) * 15;

          offset += Offset(0, -bounce);
        }

        matrix.translate(offset.dx, offset.dy);

        matrix.rotateZ(rotation);

        matrix.scale(scale);

        return Opacity(
          opacity: opacity.clamp(0.0, 1.0),
          child: Transform(
            alignment: Alignment.center,
            transform: matrix,
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}
