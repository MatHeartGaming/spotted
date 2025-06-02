import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:spotted/domain/models/models.dart';
import 'package:spotted/presentation/widgets/widgets.dart';

class CommentTile extends StatelessWidget {
  final Comment comment;
  final String? userProfilePicUrl;
  const CommentTile({super.key, required this.comment, this.userProfilePicUrl});

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
          // 1) (Optional) You might put a user avatar or placeholder circle here.
          //const CircleAvatar(radius: 16, child: Icon(Icons.person, size: 16)),
          CirclePicture(
            minRadius: 18,
            maxRadius: 18,
            urlPicture: userProfilePicUrl ?? '',
          ),
          const SizedBox(width: 8),

          // 2) Author name + timestamp + comment body
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Author + date
                Row(
                  children: [
                    Text(
                      comment.createdByUsername,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      formattedDate,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                // Comment body (text)
                Text(comment.text, style: const TextStyle(fontSize: 14)),

                // ─ You could add “Reply” or reaction icons here if desired ─
                // For now, we leave it simple.
              ],
            ),
          ),
        ],
      ),
    );
  }
}
