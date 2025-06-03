import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotted/presentation/providers/providers.dart';
import 'package:spotted/presentation/screens/screens.dart';

class LoginSignupView extends ConsumerWidget {
  static String name = 'LoginSignupView';

  const LoginSignupView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showSignup = ref.watch(showLoginSignupProvider);
    return Scaffold(
      body: showSignup
        ? FadeIn(child: const SignupScreen())
        : FadeIn(child: const LoginScreen()),
    );
  }
}
