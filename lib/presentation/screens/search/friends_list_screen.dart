import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:spotted/domain/models/models.dart';
import 'package:spotted/presentation/navigation/navigation.dart';
import 'package:spotted/presentation/providers/providers.dart';
import 'package:spotted/presentation/widgets/shared/custom_dialogs.dart';
import 'package:spotted/presentation/widgets/shared/user/user_info_row.dart';

class FriendsListScreen extends ConsumerWidget {
  final List<UserModel> users;
  final void Function(String)? onUserDeleted;

  const FriendsListScreen({
    super.key,
    required this.users,
    required this.onUserDeleted,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// 1) Who is the signed‐in user?
    final signedInUser = ref.watch(signedInUserProvider);
    if (signedInUser == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text('friends_screen_no_user_logged_in_text').tr()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('friends_screen_title').tr()),
      body:
          users.isEmpty
              ? Center(child: Text('friends_screen_no_friends').tr())
              : ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                itemCount: users.length,
                prototypeItem: _prototypeUserInfoRow(),
                itemBuilder: (context, index) {
                  final user = users[index];
                  final child = UserInfoRow(
                    onTap: () => pushToProfileScreen(context, user: user),
                    user: user,
                  );
                  if (onUserDeleted == null) {
                    return child;
                  }
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
                      var shouldDelete = false;
                      await showStandardCustomDialog(
                        context,
                        barrierColor: Theme.of(
                          context,
                        ).colorScheme.error.withAlpha(30),
                        okButtonColor: Colors.red[400]!,
                        isDestructive: true,
                        title:
                            'friends_screen_confirm_delete_friend_dialog_title'
                                .tr(),
                        message:
                            'friends_screen_confirm_delete_friend_dialog_message'
                                .tr(args: [user.username]),
                        onOkPressed: () => shouldDelete = true,
                      );
                      return shouldDelete;
                    },
                    onDismissed: (direction) {
                      onUserDeleted?.call(user.id);
                    },
                    child: child,
                  );
                },
              ),
    );
  }

  Widget _prototypeUserInfoRow() => SizedBox(
    height: 60,
    child: UserInfoRow(onTap: () {}, user: UserModel.empty()),
  );
}
