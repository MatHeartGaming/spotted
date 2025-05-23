
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:spotted/config/constants/app_constants.dart';
import 'package:spotted/config/helpers/firebase/firebase_options.dart';
import 'package:spotted/flavors.dart';

class FirebaseConfigs {
  static Future<void> initializeFCM(Flavor f) async {
    await Firebase.initializeApp(
      options: f == Flavor.prod
          ? DefaultFirebaseOptionsProd.currentPlatform
          : DefaultFirebaseOptionsDev.currentPlatform,
    );
  }

  static Future<void> initFirebaseMessaging() async {
    if (kIsWeb) return;
    // You may set the permission requests to "provisional" which allows the user to choose what type
    // of notifications they would like to receive once the user receives a notification.

    final messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );

    logger.i('Auth Notification Status: ${settings.authorizationStatus}');

    _getFCMToken();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      logger.i('Got a message whilst in the foreground!');
      logger.i('Message data: ${message.data}');

      if (message.notification != null) {
        logger.i(
            'Message also contained a notification: ${message.notification}');
      }
    });
  }

  static Future<void> _getFCMToken() async {
    final messaging = FirebaseMessaging.instance;
    final notificationSettings = await messaging.getNotificationSettings();

    if (notificationSettings.authorizationStatus !=
        AuthorizationStatus.authorized) {
      return;
    }

    final token = await messaging.getToken();
    print('APNS Token: $token');
  }

  static void initAnalAndCrashlytics() {
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };
    // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }
}
