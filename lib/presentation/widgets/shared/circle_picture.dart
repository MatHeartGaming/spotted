import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class CirclePicture extends StatelessWidget {
  final String urlPicture;
  final Uint8List? imageBytes;
  final double minRadius;
  final double maxRadius;
  final double borderRadius;
  final double? width;
  final double? height;

  const CirclePicture({
    super.key,
    required this.urlPicture,
    this.minRadius = 30,
    this.maxRadius = 40,
    this.borderRadius = 50,
    this.imageBytes,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CircleAvatar(
          minRadius: minRadius,
          maxRadius: maxRadius,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
            child: imageBytes == null
                ? _renderPicutreOrPlaceholder()
                : FadeInImage(
                    placeholder: MemoryImage(kTransparentImage),
                    image: MemoryImage(imageBytes!),
                    fit: BoxFit.cover,
                  ),
          )),
    );
  }

  Widget _renderPicutreOrPlaceholder() {
    if (urlPicture.isEmpty) {
      return const Icon(Icons.image_not_supported_rounded);
    }
    return FadeInImage.memoryNetwork(
      placeholder: kTransparentImage,
      image: urlPicture,
      fit: BoxFit.cover,
      width: width,
      height: height,
    );
  }
}

class RoundedBordersPicture extends StatelessWidget {
  final String urlPicture;
  final Uint8List? imageBytes;
  final double borderRadius;
  final double? width;
  final double? height;
  final BoxFit fit;
  final FilterQuality quality;

  const RoundedBordersPicture({
    super.key,
    required this.urlPicture,
    this.borderRadius = 10,
    this.imageBytes,
    this.width = 100,
    this.height = 100,
    this.fit = BoxFit.cover,
    this.quality = FilterQuality.none,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: width,
        height: height,
        decoration: BoxDecoration(
            color: colors.primary.withValues(alpha: 0),
            borderRadius: BorderRadius.circular(borderRadius)),
        child: imageBytes == null
            ? _renderPicutreOrPlaceholder()
            : FadeInImage(
                placeholder: MemoryImage(kTransparentImage),
                image: MemoryImage(imageBytes!),
                fit: fit,
                filterQuality: quality,
              ),
      ),
    );
  }

  Widget _renderPicutreOrPlaceholder() {
    if (urlPicture.isEmpty) {
      return const Icon(Icons.image_not_supported_rounded);
    }
    return FadeInImage.memoryNetwork(
      placeholder: kTransparentImage,
      image: urlPicture,
      fit: fit,
      width: width,
      height: height,
    );
  }
}
