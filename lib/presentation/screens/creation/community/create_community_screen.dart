// ignore_for_file: use_build_context_synchronously

import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spotted/config/config.dart';
import 'package:spotted/domain/datasources/exceptions/exceptions.dart';
import 'package:spotted/domain/models/models.dart';
import 'package:spotted/presentation/providers/forms/states/form_status.dart';
import 'package:spotted/presentation/providers/providers.dart';
import 'package:spotted/presentation/widgets/widgets.dart';

class CreateCommunityScreen extends ConsumerWidget {
  static const name = 'CreateCommunityScreen';

  const CreateCommunityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final communityFormState = ref.watch(createCommunityFormProvder);
    return GestureDetector(
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
                  onSubmitForm: () => _onSubmit(ref),
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
                  onSubmitForm: () => _onSubmit(ref),
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
                  onSubmitForm: () => _onSubmit(ref),
                  onChanged: (newValue) {
                    ref
                        .read(createCommunityFormProvder.notifier)
                        .onAddAdmin(newValue);
                  },
                ),

                SizedBox(height: 30),

                GridImagesWidget(
                  images: communityFormState.imagesBytes ?? [],
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
                      tooltip: 'create_post_screen_add_images_btn_tooltip'.tr(),
                      onPressed: () {
                        _displayPickImageDialog(ref, (pic) {
                          _imagesChosenAction(ref, 0, pic);
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
                      communityFormState.isPosting
                          ? null
                          : () => _onSubmit(ref),
                  child: Text('create_post_screen_publish_btn_text').tr(),
                ),
                SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _imagesChosenAction(
    WidgetRef ref,
    int index,
    XFile? imageFile,
  ) async {
    if (imageFile == null) return;
    final createCommunityNotifier = ref.read(
      createCommunityFormProvder.notifier,
    );

    createCommunityNotifier.imagesFilesChanged(imageFile);
    final imageBytes = await imageFile.readAsBytes();
    createCommunityNotifier.imagesBytesChanged(imageBytes);
  }

  void _displayPickImageDialog(WidgetRef ref, Function(XFile?) onImagesChosen) {
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

  void _onSubmit(WidgetRef ref) {
    final context = ref.context;
    final createCommunityFormNotifier = ref.read(
      createCommunityFormProvder.notifier,
    );
    final formState = ref.read(createCommunityFormProvder);

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
        final signedInUser = ref.read(signedInUserProvider);
        final newCommunity = Community(
          createdById: signedInUser?.id ?? '',
          createdByUsername: signedInUser?.username ?? '',
          title: formState.title.value,
          description: formState.description.value,
          admins: formState.adminsRefs ?? [],
        );
        final loadCommunity = ref.read(loadCommunitiesProvider.notifier);
        loadCommunity
            .createCommunity(newCommunity)
            .then((createdCommunity) {
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
              logger.e(error);
              if (error is CommunityAlreadyExistsException) {
                mediumVibration();
                showCustomSnackbar(
                  context,
                  'community_already_exists_exception'.tr(
                    args: [newCommunity.title],
                  ),
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
            })
            .whenComplete(() {
              createCommunityFormNotifier.resetFormStatus();
            });
      },
    );
  }
}
