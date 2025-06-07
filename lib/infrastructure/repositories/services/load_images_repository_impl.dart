import 'dart:typed_data';

import 'package:spotted/domain/datasources/services/load_images_datasource.dart';
import 'package:spotted/domain/repositories/repositories.dart';
import 'package:spotted/infrastructure/datasources/services/load_images_datasource_impl.dart';

class LoadImagesRepositoryImpl implements ILoadImagesRepository {
  final ILoadImagesDatasource _dataSource;

  LoadImagesRepositoryImpl({required dataSource}) : _dataSource = dataSource;

  @override
  Future<String> uploadImage({
    required Uint8List picBytes,
    required String filename,
    PicType picType = PicType.profilePics,
    String usernamePath = '',
  }) {
    return _dataSource.uploadImage(
        picBytes: picBytes, filename: filename, picType: picType, usernamePath: usernamePath);
  }
}
