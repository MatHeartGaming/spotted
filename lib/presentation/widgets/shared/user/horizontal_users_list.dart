import 'package:flutter/material.dart';
import 'package:spotted/domain/models/user.dart';

typedef UserItemBuilder = Widget Function(UserModel u);

class HorizontalUsersList extends StatelessWidget {
  final List<UserModel> usersList;
  final Function(UserModel) onItemTap;
  final UserItemBuilder sectionItemBuilder;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;

  const HorizontalUsersList({
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
