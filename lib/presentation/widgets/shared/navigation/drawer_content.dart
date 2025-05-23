import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:spotted/config/config.dart';
import 'package:spotted/domain/models/models.dart';
import 'package:spotted/presentation/providers/providers.dart';
import 'package:spotted/presentation/widgets/widgets.dart';

class DrawerContent extends ConsumerWidget {
  final User user;

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
                        IconButton(
                          onPressed: () {},
                          icon: Icon(FontAwesomeIcons.gears),
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
                    Text(
                      'drawer_following_count',
                    ).tr(args: ['${user.communitiesSubs.length}']),
                  ],
                ),
              ),

          // Expanding the list of menu items to push the toggle button to the bottom
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children:
                  getDrawerItems()
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
                            onTap: () => _navigateToSelectedItem(context, item),
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

  void _navigateToSelectedItem(BuildContext context, DrawerItem item) {
    Navigator.of(context).pop(); // Closes the drawer first

    if (item.path.startsWith(homePath)) {
      context.replace(item.path);
      return;
    }
    context.push(item.path);
  }
}
