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
        name: CreatePostsScreen.name,
        path: createPostPath,
        builder: (context, state) {
          return const CreatePostsScreen();
        },
      ),

      GoRoute(
        name: CreateCommunityScreen.name,
        path: createCommunityPath,
        builder: (context, state) {
          Map<String, dynamic>? mapExtras =
              state.extra as Map<String, dynamic>?;
          Community? community = mapExtras?['community'];
          return CreateCommunityScreen(community: community);
        },
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

          if (id == 'no-id') {
            User? user = mapExtras?['user'];
            String? username = mapExtras?['username'];
            if (user == null && username == null) {
              final errorMsg = 'community_screen_user_not_found_error'.tr();
              return ErrorScreen(message: errorMsg);
            } else if (username != null && username.isNotEmpty) {
              return ProfileHandlerScreen(
                user: user,
                username: username,
                userId: null,
              );
            }
            return ProfileHandlerScreen(user: user, userId: null);
          }
          return ProfileHandlerScreen(user: null, userId: id);
        },
      ),

      GoRoute(
        name: CommunityScreenHandler.name,
        path: '$communityPath/:communityId',
        builder: (context, state) {
          Map<String, dynamic>? mapExtras =
              state.extra as Map<String, dynamic>?;
          String? id =
              state.pathParameters.containsKey('communityId')
                  ? state.pathParameters['communityId'].toString()
                  : 'no-id';

          if (id == 'no-id') {
            Community? community = mapExtras?['community'];
            String? title = mapExtras?['title'];
            if (community == null && title == null) {
              final errorMsg =
                  'community_screen_community_not_found_error'.tr();
              return ErrorScreen(message: errorMsg);
            } else if (title != null && title.isNotEmpty) {
              return CommunityScreenHandler(
                community: community,
                communityId: title,
                communityTitle: null,
              );
            }
            return CommunityScreenHandler(
              community: community,
              communityId: null,
            );
          }
          return CommunityScreenHandler(community: null, communityId: id);
        },
      ),

      GoRoute(
        name: ChatHandlerScreen.name,
        path: chatPath,
        builder: (context, state) {
          Map<String, dynamic>? mapExtras =
              state.extra as Map<String, dynamic>?;
          String? id =
              state.pathParameters.containsKey('')
                  ? state.pathParameters[''].toString()
                  : 'no-id';

          if (id == 'no-id') {}
          return ChatHandlerScreen(
            user1Id: mapExtras?['user1Id'] ?? '',
            user2Id: mapExtras?['user2Id'] ?? '',
          );
        },
      ),

      GoRoute(
        name: ChatsScreen.name,
        path: chatsPath,
        builder: (context, state) => const ChatsScreen(),
      ),

      GoRoute(
        name: HomeSearchScreen.name,
        path: homeSearchPath,
        builder: (context, state) => const HomeSearchScreen(),
      ),

      GoRoute(
          name: LoginSignupView.name,
          path: loginPath,
          builder: (context, state) {
            return const LoginSignupView();
          },
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
            messagesView: ChatsScreen(),
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
