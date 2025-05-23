import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:spotted/config/config.dart';
import 'package:spotted/presentation/providers/providers.dart';

class CustomBottomNavigationBar extends ConsumerWidget {
  final int currentIndex;

  const CustomBottomNavigationBar({super.key, required this.currentIndex});

  void _onItemTapped(BuildContext context, WidgetRef ref, int index) {
    switch (index) {
      case 0:
        _updateIndex(ref, 0);
        context.go('$homePath/$index');
        break;
      case 1:
        _updateIndex(ref, 1);
        context.go('$homePath/$index');
        break;
    }
  }

  void _updateIndex(WidgetRef ref, int index) {
    ref.read(bottomNavigationIndexProvider.notifier).update((state) {
      state = index;
      return index;
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BottomNavigationBar(
      onTap: (index) => _onItemTapped(context, ref, index),
      currentIndex: currentIndex,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          label: "nav_bar_home_item".tr(),
          tooltip: "nav_bar_home_tooltip".tr(),
          icon: const Icon(FontAwesomeIcons.house),
        ),
        BottomNavigationBarItem(
          label: "nav_bar_explore_item".tr(),
          tooltip: "nav_bar_explore_tooltip".tr(),
          icon: const Icon(Icons.explore),
        ),
      ],
    );
  }
}
