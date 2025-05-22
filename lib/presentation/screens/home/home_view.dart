import 'package:flutter/material.dart';
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
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future _loadData() async {
    Future.delayed(Duration.zero, () async {
      /*final signedInUser = ref.read(signedInUserProvider);
      await ref
          .read(loadPostsProvider.notifier)
          .fetchAllSignedInuserPosts(username: signedInUser?.username ?? '');*/
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final signedInUser = ref.watch(signedInUserProvider);
    return SafeArea(
      child: Scaffold(
        floatingActionButton: null,
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
          onRefresh: () => _loadData(),
          child: ListView.builder(
            itemCount: 10,
            //prototypeItem: PostWidget(post: Post.empty()),
            itemBuilder: (context, index) {
              return Text('Post $index');
            },
          ),
        ),
      ),
    );
  }
}
