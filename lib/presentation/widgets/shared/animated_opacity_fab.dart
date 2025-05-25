import 'package:flutter/material.dart';

class AnimatedOpacityFab extends StatelessWidget {
  final bool show;
  final Duration animationDuration;
  final Widget child;

  const AnimatedOpacityFab({
    super.key,
    this.show = true,
    required this.child,
    this.animationDuration = const Duration(milliseconds: 300),
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: show ? 1 : 0,
      duration: animationDuration,
      child: child,
    );
  }
}
