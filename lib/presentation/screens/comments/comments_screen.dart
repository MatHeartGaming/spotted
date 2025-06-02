// ignore_for_file: use_build_context_synchronously

import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotted/config/config.dart';
import 'package:spotted/domain/models/models.dart';
import 'package:spotted/presentation/providers/providers.dart';
import 'package:spotted/presentation/widgets/widgets.dart';

class CommentsScreen extends ConsumerStatefulWidget {
  final Post post;
  final List<Comment> comments;

  /// Called when the user taps “Send.”
  /// Pass in the postId and the new comment text.
  /// You should wire this up to your repository or StateNotifier.
  final Future<void> Function(String postId, String commentText) onPostComment;

  const CommentsScreen({
    super.key,
    required this.post,
    required this.comments,
    required this.onPostComment,
  });

  @override
  ConsumerState<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends ConsumerState<CommentsScreen> {
  @override
  void initState() {
    super.initState();
    _initComments();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _initComments() {
    Future(() {
      ref.read(loadCommentsProvider.notifier).loadComments(widget.post.id);
    });
  }

  Future<void> _handleSend() async {
    final commentsFormNotifier = ref.read(commentsFormProvider.notifier);
    final commentsFormState = ref.read(commentsFormProvider);
    final signedInUser = ref.read(signedInUserProvider);
    final loadComments = ref.read(loadCommentsProvider.notifier);
    if (signedInUser == null || signedInUser.isEmpty) return;
    commentsFormNotifier.onSumbit(
      onSubmit: () {
        final newComment = Comment(
          text: commentsFormState.comment.value,
          createdById:
              commentsFormState.isAnonymous ? anonymousText : signedInUser.id,
          createdByUsername:
              commentsFormState.isAnonymous
                  ? anonymousText
                  : signedInUser.username,
          postId: widget.post.id,
        );

        loadComments
            .createComment(newComment)
            .then((updatedComments) {
              final loadPostsNotifier = ref.read(loadPostsProvider.notifier);
              final loadUsersNotifier = ref.read(loadUserProvider.notifier);
              final updatedUser = signedInUser.copyWith(
                comments: [...signedInUser.comments, newComment.id],
              );
              final updatedPost = widget.post.copyWith(
                commentRefs: [...widget.post.commentRefs, newComment.id],
              );
              loadPostsNotifier.updatePost(updatedPost);

              // Only update user with new comment if it is not an anonymous Comment
              if (!commentsFormState.isAnonymous) {
                loadUsersNotifier.updateUser(updatedUser);
              }
              commentsFormNotifier.clearComment();
              smallVibration();
            })
            .catchError((error) {
              hardVibration();
              showCustomSnackbar(
                context,
                'comments_screen_error_posting_text'.tr(),
                backgroundColor: colorNotOkButton,
              );
            })
            .whenComplete(() {
              commentsFormNotifier.resetFormStatus();
              FocusScope.of(context).unfocus();
            });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.paddingOf(context).bottom;

    final commentsState = ref.watch(loadCommentsProvider);
    final commentsFormState = ref.watch(commentsFormProvider);

    final sortedComments = List<Comment>.from(commentsState.comments);

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'comments_screen_app_bar_title',
          ).tr(args: [widget.post.title]),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child:
                    commentsState.isLoadingComments
                        ? LoadingDefaultWidget()
                        : sortedComments.isEmpty
                        ? Center(
                          child:
                              Text(
                                'comments_screen_no_comments_yet_text',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ).tr(),
                        )
                        : ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          itemCount: sortedComments.length,
                          itemBuilder: (context, index) {
                            final comment = sortedComments[index];

                            // Function to render Comment Row
                            fadeInComment(Comment comm, {String? profileUrl}) =>
                                FadeIn(
                                  duration: Duration(milliseconds: 300),
                                  child: CommentTile(
                                    comment: comm,
                                    userProfilePicUrl: profileUrl,
                                  ),
                                );
                            if (comment.createdById == anonymousText) {
                              return fadeInComment(comment);
                            }
                            return ref
                                .watch(
                                  userFutureByIdProvider(comment.createdById),
                                )
                                .when(
                                  data:
                                      (user) => fadeInComment(
                                        comment,
                                        profileUrl: user?.profileImageUrl,
                                      ),
                                  error:
                                      (error, stackTrace) =>
                                          Text('Error loading comment...'),
                                  loading: () => LoadingDefaultWidget(),
                                );
                          },
                        ),
              ),

              const Divider(height: 1),

              // ──────── New Comment Input ───────────────────────────────
              SlideInUp(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 4,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        tooltip:
                            (commentsFormState.isAnonymous
                                    ? 'comments_screen_anonymous_posting_tooltip'
                                    : 'comments_screen_not_anonymous_posting_tooltip')
                                .tr(),
                        onPressed: () => _anonymousToggleAction(),
                        icon: Icon(
                          commentsFormState.isAnonymous
                              ? anonymousIcon
                              : nonAnonymousIcon,
                        ),
                      ),

                      Expanded(
                        child: CommentTextField(
                          textController: commentsFormState.commentController,
                          textInputAction: TextInputAction.send,
                          placeholderText:
                              'comments_screen_write_comment_placeholder_text'
                                  .tr(),
                          onSubmit: (value) => _handleSend(),
                          onChannge: (newValue) {
                            ref
                                .read(commentsFormProvider.notifier)
                                .onCommentChange(newValue);
                          },
                        ),
                      ),

                      const SizedBox(width: 8),

                      // 2) Send button
                      commentsFormState.isPosting
                          ? const SizedBox(
                            width: 32,
                            height: 32,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                          : IconButton(
                            icon: const Icon(Icons.send, color: Colors.blue),
                            onPressed: _handleSend,
                          ),
                    ],
                  ),
                ),
              ),

              // Add a small safe‐area padding on iOS so nothing is hidden behind the keyboard notch.
              SizedBox(height: bottomPadding + 20),
            ],
          ),
        ),
      ),
    );
  }

  void _anonymousToggleAction() {
    final commentsFormState = ref.read(commentsFormProvider);
    final signedInUser = ref.read(signedInUserProvider);
    if (signedInUser == null || signedInUser.isEmpty) return;
    mediumVibration();
    ref
        .read(commentsFormProvider.notifier)
        .onAnonymousChange(!commentsFormState.isAnonymous);
    if (!commentsFormState.isAnonymous) {
      showCustomSnackbar(
        context,
        'comments_screen_anonymous_posting_snackbar'.tr(),
      );
    } else {
      showCustomSnackbar(
        context,
        'comments_screen_not_anonymous_posting_snackbar'.tr(
          args: [signedInUser.username],
        ),
      );
    }
  }
}
