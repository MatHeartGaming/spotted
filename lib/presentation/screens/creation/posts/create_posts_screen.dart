// ignore_for_file: use_build_context_synchronously

import 'dart:math';

import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spotted/config/config.dart';
import 'package:spotted/domain/models/models.dart';
import 'package:spotted/infrastructure/datasources/services/load_images_datasource_impl.dart';
import 'package:spotted/presentation/providers/forms/states/form_status.dart';
import 'package:spotted/presentation/providers/providers.dart';
import 'package:spotted/presentation/widgets/widgets.dart';

class CreatePostsScreen extends ConsumerStatefulWidget {
  final Post? post;
  final String? communityId;
  static const name = 'CreatePostsScreen';

  const CreatePostsScreen({super.key, this.post, this.communityId});

  @override
  CreatePostsScreenState createState() => CreatePostsScreenState();
}

class CreatePostsScreenState extends ConsumerState<CreatePostsScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.post != null) {
      ref.read(createPostFormProvider.notifier).initPostForm(widget.post!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(createPostFormProvider);
    final community = ref.watch(communityScreenCurrentCommunityProvider);
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
                SlideInDown(
                  child: CustomTextFormField(
                    label:
                        'create_post_screen_title_textfield_placeholder'.tr(),
                    controller: formState.titleController,
                    icon: Icons.title_outlined,
                    errorMessage: formState.title.errorMessage,
                    onSubmitForm: (_) => _onSumbit(ref),
                    onChanged: (newValue) {
                      ref
                          .read(createPostFormProvider.notifier)
                          .onTitleChanged(newValue);
                    },
                  ),
                ),
                SlideInDown(
                  child: CustomTextFormField(
                    label:
                        'create_post_screen_content_textfield_placeholder'.tr(),
                    controller: formState.contentController,
                    icon: Icons.title_outlined,
                    errorMessage: formState.content.errorMessage,
                    onSubmitForm: (_) => _onSumbit(ref),
                    onChanged: (newValue) {
                      ref
                          .read(createPostFormProvider.notifier)
                          .onContentChanged(newValue);
                    },
                  ),
                ),
                SizedBox(height: 20),
                FadeIn(
                  child: GridImagesWidget(
                    images: formState.imagesBytes ?? [],
                    imagesUrl: formState.imagesUrl,
                    onImageDelete: (deleteIndex) {
                      ref
                          .read(createPostFormProvider.notifier)
                          .removeImageAt(deleteIndex);
                    },
                    onImageTap:
                        (index) => showImagesGalleryBytes(
                          context,
                          formState.imagesBytes ?? [],
                          initialIndex: index,
                        ),
                  ),
                ),
                Visibility(
                  visible:
                      ((formState.imagesUrl?.length ?? 0) +
                          (formState.imagesBytes?.length ?? 0)) <
                      5,
                  child: FadeIn(
                    duration: Duration(milliseconds: 300),
                    child: IconButton.outlined(
                      tooltip: 'create_post_screen_add_images_btn_tooltip'.tr(),
                      onPressed: () {
                        _displayPickImageDialog((picList) {
                          _imagesChosenAction(0, picList);
                        });
                      },
                      icon: SizedBox.square(
                        dimension: 50,
                        child: Icon(FontAwesomeIcons.photoFilm, size: 20),
                      ),
                    ),
                  ),
                ),

                FadeIn(
                  duration: Duration(milliseconds: 800),
                  child: Row(
                    spacing: 6,
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap:
                            () =>
                                _anonymousToggleAction(!formState.isAnonymous),
                        child: Icon(
                          formState.isAnonymous
                              ? anonymousIcon
                              : nonAnonymousIcon,
                        ),
                      ),
                      GestureDetector(
                        onTap:
                            () =>
                                _anonymousToggleAction(!formState.isAnonymous),
                        child:
                            Text(
                              'create_post_screen_post_anonymous_switch_text',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ).tr(),
                      ),
                      Switch.adaptive(
                        value: formState.isAnonymous,
                        applyCupertinoTheme: true,
                        onChanged: (newValue) {
                          _anonymousToggleAction(newValue);
                        },
                      ),
                    ],
                  ),
                ),

                FadeInUp(
                  child: ElevatedButton(
                    onPressed:
                        formState.isPosting ? null : () => _onSumbit(ref),
                    child:
                        widget.communityId == null
                            ? Text('create_post_screen_publish_btn_text').tr()
                            : Text(
                              'create_post_screen_publish_in_btn_text',
                            ).tr(args: [community.title]),
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

  void _anonymousToggleAction(bool newValue) {
    ref.read(createPostFormProvider.notifier).onAnonymousChange(newValue);
    if (newValue) {
      mediumVibration();
      showOkOnlyDialog(
        context,
        title: 'attention_text'.tr(),
        message: 'create_post_screen_post_anonymous_dialog_text'.tr(),
        onOkPressed: () {},
      );
    }
  }

  void _displayPickImageDialog(Function(List<XFile>?) onImagesChosen) {
    final context = ref.context;
    final picker = ref.read(imagePickerProvider);
    final formState = ref.read(createPostFormProvider);
    final currentCount =
        (formState.imagesUrl?.length ?? 0) +
        (formState.imagesBytes?.length ?? 0);
    // how many more the user can pick:
    final remaining = max(5 - currentCount, 0);

    if (!context.mounted) return;
    displayPickImageDialog(
      context,
      onGalleryChosen: () async {
        await picker.selectPhotos(limit: remaining).then((files) {
          onImagesChosen(files.cast<XFile>());
          //popContext(context);
        });
      },
      onTakePicChosen: () async {
        await picker.takePhoto().then((file) {
          onImagesChosen([file]);
          //popContext(context);
        });
      },
    );
  }

  Future<void> _imagesChosenAction(int index, List<XFile>? imagesFiles) async {
    if (imagesFiles == null) return;
    final createPostNotifier = ref.read(createPostFormProvider.notifier);

    for (var i in imagesFiles) {
      createPostNotifier.imagesFilesChanged(i);
      final imageBytes = await i.readAsBytes();
      createPostNotifier.imagesBytesChanged(imageBytes);
    }
  }

  Future<List<String>> _uploadPostImages() async {
    final signedInUser = ref.read(signedInUserProvider);
    if (signedInUser == null || signedInUser.isEmpty) return [];
    final formState = ref.read(createPostFormProvider);
    final files = formState.imagesFile ?? [];
    if (files.isEmpty) return [];

    final username = ref.read(signedInUserProvider)?.username ?? 'anonymous';

    // Kick off one upload‐future per file:
    final uploadFutures = files.map((xfile) async {
      final bytes = await xfile.readAsBytes();
      final uniqueName =
          '${xfile.name}_${DateTime.now().millisecondsSinceEpoch}';
      return ref
          .read(loadImagesProvider)
          .uploadImage(
            picBytes: bytes,
            usernamePath: username,
            filename: uniqueName,
            picType: PicType.postPics,
          );
    });

    // await them all at once:
    return await Future.wait(uploadFutures);
  }

  void _onSumbit(WidgetRef ref) {
    final context = ref.context;
    final createPostFormNotifier = ref.read(createPostFormProvider.notifier);
    final formState = ref.read(createPostFormProvider);
    final userRepo = ref.read(usersRepositoryProvider);
    final signedInUserNotifier = ref.read(signedInUserProvider.notifier);
    final laodCommunityNotifier = ref.read(loadCommunitiesProvider.notifier);

    createPostFormNotifier.validateFields(status: FormStatus.posting);

    if (!formState.isValid) {
      mediumVibration();
      showCustomSnackbar(
        context,
        'create_post_screen_check_fields_snackbar_text'.tr(),
        backgroundColor: colorWarning,
      );
      createPostFormNotifier.resetFormStatus();
      return;
    }

    createPostFormNotifier.onSumbit(
      onSubmit: () async {
        final signedInUser = ref.read(signedInUserProvider);
        final imagesUrl = await _uploadPostImages();
        final newPost = Post(
          createdById: signedInUser?.id ?? '',
          createdByUsername: signedInUser?.username ?? '',
          title: formState.title.value,
          content: formState.content.value,
          postedIn: widget.communityId,
          isAnonymous: formState.isAnonymous,
          pictureUrls: imagesUrl,
        );
        final loadPost = ref.read(loadPostsProvider.notifier);
        loadPost.createPost(newPost).then((createdPost) {
          if (createdPost != null) {
            if (signedInUser != null) {
              final signedInUserUpdated = signedInUser.copyWith(
                posted: [createdPost.id, ...signedInUser.posted],
              );
              userRepo.addPost(signedInUserUpdated.id, createdPost.id);
              signedInUserNotifier.update((state) => signedInUserUpdated);
              if (widget.communityId != null) {
                laodCommunityNotifier.addPost(
                  widget.communityId!,
                  createdPost.id,
                );
                ref
                    .read(communityScreenCurrentCommunityProvider.notifier)
                    .update(
                      (state) => state.copyWith(
                        posts: [createdPost, ...state.posts],
                        postsRefs: [createdPost.id, ...state.postsRefs],
                      ),
                    );
              }
            }
            smallVibration();
            showCustomSnackbar(
              context,
              'create_post_screen_post_success_snackbar_text'.tr(),
              backgroundColor: colorSuccess,
            );
            Future.delayed(Duration(milliseconds: 500), () {
              context.pop();
            });
          } else {
            hardVibration();
            showCustomSnackbar(
              context,
              'create_post_screen_post_error_snackbar_text'.tr(),
              backgroundColor: colorNotOkButton,
            );
          }
          createPostFormNotifier.resetFormStatus();
        });
      },
    );
  }
}
