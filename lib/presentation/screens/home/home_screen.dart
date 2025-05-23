import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotted/domain/models/models.dart';
import 'package:spotted/presentation/providers/providers.dart';
import 'package:spotted/presentation/widgets/widgets.dart';

class HomeScreen extends ConsumerStatefulWidget {
  final int pageIndex;
  final Widget homeView;
  final Widget exploreView;

  static const name = 'HomeScreen';

  const HomeScreen({
    super.key,
    required this.pageIndex,
    required this.homeView,
    required this.exploreView,
  });

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  static const double _barHeight = 92.0;

  late final AnimationController _controller;
  late final Animation<double> _heightFactor;

  @override
  void initState() {
    super.initState();

    // 1) AnimationController for a 300 ms slide
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    // 2) A curved animation for smooth easeInOut
    _heightFactor = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    // 3) Initialize based on current provider state
    final isVisible = ref.read(tabBarVisibilityProvider);
    _controller.value = isVisible ? 1 : 0;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 4) Listen for visibility changes and forward/reverse
    ref.listen<bool>(tabBarVisibilityProvider, (prev, next) {
      if (next) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
    final signedInUser =
        ref.watch(signedInUserProvider) ??
        User.empty(dateCreated: DateTime.now());

    final viewRoutes = [widget.homeView, widget.exploreView];

    return Scaffold(
      drawerEnableOpenDragGesture: true,
      drawer: DrawerContent(user: signedInUser),
      body: IndexedStack(index: widget.pageIndex, children: viewRoutes),

      // Animate height via SizeTransition—acts as a ClipRect so no overflow
      bottomNavigationBar: SizeTransition(
        sizeFactor: _heightFactor,
        axisAlignment: 1.0, // anchor to bottom
        child: SizedBox(
          height: _barHeight,
          child: CustomBottomNavigationBar(currentIndex: widget.pageIndex),
        ),
      ),
    );
  }
}
