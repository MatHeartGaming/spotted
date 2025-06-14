import 'package:flutter/material.dart';
import 'package:spotted/presentation/widgets/widgets.dart';

/// A small tappable user‐card with an optional selection indicator.
class UserMiniItem extends StatelessWidget {
  final String? profileImageUrl;
  final String username;
  final bool isSelected;
  final VoidCallback? onTap;
  final double width;

  const UserMiniItem({
    super.key,
    this.profileImageUrl,
    required this.username,
    this.isSelected = false,
    this.onTap,
    this.width = 100,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return SizedBox(
      width: width,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          GestureDetector(
            onTap: onTap,
            child: Card(
              margin: const EdgeInsets.all(8),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 8,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CirclePicture(
                      urlPicture: profileImageUrl ?? '',
                      minRadius: 24,
                      maxRadius: 24,
                    ),
                    const SizedBox(height: 6),
                    // Wrap in Flexible so it can shrink and apply ellipsis
                    Flexible(
                      child: Text(
                        username,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (isSelected)
            Positioned(
              top: 10,
              right: 10,
              child: Icon(
                Icons.check_circle,
                color: colors.primary,
                size: 18,
              ),
            ),
        ],
      ),
    );
  }
}
