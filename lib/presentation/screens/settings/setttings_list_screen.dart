import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsListScreen extends ConsumerWidget {
  static const String name = 'SettingsListScreen';

  const SettingsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(body: Center(child: Text('Settings')));
  }
}
