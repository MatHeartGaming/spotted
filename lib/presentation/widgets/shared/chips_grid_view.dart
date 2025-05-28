import 'package:flutter/material.dart';

typedef ChipTapCallback = void Function(String label);

class ChipsGridView extends StatelessWidget {
  /// The list of strings to show as chips.
  final List<String> chips;

  /// Called when the user taps a chip.
  final ChipTapCallback onTap;

  /// How many columns to show (you can tweak this).
  final int crossAxisCount;

  /// Spacing between chips.
  final double spacing;

  final bool showDeleteIcon;
  final VoidCallback onDelete;

  const ChipsGridView({
    super.key,
    required this.chips,
    required this.onTap,
    required this.onDelete,
    this.crossAxisCount = 3,
    this.spacing = 8.0,
    this.showDeleteIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return GridView.builder(
      // so it doesn’t try to scroll inside another scrollable
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
        // roughly make chips more “wide” than “tall”
        childAspectRatio: 3,
      ),
      itemCount: chips.length,
      itemBuilder: (context, index) {
        final label = chips[index];
        return GestureDetector(
          onTap: () => onTap(label),
          child: Chip(
            backgroundColor: colors.secondaryContainer,
            surfaceTintColor: colors.primary,
            onDeleted: showDeleteIcon ? () => onDelete() : null,
            elevation: 4,
            shape: RoundedSuperellipseBorder(
              borderRadius: BorderRadiusGeometry.circular(10),
            ),
            label: Text(
              label,
              style: TextStyle(color: colors.onSecondaryContainer),
            ),
            // you can customize colors, padding, etc. here
          ),
        );
      },
    );
  }
}
