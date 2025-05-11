import 'package:flutter/material.dart';

void showCustomSnackbar(BuildContext context, String text,
    {Duration duration = const Duration(seconds: 2),
    Color? backgroundColor,
    Color? textColor,
    SnackBarBehavior snackBarBehavior = SnackBarBehavior.floating,
    IconData? icon}) {
  ScaffoldMessenger.maybeOf(context)?.clearSnackBars();
  final colors = Theme.of(context).colorScheme;
  final content = icon == null
      ? Text(
          text,
          style: TextStyle(color: textColor),
        )
      : Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: colors.primary,
            ),
            Text(
              text,
              style: TextStyle(color: textColor, fontSize: 10),
            )
          ],
        );
  ScaffoldMessenger.maybeOf(context)?.showSnackBar(
    SnackBar(
      content: content,
      duration: duration,
      //behavior: snackBarBehavior,
      showCloseIcon: true,
      backgroundColor: backgroundColor,
    ),
  );
}

void showCustomSnackbarWithActions(BuildContext context, String text,
    {Duration duration = const Duration(seconds: 2),
    Color? backgroundColor,
    Color? textColor,
    SnackBarBehavior snackBarBehavior = SnackBarBehavior.floating,
    IconData? icon, required String actionLabel, required VoidCallback onActionTap}) {
  ScaffoldMessenger.maybeOf(context)?.clearSnackBars();
  final colors = Theme.of(context).colorScheme;
  final content = icon == null
      ? Text(
          text,
          style: TextStyle(color: textColor),
        )
      : Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: colors.primary,
            ),
            Text(
              text,
              style: TextStyle(color: textColor, fontSize: 10),
            )
          ],
        );
  ScaffoldMessenger.maybeOf(context)?.showSnackBar(
    SnackBar(
      content: content,
      duration: duration,
      showCloseIcon: true,
      backgroundColor: backgroundColor,
      //behavior: snackBarBehavior,
      action: SnackBarAction(
          label: actionLabel,
          textColor: colors.primary,
          onPressed: () => onActionTap()),
    ),
  );
}
