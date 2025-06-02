import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:spotted/presentation/providers/providers.dart';
import 'package:spotted/presentation/widgets/widgets.dart';

class HomeAppBar extends ConsumerWidget {
  final VoidCallback? onProfileIconPressed;
  final VoidCallback? onSearchPressed;

  const HomeAppBar({super.key, this.onProfileIconPressed, this.onSearchPressed});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signedInUser = ref.watch(signedInUserProvider);
    final texts = TextTheme.of(context);
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
        Text('app_name', style: texts.titleLarge).tr(),
        Row(
          children: [
            IconButton(
              tooltip: 'app_bar_search_btn_tooltip'.tr(),
              onPressed: onSearchPressed,
              icon: Icon(FontAwesomeIcons.magnifyingGlass),
            ),
          ],
        ),
      ],
    );
  }
}
