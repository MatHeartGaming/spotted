import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import 'package:spotted/config/config.dart';
import 'package:spotted/config/plugins/interfaces/camera_gallery_service.dart';

class CameraGalleryServiceImplementation implements CameraGalleryService {
  final ImagePicker _picker = ImagePicker();

  @override
  Future<XFile?> selectPhoto() async {
    final XFile? photo =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 100);
    if (photo == null) return null;
    logger.i('We got an image at ${photo.path}');
    return photo;
  }

  @override
  Future<XFile?> takePhoto() async {
    final XFile? photo =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 100);
    if (photo == null) return null;
    logger.i('We got an image at ${photo.path}');
    return photo;
  }

  @override
  Future<Uint8List?> selectPhotoAndGetBytes() async {
    final image = await selectPhoto();
    return await image?.readAsBytes();
  }

  @override
  Future<Uint8List?> takePhotoAndGetBytes() async {
    final image = await takePhoto();
    return await image?.readAsBytes();
  }
}
