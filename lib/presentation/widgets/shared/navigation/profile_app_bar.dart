import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:spotted/config/constants/app_constants.dart';

class ProfileAppBar extends StatelessWidget {
  final VoidCallback onBackTapped;
  final VoidCallback onMessageTapped;
  final bool showAnonymousChatButton;

  const ProfileAppBar({
    super.key,
    required this.onBackTapped,
    required this.onMessageTapped,
    this.showAnonymousChatButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton.filledTonal(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBackTapped,
        ),
        if (showAnonymousChatButton)
          IconButton.filledTonal(
            tooltip: 'chats_screen_app_bar_start_anonymous_chat_tooltip'.tr(),
            icon: const Icon(anonymousIcon),
            onPressed: onMessageTapped,
          ),
      ],
    );
  }
}
