import 'package:flutter/material.dart';
import 'package:flutter_chat_reactions/flutter_chat_reactions.dart';
import 'package:flutter_chat_reactions/utilities/hero_dialog_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotted/config/config.dart';
import 'package:spotted/domain/models/models.dart';
import 'package:spotted/presentation/widgets/shared/post/post_widget.dart';
import 'package:spotted/presentation/widgets/widgets.dart';

class ReactionablePostWidget extends ConsumerWidget {
  final Post post;
  final User author;

  const ReactionablePostWidget({
    super.key,
    required this.post,
    required this.author,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Hero(
      tag: post.id,
      child: GestureDetector(
        // wrap your message widget with a [GestureDectector] or [InkWell]
        onLongPress: () {
          // navigate with a custom [HeroDialogRoute] to [ReactionsDialogWidget]
          Navigator.of(context).push(
            HeroDialogRoute(
              builder: (context) {
                return ReactionsDialogWidget(
                  id: post.id, // unique id for message
                  messageWidget: PostWidget(post: post, author: author),
                  onReactionTap: (reaction) {
                    logger.i('reaction: $reaction');

                    if (reaction == '➕') {
                      // show emoji picker container
                    } else {
                      // add reaction to message
                    }
                  },
                  onContextMenuTap: (menuItem) {
                    logger.i('menu item: $menuItem');
                    post.reactions.addAll({
                      post.createdByUsername: menuItem.label,
                    });
                    // handle context menu item
                  },
                );
              },
            ),
          );
        },
        child: Stack(
          children: [
            PostWidget(post: post, author: author),
            // reactions
            Positioned(
              bottom: 4,
              right: 20,
              child: StackedReactions(
                reactions: post.reactions.values.toList(),
                stackedValue: 16, // Value used to calculate the horizontal offset of each reaction
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StackedReactions extends StatelessWidget {
  final List<String> reactions;
  final double stackedValue;
  final double size;

  const StackedReactions({
    super.key,
    required this.reactions,
    required this.stackedValue,
    this.size = 24.0, // diameter of each emoji circle
  });

  @override
  Widget build(BuildContext context) {
    final topEmojis = getTopReactions(reactions, count: 3);
    if (topEmojis.isEmpty) return const SizedBox();

    // 4) Build overlapping stack
    return SizedBox(
      width: size + stackedValue * (topEmojis.length - 1),
      height: size,
      child: Stack(
        children: [
          for (int i = 0; i < topEmojis.length; i++)
            Positioned(
              left: i * stackedValue,
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade300, width: 1),
                ),
                alignment: Alignment.center,
                child: Text(
                  topEmojis[i],
                  style: TextStyle(fontSize: size * 0.6),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
