import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotted/config/config.dart';
import 'package:spotted/config/helpers/firebase/firebase_configs.dart';
import 'package:spotted/config/router/app_router.dart';
import 'package:spotted/flavors.dart';
import 'package:spotted/presentation/providers/providers.dart';

// Define a top‐level key: for Snackbars and more
final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

Future<void> main() async {
  await _initialConfigs();
  runApp(
    EasyLocalization(
      supportedLocales: supportedLocalisations,
      path: 'assets/translations',
      fallbackLocale: fallbackLocale,
      child: const ProviderScope(child: MainApp()),
    ),
  );
}

Future<void> _initialConfigs() async {
  await dotenv.load(fileName: '.env');
  WidgetsFlutterBinding.ensureInitialized();
  //ConnectionStatusSingleton.getInstance().initialize();

  await EasyLocalization.ensureInitialized();
  logger.i('Flavor: ${F.appFlavor ?? Flavor.prod}');
  await FirebaseConfigs.initializeFCM(F.appFlavor ?? Flavor.prod);
  await FirebaseConfigs.initFirebaseMessaging();
  await SharedPrefsPlugin.init();
  FirebaseConfigs.initAnalAndCrashlytics();
}

class MainApp extends ConsumerStatefulWidget {
  const MainApp({super.key});

  @override
  MainAppState createState() => MainAppState();
}

class MainAppState extends ConsumerState<MainApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    Future(() {
      _updateSignedInUserProvider();
      _updateAppThemePrimaryHexColor();
    });
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    ref.read(appStateProvider.notifier).state = state;
    if (state == AppLifecycleState.resumed) {}
    super.didChangeAppLifecycleState(state);
  }

  void _updateSignedInUserProvider() {
    final signedInUser = ref.read(signedInUserProvider);
    final signeInUserId = ref.read(authPasswordRepositoryProvider).authUid;
    final userRepo = ref.read(usersRepositoryProvider);
    if (signeInUserId != null && signedInUser == null) {
      userRepo.getUserById(signeInUserId).then((user) {
        if (user != null) {
          ref.read(signedInUserProvider.notifier).update((state) {
            return user;
          });
          _getUnreadNotifications(user.id);
        }
      });
    }
  }

  void _getUnreadNotifications(String id) {
    final notificationsRepo = ref.read(userNotificationRepositoryProvider);
    notificationsRepo.getUnreadCountByReceiverId(id).then((unread) {
      ref
          .read(userNotificationUnreadProvider.notifier)
          .update((state) => unread);
    });
  }

  void _updateAppThemePrimaryHexColor() {
    /*ref.read(appConfigsProvider.notifier).loadAppConfigs().then(
      (configs) {
        final colorHex = configs.appPrimaryColorValid
            ? configs.appPrimaryColorHex
            : defaultHexColor;
        ref
            .read(themeNotifierProvider.notifier)
            .onAppPrimaryColorChanged(HexColor.fromHex(colorHex));
      },
    );*/
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = ref.watch(themeNotifierProvider);
    final appLanguage = ref.watch(localeProvider);
    final appRouterProvider = ref.watch(goRouterProvider);

    /*ref.listen(
      connectivityStreamProvider,
      (isConnectedPrevious, isConnectedNext) {
        ref.read(connectivityProvider.notifier).update(
          (state) {
            state = isConnectedNext.value ?? true;
            return state;
          },
        );
      },
    );*/

    //IosDeepLinksPlugin.setupIosDeepLinksAtLaunch(ref);

    return MaterialApp.router(
      scaffoldMessengerKey: rootScaffoldMessengerKey,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale:
          appLanguage!.localeCode.isEmpty
              ? context.locale
              : Locale(appLanguage.localeCode),
      theme: appTheme.getTheme(isDarkMode: appTheme.isDarkMode),
      routerConfig: appRouterProvider,
    );
  }
}
