// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:spotted/config/constants/app_constants.dart';
import 'package:spotted/config/constants/regular_expressions.dart';

class AppConfigs {
  final String appPrimaryColorHex;
  final String? deepLinkUrl;
  final double appIconBorderRadius;
  final String? docRef;
  final bool isInMaintenanceMode;
  final int buildNumberAndroid;
  final int buildNumberIos;
  final String playStoreLink;
  final String appStoreLink;
  final String? facebookLink;
  final String? instagramLink;
  final bool? showDeveloperAppInfoDialog;

  AppConfigs({
    required this.appPrimaryColorHex,
    this.docRef,
    this.appIconBorderRadius = 10,
    this.deepLinkUrl,
    this.isInMaintenanceMode = false,
    this.buildNumberAndroid = 0,
    this.buildNumberIos = 0,
    this.appStoreLink = '',
    this.playStoreLink = '',
    this.facebookLink = '',
    this.instagramLink = '',
    this.showDeveloperAppInfoDialog = true,
  });

  AppConfigs.empty({
    this.appPrimaryColorHex = defaultHexColor,
    this.appIconBorderRadius = 10,
    this.docRef,
    this.deepLinkUrl,
    this.isInMaintenanceMode = false,
    this.buildNumberAndroid = 0,
    this.buildNumberIos = 0,
    this.appStoreLink = '',
    this.playStoreLink = '',
    this.facebookLink = '',
    this.instagramLink = '',
    this.showDeveloperAppInfoDialog = true,
  });


  factory AppConfigs.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final map = snapshot.data()!;
    return AppConfigs(
      docRef: map['doc_ref'],
      appPrimaryColorHex: map['app_primary_color_hex'] ?? defaultHexColor,
      appIconBorderRadius:
          double.tryParse(map['app_icon_border_radius'].toString()) ?? 10,
      deepLinkUrl: map.containsKey('deep_link_url')
          ? map['deep_link_url']
          : defaulDeepLinkUrl,
      isInMaintenanceMode: map['is_in_maintenanceMode'] ?? false,
      buildNumberAndroid: map['build_number_android'] ?? 0,
      buildNumberIos: map['build_number_ios'] ?? 0,
      playStoreLink: map['play_store_link'],
      appStoreLink: map['app_store_link'],
      facebookLink: map['facebook_link'],
      instagramLink: map['instagram_link'],
      showDeveloperAppInfoDialog: map['show_developer_app_info_dialog'] ?? true,
    );
  }

  AppConfigs fromMap(Map<String, dynamic> map) {
    return AppConfigs(
      docRef: map['doc_ref'],
      appPrimaryColorHex: map['app_primary_color_hex'] ?? defaultHexColor,
      appIconBorderRadius:
          double.tryParse(map['app_icon_border_radius'].toString()) ?? 10,
      deepLinkUrl: map.containsKey('deep_link_url')
          ? map['deep_link_url']
          : defaulDeepLinkUrl,
      isInMaintenanceMode: map['is_in_maintenanceMode'] ?? false,
      buildNumberAndroid: map['build_number_android'] ?? 0,
      buildNumberIos: map['build_number_ios'] ?? 0,
      playStoreLink: map['play_store_link'],
      appStoreLink: map['app_store_link'],
      facebookLink: map['facebook_link'],
      instagramLink: map['instagram_link'],
      showDeveloperAppInfoDialog: map['show_developer_app_info_dialog'] ?? true,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'is_in_maintenanceMode': isInMaintenanceMode,
      'build_number_android': buildNumberAndroid,
      'build_number_ios': buildNumberIos,
      'doc_ref': docRef,
      'app_primary_color_hex': appPrimaryColorHex,
      'app_icon_border_radius': appIconBorderRadius,
      'deep_link_url': deepLinkUrl,
      'play_store_link': playStoreLink,
      'app_store_link': appStoreLink,
      'facebook_link': facebookLink,
      'instagram_link': instagramLink,
      'show_developer_app_info_dialog': showDeveloperAppInfoDialog,
    };
  }

  bool get appPrimaryColorValid => isValidHexColor(appPrimaryColorHex);

  bool get isValidFacebookLink =>
      facebookLink != null && facebookLink!.isNotEmpty;
  bool get isValidInstagramLink =>
      instagramLink != null && instagramLink!.isNotEmpty;

  AppConfigs copyWith({
    String? appPrimaryColorHex,
    String? deepLinkUrl,
    double? appIconBorderRadius,
    String? docRef,
    bool? isInMaintenanceMode,
    int? buildNumberAndroid,
    int? buildNumberIos,
    String? playStoreLink,
    String? appStoreLink,
    String? facebookLink,
    String? instagramLink,
    bool? showDeveloperAppInfoDialog,
  }) {
    return AppConfigs(
      appPrimaryColorHex: appPrimaryColorHex ?? this.appPrimaryColorHex,
      deepLinkUrl: deepLinkUrl ?? this.deepLinkUrl,
      appIconBorderRadius: appIconBorderRadius ?? this.appIconBorderRadius,
      docRef: docRef ?? this.docRef,
      isInMaintenanceMode: isInMaintenanceMode ?? this.isInMaintenanceMode,
      buildNumberAndroid: buildNumberAndroid ?? this.buildNumberAndroid,
      buildNumberIos: buildNumberIos ?? this.buildNumberIos,
      playStoreLink: playStoreLink ?? this.playStoreLink,
      appStoreLink: appStoreLink ?? this.appStoreLink,
      facebookLink: facebookLink ?? this.facebookLink,
      instagramLink: instagramLink ?? this.instagramLink,
      showDeveloperAppInfoDialog: showDeveloperAppInfoDialog ?? this.showDeveloperAppInfoDialog,
    );
  }
}
