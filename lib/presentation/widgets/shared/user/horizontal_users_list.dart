import 'package:flutter/material.dart';
import 'package:spotted/domain/models/user.dart';

typedef UserItemBuilder = Widget Function(User u);

class HorizontalProductList extends StatelessWidget {
  final List<User> usersList;
  final Function(User) onItemTap;
  final UserItemBuilder sectionItemBuilder;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;

  const HorizontalProductList({
    super.key,
    required this.usersList,
    required this.onItemTap,
    required this.sectionItemBuilder,
    this.padding,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return SizedBox(
      width: size.width,
      height: height,
      child: ListView.builder(
        itemCount: usersList.length,
        padding: padding,
        scrollDirection: Axis.horizontal,
        prototypeItem: GestureDetector(
          child: sectionItemBuilder(User.empty()),
        ),
        itemBuilder: (context, index) {
          final p = usersList[index];
          return GestureDetector(
            onTap: () => onItemTap(p),
            child: sectionItemBuilder(p),
          );
        },
      ),
    );
  }
}
