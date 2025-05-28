import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spotted/config/config.dart';

void showCustomBottomSheet(BuildContext context, {required Widget child}) {
  if (!context.mounted) return;
  logger.i('showCustomBottomSheet');
  if (Platform.isIOS) {
    showCupertinoSheet(
      context: context,
      pageBuilder: (context) {
        return child;
      },
    );
    return;
  }
  showModalBottomSheet(
    context: context,
    showDragHandle: true,
    useSafeArea: true,
    isScrollControlled: true,
    builder: (context) {
      return child;
    },
  );
}

void showNavigatableSheet(BuildContext context, {required Widget child}) {
  if (Platform.isIOS) {
    logger.i('showNavigatableSheet');
    showCupertinoSheet(
      context: context,
      useNestedNavigation: true,
      pageBuilder: (context) {
        return child;
      },
    );
    return;
  }
  showModalBottomSheet(
    context: context,
    showDragHandle: true,
    useSafeArea: true,
    isScrollControlled: true,
    builder: (_) {
      return Navigator(
        // this Navigator lives *inside* the sheet
        onGenerateRoute: (settings) => MaterialPageRoute(builder: (_) => child),
      );
    },
  );
}

void displayPickImageDialog(
  BuildContext context, {
  double height = 200,
  required Function onGalleryChosen,
  required Function onTakePicChosen,
}) {
  if (!context.mounted) return;
  logger.i('displayPickImageDialog');
  final size = MediaQuery.sizeOf(context);
  final textStyles = Theme.of(context).textTheme;
  final sheetChild = SizedBox(
    width: size.width * 0.9,
    height: height,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "modal_bottom_photo_choose_from",
          style: textStyles.bodyLarge,
        ).tr(),
        const SizedBox(height: 10),
        SizedBox(
          width: 200,
          child: OutlinedButton.icon(
            onPressed: () async => await onGalleryChosen(),
            icon: const Icon(Icons.image_search),
            label: const Text("modal_bottom_photo_gallery").tr(),
          ),
        ),
        SizedBox(
          width: 200,
          child: OutlinedButton.icon(
            onPressed: () async => await onTakePicChosen(),
            icon: const Icon(Icons.camera_alt_outlined),
            label: const Text("modal_bottom_photo_camera").tr(),
          ),
        ),
      ],
    ),
  );
  /*if (Platform.isIOS) {
    showCupertinoSheet(
      context: context,
      pageBuilder: (context) {
        return sheetChild;
      },
    );
    return;
  }*/
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return sheetChild;
    },
  );
}
