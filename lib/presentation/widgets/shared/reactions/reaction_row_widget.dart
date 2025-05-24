import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ReactionRowWidget extends StatelessWidget {
  final bool isLiked;
  final VoidCallback onLike;
  final VoidCallback onComment;
  final VoidCallback onShare;

  const ReactionRowWidget({
    super.key,
    this.isLiked = false,
    required this.onLike,
    required this.onComment,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(
          onPressed: onLike,
          icon: Icon(
            isLiked
                ? FontAwesomeIcons.solidThumbsUp
                : FontAwesomeIcons.thumbsUp,
            size: 20,
          ),
        ),
        IconButton(
          onPressed: onComment,
          icon: Icon(FontAwesomeIcons.comment, size: 20),
        ),

        IconButton(
          onPressed: onShare,
          icon: Icon(FontAwesomeIcons.share, size: 20),
        ),
      ],
    );
  }
}
