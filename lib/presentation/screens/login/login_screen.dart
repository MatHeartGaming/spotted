import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:spotted/config/config.dart';
import 'package:spotted/config/helpers/firebase/auth_shared_functions.dart';
import 'package:spotted/presentation/providers/providers.dart';
import 'package:spotted/presentation/widgets/widgets.dart';

class LoginScreen extends ConsumerWidget {
  static String name = 'LoginScreen';

  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showPassword = ref.watch(showPasswordProvider);
    final authStatusNotifier = ref.watch(authStatusProvider);
    final loginFormState = ref.watch(loginFormProvider);
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("login_screen_login_title").tr(),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: IconButton.filledTonal(
                tooltip: ("login_screen_login_title").tr(),
                onPressed:
                    () =>
                        authStatusNotifier.authStatus == AuthStatus.checking
                            ? null
                            : _loginUsingPassword(ref),
                icon: const Icon(Icons.check_circle_outline_outlined),
              ),
            ),
          ],
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  CustomTextFormField(
                    initialValue: "",
                    autoFillHints: const [AutofillHints.email],
                    label: "login_screen_email_text".tr(),
                    formatter: FormInputFormatters.email,
                    errorMessage:
                        loginFormState.isPosting
                            ? loginFormState.email.errorMessage
                            : null,
                    icon: Icons.email_outlined,
                    onChanged: (newValue) {
                      final loginFormState = ref.read(
                        loginFormProvider.notifier,
                      );
                      loginFormState.emailChanged(newValue);
                    },
                    onSubmitForm:
                        (_) => _submitFormAction(authStatusNotifier, ref),
                  ),
                  const SizedBox(height: 20),
                  CustomTextFormField(
                    initialValue: "",
                    autoFillHints: const [AutofillHints.newPassword],
                    label: "login_screen_password_text".tr(),
                    trailingIcon: IconButton(
                      onPressed: () {
                        ref.read(showPasswordProvider.notifier).state =
                            !showPassword;
                      },
                      icon: _showHidePasswordIcon(showPassword),
                    ),
                    errorMessage:
                        loginFormState.isPosting
                            ? loginFormState.password.errorMessage
                            : null,
                    icon: Icons.lock,
                    obscureText: !showPassword,
                    onChanged: (newValue) {
                      final loginFormState = ref.read(
                        loginFormProvider.notifier,
                      );
                      loginFormState.passwordChanged(newValue);
                    },
                    onSubmitForm:
                        (_) => _submitFormAction(authStatusNotifier, ref),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "user_screen_change_passwor_text",
                        style: TextStyle(fontSize: 12),
                      ).tr(),
                      TextButton(
                        onPressed: () => _sendResetPasswordLink(ref),
                        child: const Text("reset_text").tr(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("login_screen_dont_have_account_text").tr(),
                      const SizedBox(width: 2),
                      TextButton(
                        onPressed: () {
                          ref
                              .read(showLoginSignupProvider.notifier)
                              .update((state) => !state);
                        },
                        child: const Text(
                          "login_screen_signup_title_with_args",
                        ).tr(args: ["!"]),
                      ),
                    ],
                  ),
                  //_authMethodsRow(context, ref),
                  const SizedBox(height: 20),
                  FilledButton.tonal(
                    onPressed: () => _submitFormAction(authStatusNotifier, ref),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("login_screen_login_title").tr(),
                        const SizedBox(width: 6),
                        ZoomIn(
                          child: const Icon(
                            Icons.check_circle_outline_outlined,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _showHidePasswordIcon(bool showPassword) {
    return Stack(
      children: [
        Icon(showPassword ? FontAwesomeIcons.eyeSlash : FontAwesomeIcons.eye),
      ],
    );
  }

  Future<void> _loginUsingPassword(WidgetRef ref) async {
    //final signupFormState = ref.read(signupFormProvider);
    final loginFormNotifier = ref.read(loginFormProvider.notifier);
    final loginFormState = ref.read(loginFormProvider);
    final authStatusNotifier = ref.read(authStatusProvider.notifier);
    final userRepository = ref.read(usersRepositoryProvider);
    final signedInUserNotifier = ref.read(signedInUserProvider.notifier);
    final colors = Theme.of(ref.context).colorScheme;
    loginFormNotifier.onSubmit(
      onSubmit: () async {
        await authStatusNotifier.loginUsingPassword(
          loginFormState.email.value,
          loginFormState.password.value,
          onInvalidCredentials: () {
            showCustomSnackbar(
              ref.context,
              'login_screen_email_invalid_credentials_snackbar'.tr(),
              backgroundColor: colors.error,
            );
          },
          onUnkownError: () {
            showCustomSnackbar(
              ref.context,
              'login_screen_email_unexpected_error_snackbar'.tr(),
              backgroundColor: colors.error,
            );
          },
          onTooManyAttempts: () {
            showCustomSnackbar(
              ref.context,
              'login_screen_email_too_many_attempts_snackbar'.tr(),
              backgroundColor: colors.error,
            );
          },
          onAuthSuccess: (userCredential) async {
            if (userCredential == null) {
              if (ref.context.mounted) {
                showCustomSnackbar(
                  ref.context,
                  "login_screen_email_unexpected_error_snackbar".tr(),
                  backgroundColor: colors.error,
                );
              }
              return false;
            }

            await userRepository
                .getUserByEmail(loginFormState.email.value)
                .then((user) {
                  if (user != null) {
                    signedInUserNotifier.update((state) => user);
                  }
                  logger.i('Login with Password! $user');
                });
            return true;
          },
        );
      },
    );
  }

  Future<void>? _submitFormAction(AuthState authStatusNotifier, WidgetRef ref) {
    return authStatusNotifier.authStatus == AuthStatus.checking
        ? null
        : _loginUsingPassword(ref);
  }

  void _sendResetPasswordLink(WidgetRef ref) {
    final loginFormState = ref.watch(loginFormProvider);
    if (loginFormState.email.isNotValid) {
      showCustomSnackbar(
        ref.context,
        duration: const Duration(seconds: 3),
        'login_screen_email_validation_snackbar_error'.tr(
          args: [loginFormState.email.value],
        ),
      );
      return;
    }
    sendResetPasswordEmail(ref, loginFormState.email.value);
  }
}
