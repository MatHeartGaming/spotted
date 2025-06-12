import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotted/domain/models/models.dart';
import 'package:spotted/domain/repositories/user_notification_repository.dart';
import 'package:spotted/presentation/providers/providers.dart';

final userNotificationUnreadProvider = StateProvider<int>((ref) {
  return 0;
});

final loadUserNotificationsProvider = StateNotifierProvider<
  LoadUserNotificationsNotifier,
  LoadUserNotificationsState
>((ref) {
  final userNotificationsRepo = ref.watch(userNotificationRepositoryProvider);
  final notifier = LoadUserNotificationsNotifier(userNotificationsRepo);
  return notifier;
});

class LoadUserNotificationsNotifier
    extends StateNotifier<LoadUserNotificationsState> {
  final UserNotificationRepository _userNotificationRepository;

  LoadUserNotificationsNotifier(this._userNotificationRepository)
    : super(LoadUserNotificationsState());

  Future<List<UserNotification>> getUserNotifications(String userId) async {
    if (state.isLoadingUserNotifications) return state.userNotifications;
    state = state.copyWith(isLoadingUserNotifications: true);

    final userNotifications = await _userNotificationRepository
        .getNotificationsByReceiverId(userId);

    state = state.copyWith(
      userNotifications: userNotifications,
      isLoadingUserNotifications: false,
    );

    return state.userNotifications;
  }
}

class LoadUserNotificationsState {
  final List<UserNotification> userNotifications;
  final bool isLoadingUserNotifications;

  LoadUserNotificationsState({
    this.userNotifications = const [],
    this.isLoadingUserNotifications = false,
  });

  @override
  bool operator ==(covariant LoadUserNotificationsState other) {
    if (identical(this, other)) return true;

    return other.userNotifications == userNotifications &&
        other.isLoadingUserNotifications == isLoadingUserNotifications;
  }

  @override
  int get hashCode =>
      userNotifications.hashCode ^ isLoadingUserNotifications.hashCode;

  LoadUserNotificationsState copyWith({
    List<UserNotification>? userNotifications,
    bool? isLoadingUserNotifications,
  }) {
    return LoadUserNotificationsState(
      userNotifications: userNotifications ?? this.userNotifications,
      isLoadingUserNotifications:
          isLoadingUserNotifications ?? this.isLoadingUserNotifications,
    );
  }
}
