import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:spotted/presentation/screens/screens.dart';

class CreatePostOrCommunityScreen extends StatelessWidget {
  const CreatePostOrCommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton.filledTonal(
              tooltip: 'close_text'.tr(),
              onPressed: () => context.pop(),
              icon: Icon(Icons.close),
            ),
          ),
        ],
      ),
      body: Center(
        child: ListView(
          children: [
            ListTile(
              leading: Icon(Icons.post_add),
              title: Text('create_post_list_tile_title').tr(),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const CreatePostsScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(FontAwesomeIcons.peopleGroup),
              title: Text('create_community_list_tile_title').tr(),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const CreateCommunityScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
