import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:logger/logger.dart';
import 'package:spotted/domain/datasources/datasources.dart';

class LoadImagesDatasourceImpl implements ILoadImagesDatasource {
  static final _storage = FirebaseStorage.instance;
  final _logger = Logger();

  @override
  Future<String> uploadImage({
    required String filename,
    required Uint8List picBytes,
    PicType picType = PicType.profilePics,
    String usernamePath = '',
  }) async {
    final pathToAppend = usernamePath.isNotEmpty ? '$usernamePath/' : '';
    final pathToAdd = 'app/$pathToAppend';
    final storageRef = _storage.ref("$pathToAdd${picType.name}/");
    final picRef = storageRef.child(filename);
    final metaData = SettableMetadata(contentType: "image/jpeg");

    try {
      await picRef.putData(picBytes, metaData);
      final imageUrl = await picRef.getDownloadURL();
      return imageUrl;
    } on FirebaseException catch (e) {
      _logger.e('Exception Storage: $e');
    } finally {
      // Update code
    }

    return "";
  }
}

enum PicType { profilePics, postPics, communityPics }