import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rotation_three_d_effect/rotation_three_d_effect.dart';
import 'package:spotted/config/config.dart';
import 'package:spotted/presentation/widgets/widgets.dart';

Widget aboutDialogPage() {
  return Column(
    children: [
      const Text(
        "about_screen_developer_text",
        style: TextStyle(fontWeight: FontWeight.w400),
      ).tr(),
      const SizedBox(
        height: 10,
      ),
      Rotation3DEffect.limitedReturnsInPlace(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: CirclePicture(
              urlPicture: Environment.profilePicAboutDialog,
              width: 100,
              height: 100),
        ),
      ),
      const SizedBox(
        height: 10,
      ),
      Rotation3DEffect.limitedReturnsInPlace(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Matteo Buompastore",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
        ),
      ),
      const SizedBox(
        height: 10,
      ),
      const Text("about_screen_contacts_text").tr(),
      const SizedBox(
        height: 15,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _ContactButton(
            icon: FontAwesomeIcons.linkedinIn,
            iconSize: 30,
            onIconTapped: () => openUrl(linkedinPageURL),
          ),
          _ContactButton(
            icon: FontAwesomeIcons.github,
            iconSize: 30,
            onIconTapped: () => openUrl(githubPageURL),
          ),
          _ContactButton(
            icon: FontAwesomeIcons.stackOverflow,
            iconSize: 30,
            onIconTapped: () => openUrl(stackOverflowPageURL),
          ),
        ],
      ),
      const SizedBox(
        height: 10,
      ),
      TextButton.icon(
          onPressed: () => sendEmailTo(devEmail),
          icon: const Icon(Icons.email_outlined),
          label: const Text(devEmail)),
    ],
  );
}

class _ContactButton extends StatelessWidget {
  final IconData icon;
  final double iconSize;
  final Function onIconTapped;

  const _ContactButton(
      {required this.icon, required this.onIconTapped, required this.iconSize});

  @override
  Widget build(BuildContext context) {
    return IconButton.outlined(
      onPressed: () => onIconTapped(),
      icon: Icon(icon, size: iconSize),
    );
  }
}
