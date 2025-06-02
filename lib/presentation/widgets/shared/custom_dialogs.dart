import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


/// Shows a platform‐adaptive dialog with only one “OK” button.
///
/// • On iOS, it uses CupertinoAlertDialog; on Android (and others) it
///   uses AlertDialog.  
/// • You can pass an optional `afterMessageContent` widget if you need
///   something below the message text (e.g. a loading spinner, image, etc.).  
/// • You can override the localized text for “OK” via `okLocalisableText`.  
/// • You can also supply a custom barrierColor or button color if desired.
Future<void> showOkOnlyDialog(
  BuildContext context, {
  required String title,
  required String message,
  String? okLocalisableText,   // e.g. 'ok_text'.tr()
  Color? barrierColor,
  Color? okButtonColor,
  Widget? afterMessageContent,
  required VoidCallback onOkPressed,
  bool isDestructive = false,   // for Cupertino destructive style
}) async {
  final colors = Theme.of(context).colorScheme;
  final size = MediaQuery.sizeOf(context);

  await showAdaptiveDialog(
    context: context,
    barrierColor: barrierColor,
    builder: (BuildContext innerContext) {
      if (Platform.isIOS) {
        // Cupertino style
        return _buildCupertinoOkDialog(
          innerContext,
          title: title,
          message: message,
          okLocalisableText: okLocalisableText,
          afterMessageContent: afterMessageContent,
          onOkPressed: onOkPressed,
          isDestructive: isDestructive,
        );
      } else {
        // Material style
        return _buildMaterialOkDialog(
          innerContext,
          title: title,
          message: message,
          okLocalisableText: okLocalisableText,
          okButtonColor: okButtonColor ?? colors.primary,
          afterMessageContent: afterMessageContent,
          onOkPressed: onOkPressed,
          dialogHeight: size.height * 0.2,
        );
      }
    },
  );
}

Widget _buildMaterialOkDialog(
  BuildContext context, {
  required String title,
  required String message,
  String? okLocalisableText,
  required Color okButtonColor,
  Widget? afterMessageContent,
  required VoidCallback onOkPressed,
  required double dialogHeight,
}) {
  return AlertDialog(
    title: Text(title),
    content: afterMessageContent == null
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
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all<Color>(okButtonColor),
        ),
        child: Text(okLocalisableText ?? 'ok_text').tr(),
        onPressed: () {
          Navigator.of(context).pop();
          onOkPressed();
        },
      ),
    ],
  );
}

Widget _buildCupertinoOkDialog(
  BuildContext context, {
  required String title,
  required String message,
  String? okLocalisableText,
  Widget? afterMessageContent,
  bool isDestructive = false,
  required VoidCallback onOkPressed,
}) {
  return CupertinoAlertDialog(
    title: Text(title),
    content: afterMessageContent == null
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
        isDestructiveAction: isDestructive,
        onPressed: () {
          Navigator.of(context).pop();
          onOkPressed();
        },
        child: Text(okLocalisableText ?? 'ok_text').tr(),
      ),
    ],
  );
}


// TextInput Dialog
/// A platform‐adaptive “Edit Text” dialog, usable on both Android and iOS.
/// 
/// • On Android (Material), it displays an AlertDialog with a TextField that
///   auto‐sizes to its content (no more giant blank space).  
/// • On iOS (Cupertino), it displays a CupertinoAlertDialog with a
///   CupertinoTextField whose text color and background adapt to Light/Dark mode
///   (so you no longer see “black on black”).  
///
/// The two buttons (“Cancel” and “OK”) are localized using easy_localization.
/// When the user taps “OK,” [onConfirm] is called with the trimmed text.
Future<void> showAdaptiveTextInputDialog(
  BuildContext context, {
  /// The i18n key for the dialog’s title (e.g. 'edit_comment_title').
  required String titleKey,

  /// Prefill the TextField with this text.
  required String initialText,

  /// The i18n key for the TextField’s placeholder (e.g. 'edit_comment_hint').
  required String hintTextKey,

  /// (Optional) Override for the “OK” button. Defaults to 'ok_text'.
  String? okTextKey,

  /// (Optional) Override for the “Cancel” button. Defaults to 'cancel_text'.
  String? cancelTextKey,

  /// If true, the “OK” button on iOS becomes destructive (red).
  bool isDestructive = false,

  /// (Optional) Any extra widget (e.g. a spinner or a note) below the TextField.
  Widget? afterContent,

  /// Called when user presses “OK.” We pass back the trimmed new text.
  required ValueChanged<String> onConfirm,
}) async {
  final theme = Theme.of(context);
  final colors = theme.colorScheme;

  // Controller that holds the current text.
  final controller = TextEditingController(text: initialText);

  await showAdaptiveDialog(
    context: context,
    builder: (BuildContext innerContext) {
      if (Platform.isIOS) {
        // ─── Cupertino Version ───────────────────────────────────────────────
        return CupertinoAlertDialog(
          title: Text(titleKey).tr(),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),

              // CupertinoTextField with dynamic textColor and backgroundColor
              CupertinoTextField(
                controller: controller,
                placeholder: hintTextKey.tr(),
                maxLines: null,
                autofocus: true,

                // Make sure text is readable in both Light and Dark:
                style: TextStyle(
                  color: CupertinoColors.label.resolveFrom(innerContext),
                ),

                // Make sure background also adapts so the field has contrast:
                decoration: BoxDecoration(
                  color: CupertinoColors.systemBackground.resolveFrom(innerContext),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: CupertinoColors.separator.resolveFrom(innerContext),
                  ),
                ),
              ),

              if (afterContent != null) ...[
                const SizedBox(height: 12),
                afterContent,
              ],
            ],
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              // “Cancel”
              onPressed: () {
                Navigator.of(innerContext).pop();
              },
              child: Text(cancelTextKey?.tr() ?? 'cancel_text'.tr()),
            ),
            CupertinoDialogAction(
              // “OK”
              isDestructiveAction: isDestructive,
              onPressed: () {
                final newText = controller.text.trim();
                Navigator.of(innerContext).pop();
                onConfirm(newText);
              },
              child: Text(okTextKey?.tr() ?? 'ok_text'.tr()),
            ),
          ],
        );
      } else {
        // ─── Material Version ────────────────────────────────────────────────
        return AlertDialog(
          backgroundColor: theme.dialogTheme.backgroundColor,
          title: Text(titleKey).tr(),
          content: Column(
            // Make the dialog size itself to the TextField + any extra widget,
            // instead of forcing a tall SizedBox. This prevents excessive blank space.
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: hintTextKey.tr(),
                ),
                maxLines: null,
                autofocus: true,
                style: TextStyle(color: theme.textTheme.bodyMedium?.color),
              ),
              if (afterContent != null) ...[
                const SizedBox(height: 12),
                afterContent,
              ],
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(innerContext).pop();
              },
              child: Text(cancelTextKey?.tr() ?? 'cancel_text'.tr()),
            ),
            FilledButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(colors.primary),
              ),
              onPressed: () {
                final newText = controller.text.trim();
                Navigator.of(innerContext).pop();
                onConfirm(newText);
              },
              child: Text(okTextKey?.tr() ?? 'ok_text'.tr()),
            ),
          ],
        );
      }
    },
  );
}



// More Complex Dialog
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
