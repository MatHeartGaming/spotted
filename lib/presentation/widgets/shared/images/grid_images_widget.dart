import 'dart:typed_data';

import 'package:flutter/material.dart';

class GridImagesWidget extends StatelessWidget {
  final List<Uint8List> images;
  final List<String>? imagesUrl;
  final double borderRadius;
  final int crossAxisCount;
  final double spacing;
  final void Function(int index)? onImageTap;
  final void Function(int index)? onImageDelete;

  const GridImagesWidget({
    super.key,
    this.images = const [],
    this.imagesUrl,
    this.borderRadius = 8,
    this.crossAxisCount = 3,
    this.spacing = 8,
    this.onImageTap,
    this.onImageDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty && (imagesUrl?.isEmpty ?? true)) {
      return const SizedBox.shrink();
    }

    final bool useImagesUrl =
        (imagesUrl != null && (imagesUrl?.isNotEmpty ?? false));

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
        childAspectRatio: 1, // ← makes every cell a square
      ),
      itemCount: useImagesUrl ? imagesUrl?.length : images.length,
      itemBuilder: (context, index) {
        return Stack(
          children: [
            GestureDetector(
              onTap: () => onImageTap?.call(index),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(borderRadius),
                child:
                    useImagesUrl
                        ? Image.network(
                          imagesUrl![index],
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        )
                        : Image.memory(
                          images[index],
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
              ),
            ),
            if (onImageDelete != null)
              Positioned(
                top: spacing / 2,
                right: spacing / 2,
                child: GestureDetector(
                  onTap: () => onImageDelete!(index),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
