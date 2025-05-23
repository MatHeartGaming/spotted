import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:spotted/config/constants/app_constants.dart';

import '../../presentation/screens/screens.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  //final goRouterNotifier = ref.watch(goRouterNotifierProvider);
  //final authUserState = ref.watch(authStatusProvider);
  return GoRouter(
    initialLocation: basePath,
    routes: [
      GoRoute(
        name: LoadingScreen.name,
        path: loadingPath,
        builder: (context, state) => const LoadingScreen(),
      ),

      GoRoute(
        name: SettingsListScreen.name,
        path: settingsListPath,
        builder: (context, state) => const SettingsListScreen(),
      ),

      GoRoute(
        name: ProfileScreen.name,
        path: profilePath,
        builder: (context, state) => const ProfileScreen(),
      ),

      GoRoute(
        name: ChatsScreen.name,
        path: chatsPath,
        builder: (context, state) => const ChatsScreen(),
      ),

      GoRoute(
        name: HomeScreen.name,
        path: '$homePath/:page',
        builder: (context, state) {
          final pageIndex = state.pathParameters['page'] ?? '0';
          return HomeScreen(
            pageIndex: int.parse(pageIndex),
            homeView: HomeView(),
            exploreView: ExploreScreen(),
          );
        },
      ),
      GoRoute(path: '/', redirect: (_, __) => basePath),
    ],
    redirect: (context, state) {
      final isGoingTo = state.matchedLocation;
      if (isGoingTo == basePath) {
        return '$homePath/0';
      }

      return isGoingTo;
    },
  );
});
