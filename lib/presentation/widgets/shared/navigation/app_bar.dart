import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:spotted/presentation/providers/providers.dart';
import 'package:spotted/presentation/widgets/widgets.dart';

class HomeAppBar extends ConsumerWidget {
  final VoidCallback? onProfileIconPressed;

  const HomeAppBar({super.key, this.onProfileIconPressed});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signedInUser = ref.watch(signedInUserProvider);
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: onProfileIconPressed,
          child: CirclePicture(
            urlPicture: signedInUser?.profileImageUrl ?? '',
            minRadius: 10,
            maxRadius: 15,
          ),
        ),
        Icon(FontAwesomeIcons.twitter),
        Icon(FontAwesomeIcons.gear),
      ],
    );
  }
}
