import 'dart:math';

import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spotted/config/config.dart';
import 'package:spotted/presentation/providers/providers.dart';
import 'package:spotted/presentation/widgets/widgets.dart';

class CreatePostsScreen extends ConsumerWidget {
  static const name = 'CreatePostsScreen';

  const CreatePostsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(createPostProvider);
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
                  label: 'create_post_screen_title_textfield_placeholder'.tr(),
                  controller: formState.titleController,
                  icon: Icons.title_outlined,
                  errorMessage: formState.title.errorMessage,
                  onChanged: (newValue) {
                    ref
                        .read(createPostProvider.notifier)
                        .onTitleChanged(newValue);
                  },
                ),
                CustomTextFormField(
                  label:
                      'create_post_screen_content_textfield_placeholder'.tr(),
                  controller: formState.contentController,
                  icon: Icons.title_outlined,
                  errorMessage: formState.content.errorMessage,
                  onChanged: (newValue) {
                    ref
                        .read(createPostProvider.notifier)
                        .onContentChanged(newValue);
                  },
                ),
                SizedBox(height: 20),
                GridImagesWidget(
                  images: formState.imagesBytes ?? [],
                  onImageDelete: (deleteIndex) {
                    ref
                        .read(createPostProvider.notifier)
                        .removeImageAt(deleteIndex);
                  },
                  onImageTap:
                      (index) => showImagesGalleryBytes(
                        context,
                        formState.imagesBytes ?? [],
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
                        _displayPickImageDialog(ref, (picList) {
                          _imagesChosenAction(ref, 0, picList);
                        });
                      },
                      icon: SizedBox.square(
                        dimension: 50,
                        child: Icon(FontAwesomeIcons.photoFilm, size: 20),
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _onSumbit(ref),
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

  void _displayPickImageDialog(
    WidgetRef ref,
    Function(List<XFile>?) onImagesChosen,
  ) {
    final context = ref.context;
    final picker = ref.read(imagePickerProvider);
    final formState = ref.read(createPostProvider);
    final currentCount =
        (formState.imagesUrl?.length ?? 0) +
        (formState.imagesBytes?.length ?? 0);
    // how many more the user can pick:
    final remaining = max(5 - currentCount, 0);

    logger.i('Remain: $remaining');
    logger.i('Images: ${formState.imagesUrl?.length}');
    logger.i('Bytes: ${formState.imagesBytes?.length}');

    if (!context.mounted) return;
    displayPickImageDialog(
      context,
      onGalleryChosen: () async {
        if (remaining < 2) {
          await picker.selectPhoto().then((files) {
            onImagesChosen([files].cast<XFile>());
            //popContext(context);
          });
        }
        await picker.selectPhotos(limit: remaining).then((files) {
          onImagesChosen(files.cast<XFile>());
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

  Future<void> _imagesChosenAction(
    WidgetRef ref,
    int index,
    List<XFile>? imagesFiles,
  ) async {
    if (imagesFiles == null) return;
    final createPostNotifier = ref.read(createPostProvider.notifier);

    for (var i in imagesFiles) {
      createPostNotifier.imagesFilesChanged(i);
      final imageBytes = await i.readAsBytes();
      createPostNotifier.imagesBytesChanged(imageBytes);
    }
  }

  void _onSumbit(WidgetRef ref) {
    logger.i('Sumbit!');
  }
}
