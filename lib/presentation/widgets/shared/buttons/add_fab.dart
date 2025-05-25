import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AddFab extends StatelessWidget {
  final int heroTag;
  final String? tooltip;
  final VoidCallback onTap;

  const AddFab({super.key, required this.onTap, required this.heroTag, this.tooltip});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: heroTag,
      onPressed: onTap,
      tooltip: tooltip,
      child: Icon(FontAwesomeIcons.plus),
    );
  }
}
