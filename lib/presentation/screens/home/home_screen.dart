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

  late final TabController _tabController;

  @override
  void initState() {
    super.initState();

    // TabController for two tabs
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.pageIndex,
    );

    Future.delayed(
      Duration.zero,
      () => ref
          .read(tabBarControllerProvider.notifier)
          .update((state) => _tabController),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final signedInUser =
        ref.watch(signedInUserProvider) ??
        User.empty(dateCreated: DateTime.now());
    final viewRoutes = [widget.homeView, widget.exploreView];
    final isVisible = ref.watch(tabBarVisibilityProvider);

    ref.listen<int>(bottomNavigationIndexProvider, (_, idx) {
      if (_tabController.index != idx) {
        _tabController.animateTo(idx);
      }
    });

    return Scaffold(
      drawerEnableOpenDragGesture: true,
      drawer: DrawerContent(user: signedInUser),

      // swipe‐able pages
      body: TabBarView(controller: _tabController, children: viewRoutes),
      bottomNavigationBar: AnimatedContainer(
        height: isVisible ? _barHeight : 0,
        duration: Duration(milliseconds: 300),
        child: SizedBox(
          height: _barHeight,
          child: Material(
            elevation: 8,
            child: CustomBottomNavigationBar(
              tabController: _tabController,
              currentIndex: widget.pageIndex,
            ),
          ),
        ),
      ),
    );
  }
}
