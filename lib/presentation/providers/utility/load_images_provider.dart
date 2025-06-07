import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotted/infrastructure/datasources/services/load_images_datasource_impl.dart';
import 'package:spotted/infrastructure/repositories/repositories.dart';

final loadImagesProvider = Provider((ref) {
  final dataSource = LoadImagesDatasourceImpl();
  return LoadImagesRepositoryImpl(dataSource: dataSource);
});