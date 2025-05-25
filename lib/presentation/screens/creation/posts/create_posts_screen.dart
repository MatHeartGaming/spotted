import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


class CreatePostsScreen extends StatelessWidget {

  static const name = 'CreatePostsScreen';

  const CreatePostsScreen({super.key});


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
        child: Text('Crea Post'),
     ),
   );
  }
}