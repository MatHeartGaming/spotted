import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:spotted/config/config.dart';
import 'package:spotted/domain/models/models.dart';
import 'package:spotted/presentation/providers/app_configs/app_configs_provider.dart';
import 'package:spotted/presentation/providers/providers.dart';
import 'package:spotted/presentation/screens/error/maintenance_errors.dart';

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
        name: VerifyEmailScreen.name,
        path: verifyEmailPath,
        builder: (context, state) {
          Map<String, dynamic>? mapExtras =
              state.extra as Map<String, dynamic>?;
          User? newUser = mapExtras?['newUser'] as User?;
          final signedInUser = ref.read(signedInUserProvider) ?? User.empty();
          return VerifyEmailScreen(user: newUser ?? signedInUser);
        },
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
        name: MaintenanceNoConnectionScreen.name,
        path: '/maintenance/:issue',
        builder: (context, state) {
          String issue =
              state.pathParameters['issue'] ??
              MaintenanceErrors.maintenance.name;
          switch (issue) {
            case 'noConnection':
              return MaintenanceNoConnectionScreen(
                firstText: 'maintenance_screen_no_connection_text'.tr(),
                secondText: 'maintenance_screen_no_connection_subtitle'.tr(),
                imageAsset: 'no_wifi.jpg',
                issue: MaintenanceErrors.noConnection,
              );
            case 'iOSBuildNumberIsHigher' || 'androidBuildNumberIsHigher':
              return MaintenanceNoConnectionScreen(
                firstText: 'maintenance_screen_update_available_text'.tr(),
                secondText: 'maintenance_screen_update_available_subtitle'.tr(),
                imageAsset: Environment.updateAppImage,
                issue:
                    Platform.isAndroid
                        ? MaintenanceErrors.androidBuildNumberIsHigher
                        : MaintenanceErrors.iOSBuildNumberIsHigher,
              );
            default:
              return MaintenanceNoConnectionScreen(
                firstText: 'maintenance_screen_app_under_maintenance_text'.tr(),
                secondText:
                    'maintenance_screen_app_under_maintenance_subtitle'.tr(),
                imageAsset: Environment.maintenanceImage,
              );
          }
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

      final isConnected = ref.watch(connectivityProvider);
      //final platformInfos = ref.watch(platformInfoProvider);
      //final signedInUser = ref.watch(signedInUserProvider);
      final authStatus = ref.watch(authStatusProvider).authStatus;
      final authRepo = ref.watch(authPasswordRepositoryProvider);
      final appConfigsStateAsync = ref.watch(appConfigsFutureProvider);
      if (isConnected) {
        /*if (signedInUser == null || authStatus == AuthStatus.notAuthenticated) {
          return loginPath;
        }
        if (isGoingTo == basePath) {
          return '$homePath/0';
        }*/
        return appConfigsStateAsync.when(
          data: (configs) async {
            if (configs.isInMaintenanceMode) {
              return '/maintenance/${MaintenanceErrors.maintenance.name}';
            }
            /*final localBuildNumber = await platformInfos.getBuildNumber();
              if (Platform.isIOS) {
                if (configs.buildNumberIos > localBuildNumber) {
                  return '/maintenance/${MaintenanceErrors.iOSBuildNumberIsHigher.name}';
                }
              } else {
                if (configs.buildNumberAndroid > localBuildNumber) {
                  return '/maintenance/${MaintenanceErrors.androidBuildNumberIsHigher.name}';
                }
              }*/
            if (isGoingTo == loadingPath && authStatus == AuthStatus.checking) {
              return null;
            }

            if (authStatus == AuthStatus.notAuthenticated) {
              if (isGoingTo == loginPath) return null;

              return loginPath;
            }

            final emailVerified =
                (AuthState.emailVerified == null ||
                        AuthState.emailVerified == false)
                    ? await authRepo.isUserEmailVerified()
                    : (AuthState.emailVerified ?? false);
            AuthState.emailVerified = emailVerified;
            if (authStatus == AuthStatus.authenticated && !emailVerified) {
              return verifyEmailPath;
            }

            if (authStatus == AuthStatus.authenticated) {
              if (isGoingTo.startsWith(homePath)) return isGoingTo;
              if (isGoingTo == loginPath ||
                  isGoingTo == loadingPath ||
                  isGoingTo == basePath) {
                return '$homePath/0';
              }
            }
            return null;
          },
          loading: () => loadingPath,
          error: (Object error, StackTrace stackTrace) {
            logger.e('Error while routing: $error');
            logger.e('StackTrace while routing: $stackTrace');
            return null;
          },
        );
      } else {
        return '/maintenance/${MaintenanceErrors.noConnection.name}';
      }
    },
  );
});
