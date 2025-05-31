import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotted/config/plugins/clipboard_plugin.dart';
import 'package:spotted/config/plugins/interfaces/clipboard_service.dart';

final clipboardProvider = Provider<ClipboardService>((ref) {
  return ClipboardPlugin();
});
