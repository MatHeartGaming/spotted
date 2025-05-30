import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:spotted/domain/models/models.dart';
import 'package:spotted/presentation/navigation/navigation.dart';
import 'package:spotted/presentation/widgets/shared/custom_dialogs.dart';
import 'package:spotted/presentation/widgets/shared/user/user_info_row.dart';

class FriendsListScreen extends ConsumerWidget {
  final List<User> users;
  final Function(String) onUserDeleted;

  const FriendsListScreen({super.key, required this.users, required this.onUserDeleted});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(),
      body: ListView.builder(
        itemCount: users.length,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        prototypeItem: prorotypeUserInfoRow(),
        itemBuilder: (context, index) {
          final user = users[index];
          return Dismissible(
            key: Key(user.id),
            behavior: HitTestBehavior.translucent,
            direction: DismissDirection.endToStart,
            background: Container(
              padding: const EdgeInsets.only(right: 20),
              color: Colors.red,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [Icon(FontAwesomeIcons.userXmark)],
              ),
            ),
            confirmDismiss: (direction) async {
              bool delete = false;
              await showStandardCustomDialog(
                context,
                barrierColor: colors.error.withValues(alpha: 0.3),
                okButtonColor: Colors.red[400]!,
                title: 'friends_screen_confirm_delete_friend_dialog_title'.tr(),
                message: 'friends_screen_confirm_delete_friend_dialog_message'
                    .tr(args: [user.username]),
                onOkPressed: () async => delete = true,
              );
              return delete;
            },
            onDismissed: (direction) {
              onUserDeleted(user.id);
            },
            child: UserInfoRow(
              onTap: () => pushToProfileScreen(context, user: user),
              user: user,
            ),
          );
        },
      ),
    );
  }

  SizedBox prorotypeUserInfoRow() => SizedBox(
    height: 60,
    child: UserInfoRow(onTap: () {}, user: User.empty()),
  );
}
