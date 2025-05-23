/// scroll_hide_mixin.dart
library;
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/widgets.dart';
import 'package:spotted/presentation/providers/providers.dart';

mixin ScrollHideTabBarBaseScreen<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  late final ScrollController scrollController;
  bool _isScrollingDown = false;

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
      ref.read(tabBarVisibilityProvider.notifier).state = false;
    } else if (direction == ScrollDirection.forward && _isScrollingDown) {
      _isScrollingDown = false;
      ref.read(tabBarVisibilityProvider.notifier).state = true;
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
