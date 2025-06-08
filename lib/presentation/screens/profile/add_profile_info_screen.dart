import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spotted/config/config.dart';
import 'package:spotted/domain/models/models.dart';
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
      ref
          .read(featureRepositoryProvider)
          .getFeaturesByIds(signedInUser.featureRefs)
          .then((features) {
            ref
                .read(assignedFeaturesProvider.notifier)
                .update((state) => features);
          });
      ref
          .read(interestsRepositoryProvider)
          .getInterestsByIds(signedInUser.interestsRefs)
          .then((interests) {
            ref
                .read(assignedInterestProvider.notifier)
                .update((state) => interests);
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    final signedInUser = ref.watch(signedInUserProvider);
    final editProfileState = ref.watch(editProfileFormProvider);
    final assignedFeatures = ref.watch(assignedFeaturesProvider);
    final assignedInterests = ref.watch(assignedInterestProvider);
    final loadFeaturesState = ref.watch(loadFeaturesProvider);
    final loadInterestsState = ref.watch(loadInterestsProvider);

    final assignedFeatureNames =
        assignedFeatures.map((f) => f.name.toLowerCase().trim()).toSet();

    // only show features whose name isn’t already assigned
    final unassignedFeatures =
        loadFeaturesState.featuresByName
            .where(
              (f) =>
                  !assignedFeatureNames.contains(f.name.toLowerCase().trim()),
            )
            .toList();

    final assignedInterestsNames =
        assignedInterests.map((f) => f.name.toLowerCase().trim()).toSet();

    // only show features whose name isn’t already assigned
    final unassignedInterests =
        loadInterestsState.interestsByName
            .where(
              (f) =>
                  !assignedInterestsNames.contains(f.name.toLowerCase().trim()),
            )
            .toList();

    final size = MediaQuery.sizeOf(context);
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
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
                GestureDetector(
                  onTap:
                      () => _displayPickImageDialog((picList) {
                        _imagesChosenAction(0, picList);
                      }),
                  child: RoundedBordersPicture(
                    urlPicture: signedInUser?.profileImageUrl ?? '',
                    imageBytes: editProfileState.profileImageBytes,
                    borderRadius: 10,
                    height: 300,
                    width: size.width,
                  ),
                ),

                IconButton.outlined(
                  tooltip:
                      'edit_info_screen_load_profile_pic_tooltip_text'.tr(),
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
                    final signupFormState = ref.read(
                      editProfileFormProvider.notifier,
                    );
                    signupFormState.nameChanged(newValue);
                  },
                  onSubmitForm: (_) => _submitFormAction(),
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
                    final signupFormState = ref.read(
                      editProfileFormProvider.notifier,
                    );
                    signupFormState.surnameChanged(newValue);
                  },
                  onSubmitForm: (_) => _submitFormAction(),
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
                    final signupFormState = ref.read(
                      editProfileFormProvider.notifier,
                    );
                    signupFormState.emailChanged(newValue);
                  },
                  onSubmitForm: (_) => _submitFormAction(),
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
                        .read(editProfileFormProvider.notifier)
                        .usernameChanged(newValue);
                  },
                  onSubmitForm: (_) => _submitFormAction(),
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
                    ref
                        .read(editProfileFormProvider.notifier)
                        .cityChanged(newValue);
                  },
                  onSubmitForm: (_) => _submitFormAction(),
                ),

                SizedBox(height: 10),
                CustomTextFormField(
                  label: 'edit_info_screen_features_text'.tr(),
                  formatter: FormInputFormatters.text,
                  icon: Icons.featured_play_list,
                  onChanged: (newValue) {
                    final featuresNotifier = ref.read(
                      loadFeaturesProvider.notifier,
                    );
                    final editProfileNotifier = ref.read(
                      editProfileFormProvider.notifier,
                    );
                    editProfileNotifier.onFeatureSearchChanged(
                      newValue,
                      (search) => featuresNotifier.getFeaturesByName(search),
                    );
                  },
                  onSubmitForm: (newFeature) {
                    _submitNewFeaureAction(loadFeaturesState, newFeature);
                  },
                ),

                Text(
                  'edit_info_screen_your_features_text',
                ).tr(args: [assignedFeatures.length.toString()]),
                ChipsGridView(
                  chips: [...assignedFeatures.map((e) => e.name)],
                  onDelete: () {},
                  onTap: (oldFeature) {
                    // Delete
                    ref
                        .read(assignedFeaturesProvider.notifier)
                        .update(
                          (state) =>
                              state.where((f) => f.name != oldFeature).toList(),
                        );
                  },
                ),

                SizedBox(height: 10),
                Text(
                  'edit_info_screen_features_found_text',
                ).tr(args: [unassignedFeatures.length.toString()]),
                ChipsGridView(
                  chips: unassignedFeatures.map((e) => e.name).toList(),
                  onDelete: () {},
                  onTap: (name) {
                    // we know it isn’t in assignedNames, but check again just in case
                    if (!assignedFeatureNames.contains(
                      name.toLowerCase().trim(),
                    )) {
                      final feature = unassignedFeatures.firstWhere(
                        (f) => f.name == name,
                        orElse: () => Feature(name: name),
                      );
                      ref
                          .read(assignedFeaturesProvider.notifier)
                          .update((state) => [feature, ...state]);
                    }
                  },
                ),

                // Interests
                SizedBox(height: 10),
                CustomTextFormField(
                  label: 'edit_info_screen_interests_text'.tr(),
                  formatter: FormInputFormatters.text,
                  icon: Icons.featured_play_list,
                  onChanged: (newValue) {
                    final interstsNotifier = ref.read(
                      loadInterestsProvider.notifier,
                    );
                    final editProfileNotifier = ref.read(
                      editProfileFormProvider.notifier,
                    );
                    editProfileNotifier.onInterstsSearchChanged(
                      newValue,
                      (search) => interstsNotifier.getInterestsByName(search),
                    );
                  },
                  onSubmitForm: (newInterest) {
                    _submitNewInterestAction(loadInterestsState, newInterest);
                  },
                ),
                Text(
                  'edit_info_screen_your_interests_text',
                ).tr(args: [assignedInterests.length.toString()]),
                ChipsGridView(
                  chips: [...assignedInterests.map((e) => e.name)],
                  onDelete: () {},
                  onTap: (oldInterest) {
                    // Delete
                    ref
                        .read(assignedInterestProvider.notifier)
                        .update(
                          (state) =>
                              state
                                  .where((f) => f.name != oldInterest)
                                  .toList(),
                        );
                  },
                ),

                SizedBox(height: 10),
                Text(
                  'edit_info_screen_interests_found_text',
                ).tr(args: [unassignedInterests.length.toString()]),
                ChipsGridView(
                  chips: unassignedInterests.map((e) => e.name).toList(),
                  onDelete: () {},
                  onTap: (name) {
                    // we know it isn’t in assignedNames, but check again just in case
                    if (!assignedInterestsNames.contains(
                      name.toLowerCase().trim(),
                    )) {
                      final interest = unassignedInterests.firstWhere(
                        (f) => f.name == name,
                        orElse: () => Interest(name: name),
                      );
                      ref
                          .read(assignedInterestProvider.notifier)
                          .update((state) => [interest, ...state]);
                    }
                  },
                ),

                SizedBox(height: 50),

                FilledButton.tonal(
                  onPressed:
                      editProfileState.isPosting
                          ? null
                          : () => _submitFormAction(),
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
      ),
    );
  }

  void _submitNewFeaureAction(
    LoadFeaturesState loadFeaturesState,
    String newFeatureName,
  ) {
    final assigned = ref.read(assignedFeaturesProvider);
    final normalized = newFeatureName.toLowerCase().trim();

    // 1) Is it already in assigned?
    final already = assigned.any(
      (f) => f.name.toLowerCase().trim() == normalized,
    );
    if (already) {
      smallVibration();
      showCustomSnackbar(
        context,
        'edit_info_screen_feature_already_exits_text'.tr(
          args: [newFeatureName],
        ),
      );
      return;
    }

    // 2) Find in the search results (if present) or fallback to a new one
    final match = loadFeaturesState.featuresByName.firstWhere(
      (f) => f.name.toLowerCase().trim() == normalized,
      orElse: () => Feature(name: newFeatureName),
    );

    // 3) Add it
    ref
        .read(assignedFeaturesProvider.notifier)
        .update((state) => [match, ...state]);
  }

  void _submitNewInterestAction(
    LoadInterestsState loadInterestsState,
    String newInterestName,
  ) {
    final assigned = ref.read(assignedInterestProvider);
    final normalized = newInterestName.toLowerCase().trim();

    // 1) Is it already in assigned?
    final already = assigned.any(
      (f) => f.name.toLowerCase().trim() == normalized,
    );
    if (already) {
      smallVibration();
      showCustomSnackbar(
        context,
        'edit_info_screen_interest_already_exits_text'.tr(
          args: [newInterestName],
        ),
      );
      return;
    }

    // 2) Find in the search results (if present) or fallback to a new one
    final match = loadInterestsState.interestsByName.firstWhere(
      (f) => f.name.toLowerCase().trim() == normalized,
      orElse: () => Interest(name: newInterestName),
    );

    // 3) Add it
    ref
        .read(assignedInterestProvider.notifier)
        .update((state) => [match, ...state]);
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
          if(context.mounted) popContext(context);
        });
      },
      onTakePicChosen: () async {
        await picker.takePhoto().then((file) {
          onImagesChosen([file]);
          if(context.mounted) popContext(context);
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
          usernamePath: ref.read(signedInUserProvider)?.username ?? 'username',
          filename: filename,
        );
    return picUrl;
  }

  void _submitFormAction() {
    final signedInUser = ref.read(signedInUserProvider);
    final editProfileState = ref.read(editProfileFormProvider);
    final editProfileNotifier = ref.read(editProfileFormProvider.notifier);
    final userRepo = ref.read(usersRepositoryProvider);
    final featuresRepo = ref.read(featureRepositoryProvider);
    final interestRepo = ref.read(interestsRepositoryProvider);

    if (!(signedInUser?.isProfileUrlValid ?? false) &&
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

        // ─── FEATURES ────────────────────────────────────────────────
        // 1) Read the on‐screen list and split old vs new
        final assignedFeatures = ref.read(assignedFeaturesProvider);
        final oldFeatureIds =
            assignedFeatures.map((f) => f.id).whereType<String>().toList();
        final newFeatures =
            assignedFeatures.where((f) => f.id == null).toList();

        // 2) Only create if there are truly new ones
        List<Feature> createdFeatures = [];
        if (newFeatures.isNotEmpty) {
          createdFeatures = await featuresRepo.createFeaturesIfNotExist(
            newFeatures,
          );

          ref.read(assignedFeaturesProvider.notifier).update((state) {
            return state.map((f) {
              // replace “name‐only” placeholders with the real version from `createdFeatures`
              if (f.id == null) {
                return createdFeatures.firstWhere((c) => c.name == f.name);
              }
              return f;
            }).toList();
          });
        }

        // 3) Build the final list of featureRefs
        final finalFeatureRefs = [
          ...oldFeatureIds,
          ...createdFeatures.map(
            (f) => f.id!,
          ), // safe because newly created always get an ID
        ];

        // ─── INTERESTS ──────────────────────────────────────────────
        final assignedInterests = ref.read(assignedInterestProvider);
        final oldInterestIds =
            assignedInterests.map((i) => i.id).whereType<String>().toList();
        final newInterests =
            assignedInterests.where((i) => i.id == null).toList();

        List<Interest> createdInterests = [];
        if (newInterests.isNotEmpty) {
          createdInterests = await interestRepo.createInterestIfNotExist(
            newInterests,
          );

          ref.read(assignedInterestProvider.notifier).update((state) {
            return state.map((i) {
              if (i.id == null) {
                return createdInterests.firstWhere((c) => c.name == i.name);
              }
              return i;
            }).toList();
          });
        }

        final finalInterestRefs = [
          ...oldInterestIds,
          ...createdInterests.map((i) => i.id!),
        ];

        // ─── UPDATE USER ─────────────────────────────────────────────
        final updatedUser = signedInUser?.copyWith(
          name: editProfileState.name.value,
          surname: editProfileState.surname.value,
          city: editProfileState.city.value,
          country: editProfileState.country.value,
          profileImageUrl: imageUrl.isNotEmpty ? imageUrl : null,
          dateCreated: signedInUser.dateCreated,
          featureRefs: finalFeatureRefs,
          interestsRefs: finalInterestRefs,
        );

        if (updatedUser != null) {
          await userRepo
              .updateUser(updatedUser)
              .then((_) {
                showCustomSnackbar(
                  context,
                  'edit_info_screen_update_success_snackbar'.tr(),
                  backgroundColor: colorSuccess,
                );
              })
              .whenComplete(() {
                editProfileNotifier.resetFormStatus();
              });
        } else {
          editProfileNotifier.resetFormStatus();
        }
      },
    );
  }
}
