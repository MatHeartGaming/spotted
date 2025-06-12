// ignore_for_file: use_build_context_synchronously

import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:spotted/config/config.dart';
import 'package:spotted/domain/models/models.dart';
import 'package:spotted/infrastructure/datasources/exceptions/user_exceptions.dart';
import 'package:spotted/presentation/providers/providers.dart';
import 'package:spotted/presentation/widgets/widgets.dart';

class SignupScreen extends ConsumerStatefulWidget {
  static String name = 'SignupScreen';

  const SignupScreen({super.key});

  @override
  SignupScreenState createState() => SignupScreenState();
}

class SignupScreenState extends ConsumerState<SignupScreen> {
  @override
  void initState() {
    super.initState();
    Future(() {
      _loadFeaturesAndInterests();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _loadFeaturesAndInterests() {
    ref.read(signupFormProvider.notifier).initCountryDropDownMenu();
  }

  @override
  Widget build(BuildContext context) {
    final showPassword = ref.watch(showPasswordProvider);
    final showRepeatPassword = ref.watch(showRepeatPasswordProvider);
    final authStatusNotifier = ref.watch(authStatusProvider);
    final signupFormState = ref.watch(signupFormProvider);
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("login_screen_signup_title").tr(),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: IconButton.filledTonal(
                tooltip: ("login_screen_signup_title").tr(),
                onPressed: () => _submitFormAction(authStatusNotifier, ref),
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
                spacing: 20,
                children: [
                  const SizedBox(height: 50),
                  CustomTextFormField(
                    initialValue: "",
                    autoFillHints: const [AutofillHints.name],
                    label: "login_screen_name_text".tr(),
                    formatter: FormInputFormatters.text,
                    errorMessage:
                        signupFormState.isPosting
                            ? signupFormState.name.errorMessage
                            : null,
                    icon: Icons.person,
                    onChanged: (newValue) {
                      final signupFormState = ref.read(
                        signupFormProvider.notifier,
                      );
                      signupFormState.nameChanged(newValue);
                    },
                    onSubmitForm:
                        (_) => _submitFormAction(authStatusNotifier, ref),
                  ),
                  CustomTextFormField(
                    initialValue: "",
                    autoFillHints: const [AutofillHints.familyName],
                    label: "login_screen_surname_text".tr(),
                    formatter: FormInputFormatters.text,
                    errorMessage:
                        signupFormState.isPosting
                            ? signupFormState.surname.errorMessage
                            : null,
                    icon: Icons.person,
                    onChanged: (newValue) {
                      final signupFormState = ref.read(
                        signupFormProvider.notifier,
                      );
                      signupFormState.surnameChanged(newValue);
                    },
                    onSubmitForm:
                        (_) => _submitFormAction(authStatusNotifier, ref),
                  ),
                  CustomTextFormField(
                    initialValue: "",
                    autoFillHints: const [AutofillHints.email],
                    label: "login_screen_email_text".tr(),
                    formatter: FormInputFormatters.email,
                    errorMessage:
                        signupFormState.isPosting
                            ? signupFormState.email.errorMessage
                            : null,
                    icon: Icons.email_outlined,
                    onChanged: (newValue) {
                      final signupFormState = ref.read(
                        signupFormProvider.notifier,
                      );
                      signupFormState.emailChanged(newValue);
                    },
                    onSubmitForm:
                        (_) => _submitFormAction(authStatusNotifier, ref),
                  ),
                  CustomTextFormField(
                    initialValue: "",
                    autoFillHints: const [AutofillHints.newUsername],
                    label: "login_screen_username_text".tr(),
                    formatter: FormInputFormatters.text,
                    errorMessage:
                        signupFormState.isPosting
                            ? signupFormState.username.errorMessage
                            : null,
                    icon: FontAwesomeIcons.userNinja,
                    onChanged: (newValue) {
                      ref
                          .read(signupFormProvider.notifier)
                          .usernameChanged(newValue);
                    },
                    onSubmitForm:
                        (_) => _submitFormAction(authStatusNotifier, ref),
                  ),
                  CountrySelector(
                    controller: signupFormState.countryController,
                    items: countryMenuItems,
                  ),
                  CustomTextFormField(
                    initialValue: "",
                    autoFillHints: const [AutofillHints.addressCity],
                    label: "login_screen_city_text".tr(),
                    formatter: FormInputFormatters.text,
                    errorMessage:
                        signupFormState.isPosting
                            ? signupFormState.city.errorMessage
                            : null,
                    icon: FontAwesomeIcons.city,
                    onChanged: (newValue) {
                      ref
                          .read(signupFormProvider.notifier)
                          .cityChanged(newValue);
                    },
                    onSubmitForm:
                        (_) => _submitFormAction(authStatusNotifier, ref),
                  ),
                  CustomTextFormField(
                    initialValue: "",
                    autoFillHints: const [AutofillHints.newPassword],
                    label: "login_screen_password_text".tr(),
                    trailingIcon: IconButton(
                      onPressed: () {
                        ref.read(showPasswordProvider.notifier).state =
                            !showPassword;
                      },
                      icon: showHidePasswordIcon(showPassword),
                    ),
                    errorMessage:
                        signupFormState.isPosting
                            ? signupFormState.password.errorMessage
                            : null,
                    icon: Icons.lock,
                    obscureText: !showPassword,
                    onChanged: (newValue) {
                      final signupFormState = ref.read(
                        signupFormProvider.notifier,
                      );
                      signupFormState.passwordChanged(newValue);
                    },
                    onSubmitForm:
                        (_) => _submitFormAction(authStatusNotifier, ref),
                  ),
                  CustomTextFormField(
                    initialValue: "",
                    label: "login_screen_repeat_password_text".tr(),
                    trailingIcon: IconButton(
                      onPressed: () {
                        ref.read(showRepeatPasswordProvider.notifier).state =
                            !showRepeatPassword;
                      },
                      icon: showHidePasswordIcon(showRepeatPassword),
                    ),
                    errorMessage:
                        signupFormState.isPosting
                            ? signupFormState.repeatPassword.errorMessage
                            : null,
                    icon: Icons.lock,
                    obscureText: !showRepeatPassword,
                    onChanged: (newValue) {
                      final signupFormState = ref.read(
                        signupFormProvider.notifier,
                      );
                      signupFormState.repeatPasswordChanged(newValue);
                    },
                    onSubmitForm:
                        (_) => _submitFormAction(authStatusNotifier, ref),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("login_screen_have_account_text").tr(),
                      const SizedBox(width: 2),
                      TextButton(
                        onPressed: () => _showLoginOrSignupAction(),
                        child: const Text(
                          "login_screen_login_title_with_args",
                        ).tr(args: ["!"]),
                      ),
                    ],
                  ),
                  FilledButton.tonal(
                    onPressed: () => _submitFormAction(authStatusNotifier, ref),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("login_screen_signup_title").tr(),
                        const SizedBox(width: 6),
                        ZoomIn(
                          child: const Icon(
                            Icons.check_circle_outline_outlined,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void>? _submitFormAction(AuthState authStatusNotifier, WidgetRef ref) {
    return authStatusNotifier.authStatus == AuthStatus.checking
        ? null
        : _signupUsingPassword(ref);
  }

  void _showLoginOrSignupAction() {
    ref.read(showLoginSignupProvider.notifier).update((state) => !state);
  }

  Future<void> _signupUsingPassword(WidgetRef ref) async {
    final signupFormNotifier = ref.read(signupFormProvider.notifier);
    final signupFormState = ref.read(signupFormProvider);
    final authStatusNotifier = ref.read(authStatusProvider.notifier);
    final loadUsers = ref.read(loadUserProvider.notifier);
    final signedInUserNotifier = ref.read(signedInUserProvider.notifier);
    final colors = Theme.of(ref.context).colorScheme;

    if (signupFormState.username.value.trim().toLowerCase() ==
        anonymousText.trim().toLowerCase()) {
      hardVibration();
      showCustomSnackbar(
        ref.context,
        'login_screen_username_already_exists_snackbar'.tr(
          args: [signupFormState.username.value],
        ),
        backgroundColor: colors.error,
      );
      return;
    }

    signupFormNotifier.onSubmit(
      onPasswordMismatch: () {
        showCustomSnackbar(
          ref.context,
          'login_screen_password_mismatch_snackbar_text'.tr(),
          backgroundColor: Colors.yellow[300],
          textColor: Colors.black,
        );
      },
      onSubmit: () async {
        // 1) First, try creating via Firebase Auth
        await authStatusNotifier.signupUsingPassword(
          signupFormState.email.value,
          signupFormState.password.value,
          onEmailAlreadyExists: () {
            // If Firebase Auth already has a user with that email,
            // show this snackbar:
            hardVibration();
            showCustomSnackbarWithActions(
              ref.context,
              'login_signupe_email_already_exists_error'.tr(
                args: [signupFormState.email.value],
              ),
              actionLabel: 'yes_text'.tr(),
              onActionTap: () => _showLoginOrSignupAction(),
              backgroundColor: colors.error,
            );
          },
          onAuthSuccess: (userCredential) async {
            if (userCredential == null) {
              return false;
            }

            final uid = userCredential.user?.uid;
            if (uid == null) return false;

            // 2) Now build our domain‐level User and try to persist to Firestore:
            final newUser = User(
              id: uid,
              name: signupFormState.name.value,
              surname: signupFormState.surname.value,
              email: signupFormState.email.value,
              username: signupFormState.username.value,
              city: signupFormState.city.value,
              country: signupFormState.country.value,
            );

            // 3) Attempt to create the Firestore document inside a transaction.
            try {
              return await loadUsers.createUser(user: newUser, authId: uid).then((
                createdUser,
              ) async {
                // If we succeed, createdUser != null. We can update the signed‐in user and navigate.
                signedInUserNotifier.update((state) => createdUser);
                if (createdUser != null) return true;
                return false;
                //final isEmailVerified = await authPasswordProvider.isUserEmailVerified();

                /*if (!isEmailVerified && ref.context.mounted) {
                    ref.context.go(verifyEmailPath, extra: {'newUser': createdUser});
                  }*/
              });
            } on EmailAlreadyExistsException {
              // This should be very rare, because we just signed up via Firebase Auth,
              // but if somehow Firestore reject in the same transaction, show a snackbar:
              hardVibration();
              showCustomSnackbarWithActions(
                ref.context,
                'login_signupe_email_already_exists_error'.tr(
                  args: [signupFormState.email.value],
                ),
                actionLabel: 'yes_text'.tr(),
                onActionTap: () => _showLoginOrSignupAction(),
                backgroundColor: colors.error,
              );
              return false;
            } on UsernameAlreadyExistsException {
              // If Firestore says “username” is already taken, show a different snackbar:
              hardVibration();
              showCustomSnackbar(
                ref.context,
                'login_screen_username_already_exists_snackbar'.tr(
                  args: [signupFormState.username.value],
                ),
                backgroundColor: colors.error,
              );
              return false;
            } on GenericUserCreationException catch (genericErr) {
              // Some other Firestore error: show a generic “try again” snackbar.
              showCustomSnackbar(
                ref.context,
                'login_signupe_unknown_error_error'.tr(
                  args: [genericErr.message],
                ),
                backgroundColor: colors.error,
              );
              return false;
            } catch (e) {
              // Unexpected error (unlikely), show a catch‐all message.
              logger.e('Errore brutto: $e');
              hardVibration();
              showCustomSnackbar(
                ref.context,
                'login_signupe_unknown_error_error'.tr(),
                backgroundColor: colors.error,
              );
              return false;
            }
            // Ensure a bool is always returned
          },
        );
      },
    );
  }
}
