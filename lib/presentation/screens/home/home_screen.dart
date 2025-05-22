
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

class HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final signedInUser = ref.watch(signedInUserProvider);
    List<Widget> viewRoutes = [
      widget.homeView,
      widget.exploreView,
    ];
    return Scaffold(
      drawerEnableOpenDragGesture: true,
      drawer: DrawerContent(
        user: signedInUser ?? User.empty(dateCreated: DateTime.now()),
      ),
      body: IndexedStack(index: widget.pageIndex, children: viewRoutes),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: widget.pageIndex,
      ),
    );
  }
}
