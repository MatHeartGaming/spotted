// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotted/config/config.dart';
import 'package:spotted/domain/models/models.dart';
import 'package:spotted/presentation/navigation/navigation.dart';
import 'package:spotted/presentation/providers/providers.dart';
import 'package:spotted/presentation/widgets/widgets.dart';
import 'package:transparent_image/transparent_image.dart';

class VerifyEmailScreen extends ConsumerStatefulWidget {
  static const name = 'VerifyEmailScreen';

  final User user;

  const VerifyEmailScreen({super.key, required this.user});

  @override
  VerifyEmailScreenState createState() => VerifyEmailScreenState();
}

class VerifyEmailScreenState extends ConsumerState<VerifyEmailScreen> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    /*final authRepository = ref.read(authPasswordRepositoryProvider);
    final userRepository = ref.read(userRepositoryProvider);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      final isUserEmailVerified = await authRepository.isUserEmailVerified();
      if (isUserEmailVerified) {
        _timer.cancel();
        AuthState.emailVerified = true;
        final authPasswordRepo = ref.read(authPasswordRepositoryProvider);
        await userRepository
            .createUser(widget.user, authPasswordRepo.authUid ?? '')
            .then((newUser) {
              ref
                  .read(signedInUserProvider.notifier)
                  .update((state) => newUser);
              goToHomeScreenUsingContext(context);
            });
        return;
      }
    });*/
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("verify_email_screen_app_bar_title").tr(),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FadeInImage(
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.high,
                  height: size.height * 0.2,
                  placeholder: MemoryImage(kTransparentImage),
                  image: NetworkImage(Environment.verificationEmailSentGif),
                ),
                const Text(
                  "verify_email_screen_verification_email_sent_text",
                ).tr(),
                Text(
                  widget.user.email,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const Text(
                  "verify_email_screen_with_verification_link_text",
                ).tr(),
                const SizedBox(height: 20),
                const Text(
                  "verify_email_screen_verify_email_to_use_app_text",
                ).tr(),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text(
                      "verify_email_screen_email_not_received_text",
                    ).tr(),
                    TextButton(
                      onPressed: () => _sendVerificationEmail(ref, context),
                      child:
                          const Text(
                            "verify_email_screen_resend_email_text",
                          ).tr(),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                const Text("verify_email_screen_account_verified_text").tr(),
                const SizedBox(height: 20),
                _enterButton(context),
                const SizedBox(height: 50),
                FadeIn(
                  duration: const Duration(milliseconds: 800),
                  child:
                      const Text(
                        "verify_email_screen_enter_with_other_credentials_text",
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ).tr(),
                ),
                FadeInUp(
                  from: 30,
                  child: TextButton(
                    onPressed: () async {
                      _logoutAction();
                    },
                    child:
                        const Text("verify_email_screen_go_to_login_text").tr(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _logoutAction() {
    ref.read(authStatusProvider.notifier).logout().then((value) {
      ref.read(signedInUserProvider.notifier).update((state) => null);
      goToHomeScreenUsingContext(context);
    });
  }

  Widget _enterButton(BuildContext context) {
    return ZoomIn(
      child: SizedBox(
        width: 150,
        child: FilledButton(
          onPressed: () => _enterAction(ref, context),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              const Text("verify_email_screen_enter_text").tr(),
              const Spacer(),
              SlideInLeft(
                delay: const Duration(milliseconds: 300),
                child: const Icon(Icons.chevron_right),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _enterAction(WidgetRef ref, BuildContext context) async {
    /*final authRepository = ref.read(authPasswordRepositoryProvider);
    final userRepository = ref.read(userRepositoryProvider);
    final colors = Theme.of(context).colorScheme;
    await authRepository.isUserEmailVerified().then((
      isUserEmailVerified,
    ) async {
      if (isUserEmailVerified) {
        final authPasswordRepo = ref.read(authPasswordRepositoryProvider);
        await userRepository
            .createUser(widget.user, authPasswordRepo.authUid ?? '')
            .then((newUser) {
              ref
                  .read(signedInUserProvider.notifier)
                  .update((state) => newUser);
              goToHomeScreenUsingContext(context);
            });
        return;
      }
      showCustomSnackbar(
        context,
        "verify_email_screen_is_not_verified_text".tr(
          args: [widget.user.email],
        ),
        backgroundColor: colors.error,
      );
    });*/
  }

  Future<void> _sendVerificationEmail(
    WidgetRef ref,
    BuildContext context,
  ) async {
    final authRepository = ref.read(authPasswordRepositoryProvider);
    await authRepository.sendEmailVerificationLink().then((_) {
      showCustomSnackbar(
        context,
        "verify_email_screen_verification_email_resent_text".tr(
          args: [widget.user.email],
        ),
      );
    });
  }
}
