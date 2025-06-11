import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class ImagesPageViewer extends StatefulWidget {
  
  final List<String> urlImages;
  final double inactiveDotHeight;
  final double inactiveDotWidth;
  final double activeDotHeight;
  final double activeDotWidth;

  /// Called when the user taps the *currently visible* image.
  /// index is the page they tapped.
  final void Function(int index)? onImageTap;

  const ImagesPageViewer({
    super.key,
    required this.urlImages,
    this.onImageTap,
    this.inactiveDotHeight = 6,
    this.inactiveDotWidth = 6,
    this.activeDotHeight = 8,
    this.activeDotWidth = 8,
  });

  @override
  State<ImagesPageViewer> createState() => _ImagesPageViewerState();
}

class _ImagesPageViewerState extends State<ImagesPageViewer> {
  late final PageController _controller;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _controller =
        PageController()..addListener(() {
          final page = _controller.page?.round() ?? 0;
          if (page != _currentPage) {
            setState(() => _currentPage = page);
          }
        });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.urlImages.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: PageView.builder(
            controller: _controller,
            itemCount: widget.urlImages.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => widget.onImageTap?.call(index),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: FadeInImage(
                    placeholder: MemoryImage(kTransparentImage),
                    image: NetworkImage(widget.urlImages[index]),
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 8),

        // dots indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.urlImages.length, (i) {
            final isActive = i == _currentPage;
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: isActive ? widget.activeDotWidth : widget.inactiveDotWidth,
              height:
                  isActive ? widget.activeDotHeight : widget.inactiveDotHeight,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    isActive
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.3),
              ),
            );
          }),
        ),
      ],
    );
  }
}
