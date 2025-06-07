import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spotted/config/config.dart';
import 'package:spotted/presentation/navigation/navigation.dart';
import 'package:spotted/presentation/providers/providers.dart';
import 'package:spotted/presentation/providers/utility/load_images_provider.dart';
import 'package:spotted/presentation/widgets/widgets.dart';

class AddProfileInfoScreen extends ConsumerStatefulWidget {
  static const name = 'AddProfileInfoScreen';

  const AddProfileInfoScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddProfileInfoScreenState();
}

class _AddProfileInfoScreenState extends ConsumerState<AddProfileInfoScreen> {
  @override
  void initState() {
    super.initState();
    Future(() {
      final signedInUser = ref.read(signedInUserProvider);
      if (signedInUser == null) return;
      ref.read(editProfileFormProvider.notifier).initFormField(signedInUser);
      
    });
  }

  @override
  Widget build(BuildContext context) {
    final signedInUser = ref.watch(signedInUserProvider);
    final editProfileState = ref.watch(editProfileFormProvider);
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Info Profilo').tr(),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: IconButton.filledTonal(
              tooltip: ("edit_info_screen_update_info_btn_text").tr(),
              onPressed: () => _submitFormAction(),
              icon: const Icon(Icons.check_circle_outline_outlined),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            spacing: 20,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              RoundedBordersPicture(
                urlPicture: signedInUser?.profileImageUrl ?? '',
                imageBytes: editProfileState.profileImageBytes,
                borderRadius: 10,
                height: 300,
                width: size.width,
              ),

              IconButton.outlined(
                tooltip: 'edit_info_screen_load_profile_pic_tooltip_text'.tr(),
                onPressed: () {
                  _displayPickImageDialog((picList) {
                    _imagesChosenAction(0, picList);
                  });
                },
                icon: SizedBox.square(
                  dimension: 50,
                  child: Icon(Icons.photo, size: 20),
                ),
              ),

              CustomTextFormField(
                controller: editProfileState.nameController,
                autoFillHints: const [AutofillHints.name],
                label: "login_screen_name_text".tr(),
                formatter: FormInputFormatters.text,
                errorMessage:
                    editProfileState.isPosting
                        ? editProfileState.name.errorMessage
                        : null,
                icon: Icons.person,
                onChanged: (newValue) {
                  final signupFormState = ref.read(signupFormProvider.notifier);
                  signupFormState.nameChanged(newValue);
                },
                onSubmitForm: () => _submitFormAction(),
              ),
              CustomTextFormField(
                controller: editProfileState.surnameController,
                autoFillHints: const [AutofillHints.familyName],
                label: "login_screen_surname_text".tr(),
                formatter: FormInputFormatters.text,
                errorMessage:
                    editProfileState.isPosting
                        ? editProfileState.surname.errorMessage
                        : null,
                icon: Icons.person,
                onChanged: (newValue) {
                  final signupFormState = ref.read(signupFormProvider.notifier);
                  signupFormState.surnameChanged(newValue);
                },
                onSubmitForm: () => _submitFormAction(),
              ),
              CustomTextFormField(
                enabled: false,
                controller: editProfileState.emailController,
                autoFillHints: const [AutofillHints.email],
                label: "login_screen_email_text".tr(),
                formatter: FormInputFormatters.email,
                errorMessage:
                    editProfileState.isPosting
                        ? editProfileState.email.errorMessage
                        : null,
                icon: Icons.email_outlined,
                onChanged: (newValue) {
                  final signupFormState = ref.read(signupFormProvider.notifier);
                  signupFormState.emailChanged(newValue);
                },
                onSubmitForm: () => _submitFormAction(),
              ),
              CustomTextFormField(
                enabled: false,
                controller: editProfileState.usernameController,
                autoFillHints: const [AutofillHints.newUsername],
                label: "login_screen_username_text".tr(),
                formatter: FormInputFormatters.text,
                errorMessage:
                    editProfileState.isPosting
                        ? editProfileState.username.errorMessage
                        : null,
                icon: FontAwesomeIcons.userNinja,
                onChanged: (newValue) {
                  ref
                      .read(signupFormProvider.notifier)
                      .usernameChanged(newValue);
                },
                onSubmitForm: () => _submitFormAction(),
              ),
              CountrySelector(
                controller: editProfileState.countryController,
                items: countryMenuItems,
              ),
              CustomTextFormField(
                controller: editProfileState.cityController,
                autoFillHints: const [AutofillHints.addressCity],
                label: "login_screen_city_text".tr(),
                formatter: FormInputFormatters.text,
                errorMessage:
                    editProfileState.isPosting
                        ? editProfileState.city.errorMessage
                        : null,
                icon: FontAwesomeIcons.city,
                onChanged: (newValue) {
                  ref.read(signupFormProvider.notifier).cityChanged(newValue);
                },
                onSubmitForm: () => _submitFormAction(),
              ),

              FilledButton.tonal(
                onPressed: editProfileState.isPosting ? null : () => _submitFormAction(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("edit_info_screen_update_info_btn_text").tr(),
                    const SizedBox(width: 6),
                    ZoomIn(
                      child: const Icon(Icons.check_circle_outline_outlined),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  void _displayPickImageDialog(Function(List<XFile>?) onImagesChosen) {
    final context = ref.context;
    final picker = ref.read(imagePickerProvider);

    if (!context.mounted) return;
    displayPickImageDialog(
      context,
      onGalleryChosen: () async {
        await picker.selectPhotos(limit: 1).then((files) {
          onImagesChosen(files.cast<XFile>());
          popContext(context);
        });
      },
      onTakePicChosen: () async {
        await picker.takePhoto().then((file) {
          onImagesChosen([file]);
          popContext(context);
        });
      },
    );
  }

  Future<void> _imagesChosenAction(int index, List<XFile>? imagesFiles) async {
    if (imagesFiles == null) return;
    final editProfileNotifier = ref.read(editProfileFormProvider.notifier);

    for (var i in imagesFiles) {
      editProfileNotifier.onProfilePicFileChanged(i);
      final imageBytes = await i.readAsBytes();
      editProfileNotifier.onProfilePicBytesChanged(imageBytes);
    }
  }

  Future<String> _imageUploadAction() async {
    final editProfileFormState = ref.read(editProfileFormProvider);
    if (editProfileFormState.profileImageFile == null) return "";
    final filename =
        editProfileFormState.profileImageFile!.name +
        Timestamp.now().toString();
    String picUrl = await ref
        .read(loadImagesProvider)
        .uploadImage(
          picBytes: editProfileFormState.profileImageBytes!,
          filename: filename,
        );
    return picUrl;
  }

  void _submitFormAction() {
    final signedInUser = ref.read(signedInUserProvider);
    final editProfileState = ref.read(editProfileFormProvider);
    final editProfileNotifier = ref.read(editProfileFormProvider.notifier);
    final userRepo = ref.read(usersRepositoryProvider);
    if (!(signedInUser?.isProfileUrlValid ?? false) ||
        editProfileState.profileImageBytes == null) {
      mediumVibration();
      showCustomSnackbar(
        context,
        'edit_info_screen_load_profile_pic_snackbar_text'.tr(),
        backgroundColor: colorWarning,
      );
      return;
    }

    editProfileNotifier.onSubmit(
      onSubmit: () async {
        final imageUrl = await _imageUploadAction();
        final updatedUser = signedInUser?.copyWith(
          name: editProfileState.name.value,
          surname: editProfileState.surname.value,
          city: editProfileState.city.value,
          country: editProfileState.country.value,
          profileImageUrl: imageUrl.isNotEmpty ? imageUrl : null,
        );

        if (updatedUser == null) return;
        userRepo.updateUser(updatedUser);
      },
    );
  }
}
