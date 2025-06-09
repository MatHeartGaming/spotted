// ignore_for_file: use_build_context_synchronously

import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spotted/config/config.dart';
import 'package:spotted/domain/datasources/exceptions/exceptions.dart';
import 'package:spotted/domain/models/models.dart';
import 'package:spotted/infrastructure/datasources/services/load_images_datasource_impl.dart';
import 'package:spotted/presentation/providers/forms/states/form_status.dart';
import 'package:spotted/presentation/providers/providers.dart';
import 'package:spotted/presentation/widgets/widgets.dart';

class CreateCommunityScreen extends ConsumerStatefulWidget {
  static const name = 'CreateCommunityScreen';

  final Community? community;

  const CreateCommunityScreen({super.key, this.community});

  @override
  CreateCommunityScreenState createState() => CreateCommunityScreenState();
}

class CreateCommunityScreenState extends ConsumerState<CreateCommunityScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.community != null) {
      Future(() {
        ref
            .read(createCommunityFormProvder.notifier)
            .initForm(widget.community!);
      });
    }
  }

  void _refreshCommunityPage() {
    if (widget.community == null) return;
    ref
        .read(loadCommunitiesProvider.notifier)
        .loadUsersCommunityById(widget.community?.id ?? '')
        .then((communityFound) {
          if (communityFound == null) return;
          ref
              .read(communityScreenCurrentCommunityProvider.notifier)
              .update((state) => communityFound);
        });
  }

  @override
  Widget build(BuildContext context) {
    final communityFormState = ref.watch(createCommunityFormProvder);
    final size = MediaQuery.sizeOf(context);
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        _refreshCommunityPage();
      },
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          appBar: AppBar(
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton.filledTonal(
                  tooltip: 'close_text'.tr(),
                  onPressed: () => context.pop(),
                  icon: Icon(Icons.close),
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 12,
                children: [
                  SizedBox(height: 8),

                  CustomTextFormField(
                    label:
                        'create_community_screen_title_textfield_placeholder'
                            .tr(),
                    controller: communityFormState.titleController,
                    icon: Icons.title_outlined,
                    errorMessage: communityFormState.title.errorMessage,
                    onSubmitForm: (_) => _onSubmit(),
                    onChanged: (newValue) {
                      ref
                          .read(createCommunityFormProvder.notifier)
                          .onTitleChanged(newValue);
                    },
                  ),
                  CustomTextFormField(
                    label:
                        'create_community_screen_content_textfield_placeholder'
                            .tr(),
                    controller: communityFormState.descriptionController,
                    icon: Icons.title_outlined,
                    errorMessage: communityFormState.description.errorMessage,
                    onSubmitForm: (_) => _onSubmit(),
                    onChanged: (newValue) {
                      ref
                          .read(createCommunityFormProvder.notifier)
                          .onDescriptionChanged(newValue);
                    },
                  ),
                  CustomTextFormField(
                    label:
                        'create_community_screen_admins_textfield_placeholder'
                            .tr(),
                    icon: Icons.title_outlined,
                    errorMessage: null,
                    onSubmitForm: (_) => _onSubmit(),
                    onChanged: (newValue) {
                      ref
                          .read(communityUsersSearchBarTextProvider.notifier)
                          .update((state) => newValue);
                    },
                  ),

                  SizedBox(height: 120, child: _showAllUsers()),

                  SizedBox(height: 30),

                  GridImagesWidget(
                    images: communityFormState.imagesBytes ?? [],
                    imagesUrl: communityFormState.imagesUrl ?? [],
                    onImageDelete: (deleteIndex) {
                      ref
                          .read(createCommunityFormProvder.notifier)
                          .removeImageAt(deleteIndex);
                    },
                    onImageTap:
                        (index) => showImagesGalleryBytes(
                          context,
                          communityFormState.imagesBytes ?? [],
                        ),
                  ),

                  Visibility(
                    visible:
                        ((communityFormState.imagesUrl?.length ?? 0) +
                            (communityFormState.imagesBytes?.length ?? 0)) <
                        1,
                    child: FadeIn(
                      duration: Duration(milliseconds: 300),
                      child: IconButton.outlined(
                        tooltip:
                            'create_post_screen_add_images_btn_tooltip'.tr(),
                        onPressed: () {
                          _displayPickImageDialog((pic) {
                            _imagesChosenAction(0, pic);
                          });
                        },
                        icon: SizedBox.square(
                          dimension: 50,
                          child: Icon(Icons.photo, size: 20),
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed:
                        communityFormState.isPosting ? null : () => _onSubmit(),
                    child: Text('create_post_screen_publish_btn_text').tr(),
                  ),
                  SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _showAllUsers() {
    final usersFound = ref.watch(ownerUsersSearchBarProvider);
    final communityFormState = ref.watch(createCommunityFormProvder);

    return HorizontalProductList(
      usersList: [
        ...usersFound,
        User.empty(
          name: 'Mat',
          surname: 'B',
          username: 'Mammmdfdfddfd',
          email: 'm@ciao.com',
        ),
      ],
      onItemTap: (user) {
        if (!user.isEmpty) return;
        ref.read(createCommunityFormProvder.notifier).onAddAdmin(user.id);
      },
      sectionItemBuilder: (user) {
        return UserMiniItem(
          profileImageUrl: user.profileImageUrl,
          username: user.atUsername,
          isSelected: communityFormState.adminsRefs.contains(user.id),
          onTap: () {
            // only fire for non‐empty users
            if (!user.isEmpty) {
              ref.read(createCommunityFormProvder.notifier).onAddAdmin(user.id);
            }
          },
        );
      },
    );
  }

  Future<void> _imagesChosenAction(int index, XFile? imageFile) async {
    if (imageFile == null) return;
    final createCommunityNotifier = ref.read(
      createCommunityFormProvder.notifier,
    );

    createCommunityNotifier.imagesFilesChanged(imageFile);
    final imageBytes = await imageFile.readAsBytes();
    createCommunityNotifier.imagesBytesChanged(imageBytes);
  }

  void _displayPickImageDialog(Function(XFile?) onImagesChosen) {
    final context = ref.context;
    final picker = ref.read(imagePickerProvider);

    if (!context.mounted) return;
    displayPickImageDialog(
      context,
      onGalleryChosen: () async {
        await picker.selectPhoto().then((file) {
          onImagesChosen(file);
          //popContext(context);
        });
      },
      onTakePicChosen: () async {
        await picker.takePhoto().then((files) {
          onImagesChosen(files);
          //popContext(context);
        });
      },
    );
  }

  Future<String> _imageUploadAction() async {
    final signedInUser = ref.read(signedInUserProvider);
    if (signedInUser == null || signedInUser.isEmpty) return "";
    final formState = ref.read(createCommunityFormProvder);
    if (formState.imagesFile == null ||
        (formState.imagesFile?.isEmpty ?? true)) {
      return "";
    }
    final filename =
        formState.imagesFile!.first.name + Timestamp.now().toString();
    if (formState.imagesBytes == null &&
        (formState.imagesBytes?.isEmpty ?? true)) {
      return "";
    }
    String picUrl = await ref
        .read(loadImagesProvider)
        .uploadImage(
          picBytes: formState.imagesBytes!.first,
          usernamePath: ref.read(signedInUserProvider)?.username ?? 'username',
          filename: filename,
          picType: PicType.communityPics,
        );
    return picUrl;
  }

  void _updateCommunity() {
    if (widget.community == null) return;
    final createCommunityFormNotifier = ref.read(
      createCommunityFormProvder.notifier,
    );
    final formState = ref.read(createCommunityFormProvder);

    if (widget.community?.pictureUrl == null &&
        (formState.imagesFile == null ||
            (formState.imagesBytes?.isEmpty ?? true))) {
      mediumVibration();
      showCustomSnackbar(
        context,
        'create_community_screen_upload_photo_error_snackbar_text'.tr(),
        backgroundColor: colorWarning,
      );
      return;
    }

    createCommunityFormNotifier.validateFields(status: FormStatus.posting);

    if (!formState.isValid) {
      mediumVibration();
      showCustomSnackbar(
        context,
        'create_post_screen_check_fields_snackbar_text'.tr(),
        backgroundColor: colorWarning,
      );
      createCommunityFormNotifier.resetFormStatus();
      return;
    }

    createCommunityFormNotifier.onSumbit(
      onSubmit: () async {
        final communityPic = await _imageUploadAction();
        final communityToUpdate = widget.community?.copyWith(
          title: formState.title.value,
          description: formState.description.value,
          admins: formState.adminsRefs,
          pictureUrl: communityPic.isEmpty ? null : communityPic,
        );
        if (communityToUpdate == null) return;
        final loadCommunity = ref.read(loadCommunitiesProvider.notifier);
        loadCommunity
            .updateCommunity(communityToUpdate)
            .then((updatedComm) {
              if (updatedComm == null) {
                _handleCommunityErrors(null, communityToUpdate);
                return;
              }
              ref
                  .read(communityScreenCurrentCommunityProvider.notifier)
                  .update((state) => updatedComm);
              smallVibration();
              showCustomSnackbar(
                context,
                'create_community_screen_update_community_success_snackbar_text'
                    .tr(),
                backgroundColor: colorSuccess,
              );
              context.pop();
            })
            .catchError((error) {
              _handleCommunityErrors(error, communityToUpdate);
            })
            .whenComplete(() {
              createCommunityFormNotifier.resetFormStatus();
            });
      },
    );
  }

  void _onSubmit() {
    if (widget.community != null) {
      _updateCommunity();
      return;
    }
    final createCommunityFormNotifier = ref.read(
      createCommunityFormProvder.notifier,
    );
    final formState = ref.read(createCommunityFormProvder);

    if (widget.community?.pictureUrl == null &&
        (formState.imagesFile == null ||
            (formState.imagesBytes?.isEmpty ?? true))) {
      mediumVibration();
      showCustomSnackbar(
        context,
        'create_community_screen_upload_photo_error_snackbar_text'.tr(),
        backgroundColor: colorWarning,
      );
      return;
    }

    createCommunityFormNotifier.validateFields(status: FormStatus.posting);

    if (!formState.isValid) {
      mediumVibration();
      showCustomSnackbar(
        context,
        'create_post_screen_check_fields_snackbar_text'.tr(),
        backgroundColor: colorWarning,
      );
      createCommunityFormNotifier.resetFormStatus();
      return;
    }

    final userRepo = ref.read(usersRepositoryProvider);
    final signedInUserNotifier = ref.read(signedInUserProvider.notifier);
    createCommunityFormNotifier.onSumbit(
      onSubmit: () async {
        final signedInUser = ref.read(signedInUserProvider);
        if (signedInUser == null) return;
        final communityPic = await _imageUploadAction();
        final newCommunity = Community(
          createdById: signedInUser.id,
          createdByUsername: signedInUser.username,
          title: formState.title.value,
          description: formState.description.value,
          admins: [signedInUser.id, ...(formState.adminsRefs)],
          pictureUrl: communityPic.isEmpty ? null : communityPic,
          subscribed: [signedInUser.id],
        );
        final loadCommunity = ref.read(loadCommunitiesProvider.notifier);
        loadCommunity
            .createCommunity(newCommunity)
            .then((createdCommunity) {
              if (createdCommunity == null) {
                _handleCommunityErrors(null, newCommunity);
                return;
              }
              final userToUpdate = signedInUser.copyWith(
                communitiesSubs: [createdCommunity.id],
              );
              userRepo.updateUser(userToUpdate);
              signedInUserNotifier.update((state) => userToUpdate);
              // success path
              smallVibration();
              showCustomSnackbar(
                context,
                'create_community_screen_community_success_snackbar_text'.tr(),
                backgroundColor: colorSuccess,
              );
              context.pop();
            })
            .catchError((error) {
              _handleCommunityErrors(error, newCommunity);
            })
            .whenComplete(() {
              createCommunityFormNotifier.resetFormStatus();
            });
      },
    );
  }

  void _handleCommunityErrors(error, Community newCommunity) {
    logger.e(error);
    if (error is CommunityAlreadyExistsException) {
      mediumVibration();
      showCustomSnackbar(
        context,
        'community_already_exists_exception'.tr(args: [newCommunity.title]),
        backgroundColor: colorWarning,
      );
    } else {
      hardVibration();
      showCustomSnackbar(
        context,
        'create_community_screen_community_error_snackbar_text'.tr(),
        backgroundColor: colorNotOkButton,
      );
    }
  }
}
