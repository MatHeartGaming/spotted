import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:spotted/config/constants/app_constants.dart';
import 'package:spotted/domain/models/models.dart';

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
        name: ProfileHandlerScreen.name,
        path: '$profilePath/:userId',
        builder: (context, state) {
          Map<String, dynamic>? mapExtras =
              state.extra as Map<String, dynamic>?;
          String? id =
              state.pathParameters.containsKey('userId')
                  ? state.pathParameters['userId'].toString()
                  : 'no-id';
            logger.i('Zoccolone id: $id');

          if (id == 'no-id') {
            User? user = mapExtras?['user'];
            String? username = mapExtras?['username'];
            logger.i('Zoccolone username: $username');
            if (user == null && username == null) {
              final errorMsg = 'error_texts_no_product_or_id_sent'.tr();
              return ErrorScreen(message: errorMsg);
            } else if (username != null && username.isNotEmpty) {
              return ProfileHandlerScreen(
                user: user,
                username: username,
                userId: null,
              );
            }
            logger.i('Zoccolone user: ${user?.username}');
            return ProfileHandlerScreen(user: user, userId: null);
          }
          return ProfileHandlerScreen(user: null, userId: id);
        },
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
