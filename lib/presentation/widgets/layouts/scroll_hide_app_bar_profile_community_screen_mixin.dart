import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotted/config/constants/app_constants.dart';

mixin ScrollHideAppBarProfileCommunityScreenMixin<
  T extends ConsumerStatefulWidget
>
    on ConsumerState<T> {
  late final ScrollController scrollController;
  bool isScrollingDown = false;

  void _hideAppBar({bool hide = true}) {
    setState(() {
      isScrollingDown = hide;
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
    logger.i('Scroll direction: ${scrollController.position.pixels}');
    if (direction == ScrollDirection.reverse) {
      _hideAppBar(hide: true);
    } else if (direction == ScrollDirection.forward) {
      _hideAppBar(hide: false);
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
