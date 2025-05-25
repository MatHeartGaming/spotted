import 'package:flutter/foundation.dart';

abstract class CameraGalleryService<T> {
  Future<T?> takePhoto();
  Future<T?> selectPhoto();
  Future<Uint8List?> takePhotoAndGetBytes();
  Future<Uint8List?> selectPhotoAndGetBytes();
}
