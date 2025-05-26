import 'package:flutter/foundation.dart';

abstract class CameraGalleryService<T> {
  Future<T?> takePhoto();
  Future<T?> selectPhoto();
  Future<List<T>> selectPhotos({int limit = 5});
  Future<Uint8List?> takePhotoAndGetBytes();
  Future<Uint8List?> selectPhotoAndGetBytes();
}
