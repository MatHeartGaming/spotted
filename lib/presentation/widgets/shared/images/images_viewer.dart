import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:spotted/config/config.dart';

void onImageTapped(BuildContext context, String imageUrl) {
  final imageProvider = Image.network(imageUrl).image;
  showImageViewer(
    context,
    imageProvider,
    swipeDismissible: true,
    useSafeArea: true,
    doubleTapZoomable: true,
    onViewerDismissed: () {
      logger.i("dismissed");
    },
  );
}

void showImagesGalleryBytes(
  BuildContext context,
  List<Uint8List> images, {
  int initialIndex = 0,
}) {
  MultiImageProvider multiImageProvider = MultiImageProvider([
    ...images.map((e) => MemoryImage(e)),
  ], initialIndex: initialIndex);

  showImageViewerPager(
    context,
    multiImageProvider,
    useSafeArea: true,
    swipeDismissible: true,
    doubleTapZoomable: true,
    onPageChanged: (page) {
      logger.i("page changed to $page");
    },
    onViewerDismissed: (page) {
      logger.i("dismissed while on page $page");
    },
  );
}

void showImagesUrl(
  BuildContext context,
  List<String> images, {
  int initialIndex = 0,
}) {
  MultiImageProvider multiImageProvider = MultiImageProvider([
    ...images.map((e) => NetworkImage(e)),
  ], initialIndex: initialIndex);

  showImageViewerPager(
    context,
    multiImageProvider,
    useSafeArea: true,
    swipeDismissible: true,
    doubleTapZoomable: true,
    onPageChanged: (page) {
      logger.i("page changed to $page");
    },
    onViewerDismissed: (page) {
      logger.i("dismissed while on page $page");
    },
  );
}
