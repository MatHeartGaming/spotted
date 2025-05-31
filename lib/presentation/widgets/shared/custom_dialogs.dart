import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Future<void> showStandardCustomDialog(
  BuildContext context, {
  required String title,
  required String message,
  String? yesLocalisableText,
  Color? barrierColor,
  Color? okButtonColor,
  Widget? afterMessageContent,
  required Function onOkPressed,
  Function? onCancel,
  bool isDestructive = false,
}) async {
  final colors = Theme.of(context).colorScheme;
  final size = MediaQuery.sizeOf(context);

  await showAdaptiveDialog(
    context: context,
    barrierColor: barrierColor,
    builder: (BuildContext innerContext) {
      // Decide which dialog to show:
      if (Platform.isIOS) {
        return _buildCupertinoDialog(
          innerContext,
          title: title,
          message: message,
          yesLocalisableText: yesLocalisableText,
          afterMessageContent: afterMessageContent,
          onOkPressed: onOkPressed,
          onCancel: onCancel,
          isDestructive: isDestructive,
        );
      } else {
        return _buildMaterialDialog(
          innerContext,
          title: title,
          message: message,
          yesLocalisableText: yesLocalisableText,
          okButtonColor: okButtonColor ?? colors.primary,
          afterMessageContent: afterMessageContent,
          onOkPressed: onOkPressed,
          onCancel: onCancel,
          dialogHeight: size.height * 0.2,
        );
      }
    },
  );
}

Widget _buildMaterialDialog(
  BuildContext context, {
  required String title,
  required String message,
  String? yesLocalisableText,
  required Color okButtonColor,
  Widget? afterMessageContent,
  required Function onOkPressed,
  Function? onCancel,
  required double dialogHeight,
}) {
  return AlertDialog(
    title: Text(title),
    content:
        afterMessageContent == null
            ? Text(message)
            : SizedBox(
              height: dialogHeight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(message),
                  const SizedBox(height: 10),
                  afterMessageContent,
                ],
              ),
            ),
    actions: <Widget>[
      FilledButton(
        child: const Text('cancel_text').tr(),
        onPressed: () {
          if (onCancel != null) onCancel();
          context.pop();
        },
      ),
      FilledButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all<Color>(okButtonColor),
        ),
        child: Text(yesLocalisableText ?? 'yes_text').tr(),
        onPressed: () {
          context.pop();
          onOkPressed();
        },
      ),
    ],
  );
}

Widget _buildCupertinoDialog(
  BuildContext context, {
  required String title,
  required String message,
  String? yesLocalisableText,
  Widget? afterMessageContent,
  bool isDestructive = false,
  required Function onOkPressed,
  Function? onCancel,
}) {
  return CupertinoAlertDialog(
    title: Text(title),
    content:
        afterMessageContent == null
            ? Text(message)
            : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(message),
                const SizedBox(height: 10),
                afterMessageContent,
              ],
            ),
    actions: <Widget>[
      CupertinoDialogAction(
        onPressed: () {
          if (onCancel != null) onCancel();
          context.pop();
        },
        child: Text('cancel_text').tr(),
      ),
      CupertinoDialogAction(
        isDestructiveAction: isDestructive,
        onPressed: () {
          context.pop();
          onOkPressed();
        },
        child: Text(yesLocalisableText ?? 'yes_text').tr(),
      ),
    ],
  );
}
