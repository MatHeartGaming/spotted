import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotted/presentation/providers/providers.dart';
import 'package:spotted/presentation/widgets/widgets.dart';

class HomeView extends ConsumerStatefulWidget {
  static const name = 'HomeView';

  const HomeView({super.key});

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends ConsumerState<HomeView> {
  late final ScrollController _scrollController;
  bool _isScrollingDown = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    _loadData();
  }

  void _onScroll() {
    final direction = _scrollController.position.userScrollDirection;

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
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  Future _loadData() async {
    Future.delayed(Duration.zero, () async {
      // Load your data here
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(size.width, 50),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: HomeAppBar(
              onProfileIconPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: _loadData,
          child: ListView.builder(
            controller: _scrollController,
            itemCount: 1000,
            itemBuilder: (context, index) {
              return Text('Post $index');
            },
          ),
        ),
      ),
    );
  }
}
