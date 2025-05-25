import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotted/domain/models/models.dart';
import 'package:spotted/presentation/providers/providers.dart';
import 'package:spotted/presentation/screens/screens.dart';
import 'package:spotted/presentation/widgets/shared/loading_default_widget.dart';

class ProfileHandlerScreen extends ConsumerStatefulWidget {
  static const name = 'ProfileScreen';

  final String? userId;
  final String? username;
  final User? user;

  const ProfileHandlerScreen({
    super.key,
    required this.userId,
    this.username,
    this.user,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileHandlerScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _fetchUser();
    });
  }

  void _fetchUser() {
    if (widget.user != null) return;
    if (widget.userId != null) {
      ref.read(loadUserProvider.notifier).loadUserById(widget.userId!).then((
        userFound,
      ) {
        if (userFound == null) return;
        ref
            .read(userScreenCurrentUserProvider.notifier)
            .update((state) => userFound);
      });
      return;
    }
    if (widget.username != null) {
      ref
          .read(loadUserProvider.notifier)
          .loadUserByUsername(widget.username!)
          .then((userFound) {
            if (userFound == null) return;
            ref
                .read(userScreenCurrentUserProvider.notifier)
                .update((state) => userFound);
          });
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.user != null) {
      return ProfileScreen(user: widget.user!);
    }
    final currentUser = ref.watch(userScreenCurrentUserProvider);
    final loadUserState = ref.watch(loadUserProvider);
    return loadUserState.isLoadingUser
        ? LoadingDefaultWidget()
        : (currentUser.isEmpty)
        ? ErrorScreen(message: 'User not found')
        : ProfileScreen(user: currentUser);
  }
}
