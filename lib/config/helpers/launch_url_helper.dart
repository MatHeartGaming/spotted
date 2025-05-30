import 'dart:io';

import 'package:url_launcher/url_launcher.dart';

void openStore(String package) {
  if (Platform.isAndroid || Platform.isIOS) {
    final url = Uri.parse(
      Platform.isAndroid
          ? "market://details?id=$package"
          : "https://apps.apple.com/app/id$package",
    );
    launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    );
  }
}

void openUrl(String urlString) {
  final url = Uri.parse(urlString);
  launchUrl(
    url,
    mode: LaunchMode.externalApplication,
  );
}

Future<void> sendEmailTo(String email) async {
  final Uri params = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {'subject': 'Request', 'body': ''});
  
  await launchUrl(params);
}