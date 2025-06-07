import 'package:flutter/foundation.dart';
import 'package:spotted/infrastructure/datasources/services/load_images_datasource_impl.dart';

abstract class ILoadImagesRepository {
  Future<String> uploadImage({
    required Uint8List picBytes,
    required String filename,
    PicType picType = PicType.profilePics,
    String usernamePath = '',
  });
}
