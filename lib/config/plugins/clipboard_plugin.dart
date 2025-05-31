import 'package:clipboard/clipboard.dart';
import 'package:spotted/config/config.dart';
import 'package:spotted/config/plugins/interfaces/clipboard_service.dart';

class ClipboardPlugin implements ClipboardService {
  @override
  void copy(String text) {
    FlutterClipboard.copy(text).then((value) => logger.i('Copied: $text'));
  }
}
