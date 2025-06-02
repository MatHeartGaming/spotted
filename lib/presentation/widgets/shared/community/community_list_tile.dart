// community_list_tile.dart
import 'package:flutter/material.dart';
import 'package:spotted/domain/models/models.dart';

class CommunityListTile extends StatelessWidget {
  final Community community;
  final VoidCallback? onTap;
  const CommunityListTile({super.key, required this.community, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage:
            community.pictureUrl != null
                ? NetworkImage(community.pictureUrl!)
                : null,
        child: community.pictureUrl == null ? const Icon(Icons.group) : null,
      ),
      title: Text(community.title),
      subtitle: Text(community.description),
      onTap: onTap,
    );
  }
}
