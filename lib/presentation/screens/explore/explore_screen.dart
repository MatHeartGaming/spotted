import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotted/presentation/widgets/widgets.dart';

class ExploreScreen extends ConsumerWidget {
  static const name = 'ExploreScreen';

  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        body: Center(child: Text('Explore Screen')),
      ),
    );
  }
}
