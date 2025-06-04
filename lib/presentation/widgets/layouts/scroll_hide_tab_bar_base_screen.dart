/// scroll_hide_mixin.dart
library;

import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/widgets.dart';
import 'package:spotted/presentation/providers/providers.dart';

mixin ScrollHideTabBarBaseScreen<T extends ConsumerStatefulWidget>
    on ConsumerState<T> {
  late final ScrollController scrollController;
  bool _isScrollingDown = false;
  bool animateFabsOut = true;

  void _hideFab({bool hide = true}) {
    /*ref.read(showSeachBarProvider.notifier).update(
          (state) => false,
        );*/
    setState(() {
      animateFabsOut = hide;
    });
  }

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final direction = scrollController.position.userScrollDirection;
    if (direction == ScrollDirection.reverse && !_isScrollingDown) {
      _isScrollingDown = true;
      if (animateFabsOut) _hideFab(hide: false);
      ref.read(tabBarVisibilityProvider.notifier).state = false;
      ref.read(appBarVisibilityProvider.notifier).state = true;
    } else if (direction == ScrollDirection.forward && _isScrollingDown) {
      _isScrollingDown = false;
      if (!animateFabsOut) _hideFab(hide: true);
      ref.read(tabBarVisibilityProvider.notifier).state = true;
      ref.read(appBarVisibilityProvider.notifier).state = false;
    }
  }

  @override
  void dispose() {
    scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }
}
