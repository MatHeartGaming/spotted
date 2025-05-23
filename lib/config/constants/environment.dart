import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {

  // Prod
  static final String firebaseApiKeyAndroid =
      dotenv.env['FIREBASE_API_KEY_ANDROID'] ??
          "No Firebase api key for Android";
  static final String firebaseApiKeyIos =
      dotenv.env['FIREBASE_API_KEY_IOS'] ?? "No Firebase api key for iOS";
  static final String firebaseApiKeyWeb =
      dotenv.env['FIREBASE_API_KEY_WEB'] ?? "No Firebase api key for iOS";
  static final String appIdIos = dotenv.env['APP_ID_IOS'] ?? "No appId iOS key";
  static final String appIdAndroid =
      dotenv.env['APP_ID_ANDROID'] ?? "No appId Android key";
  static final String messageSenderId =
      dotenv.env['MESSAGE_SENDER_ID'] ?? "No message sender key";
  static final String webClientId =
      dotenv.env['WEB_CLIENT_ID'] ?? "No web client ID found";

       // Dev
  static final String firebaseApiKeyAndroidDev =
      dotenv.env['FIREBASE_API_KEY_ANDROID_DEV'] ??
          "No Firebase api key for Android";
  static final String firebaseApiKeyIosDev =
      dotenv.env['FIREBASE_API_KEY_IOS_DEV'] ?? "No Firebase api key for iOS";
  static final String firebaseApiKeyWebDev =
      dotenv.env['FIREBASE_API_KEY_WEB_DEV'] ?? "No Firebase api key for iOS";
  static final String appIdIosDev = dotenv.env['APP_ID_IOS_DEV'] ?? "No appId iOS key";
  static final String appIdAndroidDev =
      dotenv.env['APP_ID_ANDROID_DEV'] ?? "No appId Android key";
  static final String messageSenderIdDev =
      dotenv.env['MESSAGE_SENDER_ID_DEV'] ?? "No message sender key";

  // Images
  static final String verificationEmailSentGif =
      dotenv.env['VERIFICATION_EMAIL_SENT_GIF'] ?? 'No link';
  static final String signupGif = dotenv.env['SIGNUP_GIF'] ?? 'No link';
  static final String maintenanceImage =
      dotenv.env['MAINTENANCE_IMAGE'] ?? 'No Link';
  static final String updateAppImage =
      dotenv.env['UPDATE_APP_IMAGE'] ?? 'No Link';
  static final String profilePicAboutDialog =
      dotenv.env['PROFILE_PIC_ABOUT_DIALOG'] ?? 'No Link';
}
