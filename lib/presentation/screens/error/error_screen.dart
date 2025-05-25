import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:spotted/presentation/navigation/navigation.dart';

class ErrorScreen extends StatelessWidget {
  static const String name = 'ErrorScreen';
  final String message;

  const ErrorScreen({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colors.errorContainer,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              message,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            IconButton.filled(
                onPressed: () {
                  goToHomeScreenUsingContext(context);
                },
                icon: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.home),
                    const SizedBox(
                      width: 6,
                    ),
                    Text(
                      'error_screen_go_back_to_home_btn_text',
                      style: TextStyle(color: colors.onPrimary),
                    ).tr(),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
