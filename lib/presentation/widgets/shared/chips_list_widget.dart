import 'package:flutter/material.dart';

class ChipsHorizontalGridView extends StatelessWidget {
  final List<String> items;
  final int maxRows;
  final double rowHeight;

  const ChipsHorizontalGridView({
    super.key,
    required this.items,
    this.maxRows = 3,
    this.rowHeight = 48.0,
  });

  @override
  Widget build(BuildContext context) {
    // If you want to use your Theme's colors instead of hard‐coding,
    // you can swap out Colors.grey.shade800 / Colors.white for something like:
    //    Theme.of(context).colorScheme.primaryContainer
    //    and
    //    Theme.of(context).colorScheme.onPrimaryContainer
    //
    // Here we'll explicitly pick a dark‐gray fill + white text so you can see it in a dark scaffold.

    return SizedBox(
      height: rowHeight * maxRows,
      width: double.infinity,
      child: GridView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          // Exactly 3 rows tall
          crossAxisCount: maxRows,
          // Spacing between “pill” columns
          mainAxisSpacing: 8.0,
          // Spacing between each row (vertically)
          crossAxisSpacing: 8.0,
          // Make each cell fairly wide compared to its height.
          // You can tweak this ratio to make “snugger” or “wider” pills.
          childAspectRatio: 1.0,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Chip(
            // Give each Chip a solid fill so you actually see the pill shape:
            //backgroundColor: Colors.grey.shade800,
            // Force the text to be white so it contrasts against the dark fill:
            label: Text(
              items[index],
              //style: const TextStyle(color: Colors.white),
            ),
            // A bit of extra horizontal padding so longer text doesn’t cramp up.
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
          );
        },
      ),
    );
  }
}


