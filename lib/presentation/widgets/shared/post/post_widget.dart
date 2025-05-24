import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spotted/domain/models/models.dart';
import 'package:spotted/presentation/widgets/widgets.dart';

/// A widget that displays a Post along with its author information.
class PostWidget extends StatelessWidget {
  final Post post;
  final User author;

  const PostWidget({super.key, required this.post, required this.author});

  @override
  Widget build(BuildContext context) {
    // Format the date
    final formattedDate = DateFormat.yMMMd().add_jm().format(post.dateCreated);
    final texts = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
              visible: post.postedIn != null,
              child: Text(post.postedIn ?? '', style: texts.labelLarge?.copyWith(color: colors.onPrimaryContainer),)
            ),
            SizedBox(height: 8),
            // Author row
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CirclePicture(
                  minRadius: 20,
                  maxRadius: 20,
                  urlPicture: author.profileImageUrl,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        author.completeName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        '@${author.username}',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Text(
                  formattedDate,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),

            // Title
            if (post.title.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(post.title, style: texts.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
            ],

            // Content
            const SizedBox(height: 8),
            Text(post.content, style: texts.bodySmall),

            // (Future) reactions/comments indicators
            // const SizedBox(height: 12),
            // Row(
            //   children: [
            //     Icon(Icons.comment, size: 16),
            //     SizedBox(width: 4),
            //     Text('${post.comments.length}'),
            //     SizedBox(width: 16),
            //     Icon(Icons.favorite_border, size: 16),
            //     SizedBox(width: 4),
            //     Text('${post.reactions.length}'),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
