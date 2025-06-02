// post_list_tile.dart
import 'package:flutter/material.dart';
import 'package:spotted/domain/models/post.dart';

class PostListTile extends StatelessWidget {
  final Post post;
  final VoidCallback? onTap;
  const PostListTile({super.key, required this.post, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.article),
      title: Text(post.title),
      subtitle: Text('by ${post.createdByUsername}'),
      onTap: onTap,
    );
  }
}
