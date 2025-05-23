// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:spotted/config/constants/app_constants.dart';

class DrawerItem {
  final String title;
  final IconData icon;
  final String path;

  DrawerItem({required this.title, required this.icon, required this.path});

  @override
  bool operator ==(covariant DrawerItem other) {
    if (identical(this, other)) return true;
  
    return 
      other.title == title &&
      other.icon == icon &&
      other.path == path;
  }

  @override
  int get hashCode => title.hashCode ^ icon.hashCode ^ path.hashCode;
}

List<DrawerItem> getDrawerItems() {
  final menuMap = {
    'drawer_profile_item'.tr(): Icons.person,
    'drawer_home_item'.tr(): FontAwesomeIcons.house,
    'drawer_explore_item'.tr(): Icons.explore,
    'drawer_settings_item'.tr(): FontAwesomeIcons.gear,
  };

  final paths = {
    'drawer_profile_item'.tr(): profilePath,
    'drawer_home_item'.tr(): '$homePath/0',
    'drawer_explore_item'.tr(): '$homePath/1',
    'drawer_settings_item'.tr(): settingsListPath,
  };

  return menuMap.entries.map((entry) {
    final title = entry.key;
    final icon = entry.value;
    final path = paths[title] ?? '/';
    return DrawerItem(title: title, icon: icon, path: path);
  }).toList();
}