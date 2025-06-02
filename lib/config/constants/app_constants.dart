import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:logger/logger.dart';

// Paths
const String basePath = '/';
const String homePath = '/home';
const String explorePath = '/explore';
const String loadingPath = '/loading';
const String settingsListPath = '/settings_list_screen';
const String profilePath = '/profile_screen';
const String communityPath = '/community_screen';
const String chatPath = '/chat_screen';
const String chatsPath = '/chats_screen';
const String homeSearchPath = '/home_search_screen';
const String createPostPath = '/create_post_screen';
const String createCommunityPath = '/create_community_screen';

// Shared prefs
const String isDarkTheme = "dark_theme";

// Colors
const String defaultHexColor = "#62B9E9";
const String transparentHexColor = "#00000000";
const String blackHexColor = "#000000";
const String amberColor = "#ffffc107";
final Color colorSuccess = Colors.green[300]!;
final Color colorNotOkButton = Colors.red[400]!;
final Color colorWarning = Colors.yellow[800]!;

// Contacts
const String linkedinPageURL =
    'https://www.linkedin.com/in/matteo-buompastore-3b78921a0/';
const String githubPageURL = 'https://github.com/MatHeartGaming';
const String stackOverflowPageURL =
    'https://stackoverflow.com/users/12989363/matbuompy';
const String privacyPolicyUrl =
    "https://love-budget-deep-linking.up.railway.app/";

// Deep Links
const String defaulDeepLinkUrl =
    'https://ginevra-distribuzioni.up.railway.app/';

// Dev email
const String devEmail = 'matteo.buompastore088@gmail.com';

// Anonumous Stuff
const String anonymousText = "Anonymous";
const IconData anonymousIcon = FontAwesomeIcons.mask;
const IconData nonAnonymousIcon = FontAwesomeIcons.person;

// Logger
final logger = Logger();
