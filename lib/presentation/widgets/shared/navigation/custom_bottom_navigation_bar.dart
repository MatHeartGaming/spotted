import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:spotted/config/config.dart';
import 'package:spotted/presentation/providers/providers.dart';

class CustomBottomNavigationBar extends ConsumerWidget {
  final int currentIndex;
  final TabController tabController;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.tabController,
  });

  void _onItemTapped(WidgetRef ref, int index) {
    final context = ref.context;
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
    final int unreadNotificatons = ref.watch(userNotificationUnreadProvider);

    return TabBar(
      isScrollable: false,
      controller: tabController,
      indicatorColor: Theme.of(context).colorScheme.primary,
      onTap: (index) => _onItemTapped(ref, index),
      tabs: [
        Tab(
          icon: const Icon(FontAwesomeIcons.house),
          text: 'nav_bar_home_item'.tr(),
        ),
        Tab(icon: const Icon(Icons.explore), text: 'nav_bar_explore_item'.tr()),
        Tab(
          icon: const Icon(FontAwesomeIcons.solidMessage),
          text: 'app_bar_chats_btn_tooltip'.tr(),
        ),
        Tab(
          icon: Badge.count(
            count: unreadNotificatons,
            isLabelVisible: unreadNotificatons > 0,
            child: const Icon(Icons.notifications, size: 35),
          ),
          text: 'app_bar_notifications_btn_tooltip'.tr(),
        ),
      ],
    );
  }
}
