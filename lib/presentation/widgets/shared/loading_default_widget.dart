import 'package:flutter/material.dart';

class LoadingDefaultWidget extends StatelessWidget {
  final double width;
  final double height;

  const LoadingDefaultWidget({
    super.key,
    this.width = 60,
    this.height = 60,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: width,
        height: height,
        child: const Center(child: CircularProgressIndicator.adaptive()));
  }
}
