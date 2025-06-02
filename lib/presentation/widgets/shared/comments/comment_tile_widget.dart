import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:spotted/config/config.dart';
import 'package:spotted/domain/models/models.dart';
import 'package:spotted/presentation/widgets/widgets.dart';

class CommentTile extends StatelessWidget {
  final Comment comment;
  final String? userProfilePicUrl;
  final VoidCallback? onUserInfoTapped;

  // NEW:
  final bool isOwnComment;
  final VoidCallback? onEditPressed;
  final VoidCallback? onDeletePressed;

  const CommentTile({
    super.key,
    required this.comment,
    this.userProfilePicUrl,
    this.onUserInfoTapped,
    // NEW:
    this.isOwnComment = false,
    this.onEditPressed,
    this.onDeletePressed,
  });

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat.yMMMd().add_jm().format(
      comment.dateCreated,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1) Avatar or anonymous icon:
          comment.createdById == anonymousText
              ? Icon(anonymousIcon)
              : GestureDetector(
                onTap: onUserInfoTapped,
                child: CirclePicture(
                  minRadius: 18,
                  maxRadius: 18,
                  urlPicture: userProfilePicUrl ?? '',
                ),
              ),
          const SizedBox(width: 8),

          // 2) Author name + timestamp + body
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Author + date
                GestureDetector(
                  onDoubleTap: onUserInfoTapped,
                  child: Row(
                    children: [
                      Text(
                        comment.createdByUsername,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        formattedDate,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 4),

                // Body text
                Text(comment.text, style: const TextStyle(fontSize: 14)),
              ],
            ),
          ),

          // 3) If this is *your* comment, show the “vertical dots” menu
          if (isOwnComment)
            PopupMenuButton<_CommentAction>(
              onSelected: (action) {
                switch (action) {
                  case _CommentAction.edit:
                    if (onEditPressed != null) onEditPressed!();
                    break;
                  case _CommentAction.delete:
                    if (onDeletePressed != null) onDeletePressed!();
                    break;
                }
              },
              itemBuilder:
                  (context) => [
                    PopupMenuItem(
                      value: _CommentAction.edit,
                      child: Text('edit_text').tr(),
                    ),
                    PopupMenuItem(
                      value: _CommentAction.delete,
                      child: Text('delete_text').tr(),
                    ),
                  ],
              icon: const Icon(Icons.more_vert, size: 20),
            ),
        ],
      ),
    );
  }
}

/// A little enum so we know what the popup menu tapped:
enum _CommentAction { edit, delete }
