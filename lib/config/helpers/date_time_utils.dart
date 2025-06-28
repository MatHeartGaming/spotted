import 'package:easy_localization/easy_localization.dart';

extension DateTimeUtils on DateTime {
  String get timeAgo {
    final diff = DateTime.now().difference(this);
    if (diff.inMinutes < 1) return 'chat_times_just_now_text'.tr();
    if (diff.inHours < 1) {
      return 'chat_times_minutes_ago_text'.tr(
        args: [diff.inMinutes.toString()],
      );
    }
    if (diff.inDays < 1) {
      return 'chat_times_hours_ago_text'.tr(args: [diff.inHours.toString()]);
    }
    return 'chat_times_days_ago_text'.tr(args: [diff.inDays.toString()]);
  }
}
