// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class AppTheme {
  static const aiColor = Colors.purple;

  final Color? customColor;
  final bool isDarkMode;
  final double cardCornerRadiusTopLeft;
  final double cardCornerRadiusTopRight;
  final double cardCornerRadiusBottomLeft;
  final double cardCornerRadiusBottomRight;
  final Color cardBorderColor;
  final double cardBorderWidth;
  final Color? cardShadowColor;

  AppTheme({
    this.isDarkMode = false,
    this.customColor = Colors.lightBlue,
    this.cardCornerRadiusTopLeft = 15,
    this.cardCornerRadiusTopRight = 15,
    this.cardCornerRadiusBottomLeft = 15,
    this.cardCornerRadiusBottomRight = 15,
    this.cardBorderColor = Colors.transparent,
    this.cardBorderWidth = 0,
    this.cardShadowColor,
  });

  ThemeData getTheme({bool isDarkMode = false}) => ThemeData(
    useMaterial3: true,
    brightness: isDarkMode ? Brightness.dark : Brightness.light,
    colorSchemeSeed: customColor,
    appBarTheme: const AppBarTheme(centerTitle: true),
    cardTheme: CardTheme(
      shadowColor: cardShadowColor,
      /*color: Colors.white,
              shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(cardCornerRadiusTopLeft),
              topRight: Radius.circular(cardCornerRadiusTopRight),
              bottomLeft: Radius.circular(cardCornerRadiusBottomLeft),
              bottomRight: Radius.circular(cardCornerRadiusBottomRight),
            ),
            side: BorderSide(color: cardBorderColor, width: cardBorderWidth),
          )*/
    ),
  );

  AppTheme copyWith({
    Color? customColor,
    int? selectedColor,
    bool? isDarkMode,
    double? cardCornerRadiusTopLeft,
    double? cardCornerRadiusTopRight,
    double? cardCornerRadiusBottomLeft,
    double? cardCornerRadiusBottomRight,
    Color? cardBorderColor,
    double? cardBorderWidth,
    Color? cardShadowColor,
  }) {
    return AppTheme(
      customColor: customColor ?? this.customColor,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      cardCornerRadiusTopLeft:
          cardCornerRadiusTopLeft ?? this.cardCornerRadiusTopLeft,
      cardCornerRadiusTopRight:
          cardCornerRadiusTopRight ?? this.cardCornerRadiusTopRight,
      cardCornerRadiusBottomLeft:
          cardCornerRadiusBottomLeft ?? this.cardCornerRadiusBottomLeft,
      cardCornerRadiusBottomRight:
          cardCornerRadiusBottomRight ?? this.cardCornerRadiusBottomRight,
      cardBorderColor: cardBorderColor ?? this.cardBorderColor,
      cardBorderWidth: cardBorderWidth ?? this.cardBorderWidth,
      cardShadowColor: cardShadowColor ?? this.cardShadowColor,
    );
  }
}
