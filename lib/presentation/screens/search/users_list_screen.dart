import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotted/domain/models/models.dart';
import 'package:spotted/presentation/navigation/navigation.dart';
import 'package:spotted/presentation/widgets/shared/user/user_info_row.dart';

class UsersListScreen extends ConsumerWidget {
  final List<UserModel> users;

  const UsersListScreen({
    super.key,
    required this.users,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView.builder(
        itemCount: users.length,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        prototypeItem: prorotypeUserInfoRow(),
        itemBuilder: (context, index) {
          final user = users[index];
          return UserInfoRow(
            onTap: () => pushToProfileScreen(context, user: user),
            user: user,
          );
        },
      ),
    );
  }

  SizedBox prorotypeUserInfoRow() => SizedBox(
    height: 60,
    child: UserInfoRow(onTap: () {}, user: UserModel.empty()),
  );
}
