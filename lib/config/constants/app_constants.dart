import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

// Paths
const String basePath = '/';
const String homePath = '/home';
const String explorePath = '/explore';
const String loadingPath = '/loading';
const String settingsListPath = '/settings_list_screen';
const String profilePath = '/profile_screen';
const String chatsPath = '/chats_screen';

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

// Logger
final logger = Logger();