import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:spotted/config/config.dart';
import 'package:spotted/domain/models/models.dart';
import 'package:spotted/presentation/providers/providers.dart';
import 'package:spotted/presentation/screens/screens.dart';
import 'package:spotted/presentation/widgets/widgets.dart';

class DrawerContent extends ConsumerWidget {
  final UserModel user;

  const DrawerContent({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signedInUser = ref.watch(signedInUserProvider);
    final isDarkMode = ref.watch(isDarkModeProvider);
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          signedInUser == null
              ? SafeArea(
                child: ZoomIn(
                  child: TextButton(
                    onPressed: () {
                      /*final loginProvider = ref.read(loginSignupProvider);
                        loginProvider.logout().then(
                        (value) => loginProvider.login(),
                      );*/
                      //loginProvider.login();
                      //pushToLoginSignupScreen(context);
                    },
                    child: Text('login_text').tr(),
                  ),
                ),
              )
              : DrawerHeader(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CirclePicture(
                          urlPicture:
                              user.isProfileUrlValid
                                  ? user.profileImageUrl
                                  : '',
                          minRadius: 20,
                          maxRadius: 20,
                        ),

                        TextButton.icon(
                          onPressed: () => _logout(ref),
                          label: Row(
                            spacing: 5,
                            children: [
                              Text(
                                "logout_text",
                                style: TextStyle(color: colorNotOkButton),
                              ).tr(),
                              Icon(
                                Icons.logout_outlined,
                                color: colorNotOkButton,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Text(
                      user.completeName,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      user.username,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        showCustomBottomSheet(
                          context,
                          child: FriendsListScreen(
                            onUserDeleted:
                                (userToDeleteRef) =>
                                    _onUserDeletedAction(ref, userToDeleteRef),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(10),
                      child: Text(
                        'drawer_following_count',
                      ).tr(args: [user.friends.isEmpty ? '0' : '${user.friends.length - 1}']),
                    ),
                  ],
                ),
              ),

          // Expanding the list of menu items to push the toggle button to the bottom
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children:
                  getDrawerItems(profileId: signedInUser?.id ?? '')
                      .map(
                        (item) => SlideInLeft(
                          child: ListTile(
                            leading: Icon(item.icon),
                            title: Text(
                              item.title,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            onTap: () => _navigateToSelectedItem(ref, item),
                          ),
                        ),
                      )
                      .toList(),
            ),
          ),

          // Align the toggle button at the bottom left
          Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 20),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: IconButton(
                onPressed: () {
                  final isDark =
                      ref.read(themeNotifierProvider.notifier).toggleDarkmode();
                  ref
                      .read(isDarkModeProvider.notifier)
                      .update((state) => isDark);
                },
                icon:
                    isDarkMode
                        ? FadeIn(child: Icon(Icons.light_mode))
                        : FadeIn(child: Icon(Icons.dark_mode)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToSelectedItem(WidgetRef ref, DrawerItem item) {
    final context = ref.context;
    Navigator.of(context).pop(); // Closes the drawer first

    if (item.path.startsWith(homePath)) {
      //context.replace(item.path);
      final homeIndex = item.path.split('/');
      final indexToUse = int.tryParse(homeIndex[2]) ?? 0;
      ref.read(tabBarControllerProvider)?.animateTo(indexToUse);

      return;
    }
    context.push(item.path);
  }

  void _onUserDeletedAction(WidgetRef ref, String friendRef) {
    final signedInUser = ref.read(signedInUserProvider);
    if (signedInUser == null) return;

    ref
        .read(loadSignedInFriendsProvider.notifier)
        .addOrRemoveSignedInUserFriend(friendRef)
        .then((tuple) {
          // tuple.$1 is the updated User returned from your repository,
          // tuple.$2 is the bool “isAdd”/“isRemoved” flag you returned.
          final updatedUser = tuple.$1;
          ref.read(signedInUserProvider.notifier).update((_) => updatedUser!);

          // Optionally reload posts (if you want).
          final loadPostsNotifier = ref.read(loadPostsProvider.notifier);
          loadPostsNotifier.loadPostedByMe();
          loadPostsNotifier.loadPostedByFriendsId();
        });
  }

  void _logout(WidgetRef ref) {
    final colors = Theme.of(ref.context).colorScheme;
    showStandardCustomDialog(
      ref.context,
      title: "logout_text".tr(),
      message: "home_screen_logout_alert_msg".tr(),
      isDestructive: true,
      okButtonColor: colors.error,
      onOkPressed: () async {
        await ref.read(authStatusProvider.notifier).logout().then((_) {
          ref.read(signedInUserProvider.notifier).update((state) => null);
          if (!ref.context.mounted) return;
          showCustomSnackbar(
            ref.context,
            'home_screen_logout_success_snackbar'.tr(),
          );
        });
      },
    );
  }
}
