import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ReactionRowWidget extends StatelessWidget {
  final String? reaction; // e.g. "👍" or whatever emoji
  final String? reactionNumber; // e.g. "12"
  final String? commentNumber; // e.g. "4"
  final VoidCallback onLike;
  final VoidCallback onComment;
  final VoidCallback onShare;

  const ReactionRowWidget({
    super.key,
    this.reaction,
    this.commentNumber,
    this.reactionNumber,
    required this.onLike,
    required this.onComment,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    Widget buildButtonWithBadge({
      required Widget icon,
      required String? badge,
      required VoidCallback onPressed,
    }) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(icon: icon, onPressed: onPressed),
          if (badge != null && badge.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                badge,
                style: Theme.of(
                  context,
                ).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        // Like button (or reaction emoji)
        buildButtonWithBadge(
          onPressed: onLike,
          badge: reactionNumber,
          icon:
              reaction != null && reaction!.isNotEmpty
                  ? SlideInDown(
                    from: 20,
                    child: Text(
                      reaction!,
                      style: const TextStyle(fontSize: 24),
                    ),
                  )
                  : const Icon(FontAwesomeIcons.thumbsUp, size: 20),
        ),

        // Comment button
        buildButtonWithBadge(
          onPressed: onComment,
          badge: commentNumber,
          icon: const Icon(FontAwesomeIcons.comment, size: 20),
        ),

        // Share button (no badge)
        IconButton(
          onPressed: onShare,
          icon: const Icon(FontAwesomeIcons.share, size: 20),
        ),
      ],
    );
  }
}
