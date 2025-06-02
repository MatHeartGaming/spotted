// user_list_tile.dart
import 'package:flutter/material.dart';
import 'package:spotted/domain/models/models.dart';
import 'package:spotted/presentation/widgets/widgets.dart';

class UserListTile extends StatelessWidget {
  final User user;
  final VoidCallback? onTap;
  const UserListTile({super.key, required this.user, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CirclePicture(
        urlPicture: user.profileImageUrl,
        minRadius: 20,
        maxRadius: 20,
      ),
      title: Text(user.username),
      subtitle: Text('${user.name} ${user.surname}'),
      onTap: onTap,
    );
  }
}
