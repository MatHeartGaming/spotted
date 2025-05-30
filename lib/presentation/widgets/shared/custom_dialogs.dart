import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Future<void> showStandardCustomDialog(BuildContext context,
    {required String title,
    required String message,
    String? yesLocalisableText,
    Color? barrierColor,
    Color? okButtonColor,
    Widget? afterMessageContent,
    required Function onOkPressed,
    Function? onCancel}) async {
  final colors = Theme.of(context).colorScheme;
  final size = MediaQuery.sizeOf(context);
  await showAdaptiveDialog(
      context: context,
      barrierColor: barrierColor,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: afterMessageContent == null
              ? Text(message)
              : SizedBox(
                  height: size.height * 0.2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(message),
                      const SizedBox(
                        height: 10,
                      ),
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
                backgroundColor: WidgetStateProperty.all<Color>(
                    okButtonColor ?? colors.primary),
              ),
              child: Text(yesLocalisableText ?? 'yes_text').tr(),
              onPressed: () {
                context.pop();
                onOkPressed();
              },
            ),
          ],
        );
      });
}