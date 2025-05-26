import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotted/config/config.dart';
import 'package:spotted/config/plugins/interfaces/camera_gallery_service.dart';

final imagePickerProvider = Provider<CameraGalleryService>(
  (ref) {
    return CameraGalleryServiceImplementation();
  },
);
