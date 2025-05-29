
import 'package:flutter/material.dart';

class ProfileAppBar extends StatelessWidget {

  final VoidCallback onBackTapped;
  final VoidCallback onMessageTapped;

  const ProfileAppBar({super.key, required this.onBackTapped, required this.onMessageTapped});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton.filledTonal(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBackTapped,
        ),
        IconButton.filledTonal(
          icon: const Icon(Icons.message),
          onPressed: onMessageTapped,
        ),
      ],
    );
  }
}