// ignore_for_file: use_build_context_synchronously

import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotted/config/config.dart';
import 'package:spotted/domain/models/models.dart';
import 'package:spotted/presentation/navigation/navigation.dart';
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
              final newCommentId = updatedComments.$2.id;
              final updatedUser = signedInUser.copyWith(
                comments: [...signedInUser.comments, newCommentId],
              );

              final updatedPost = widget.post.copyWith(
                commentRefs: [...widget.post.commentRefs, newCommentId],
              );
              loadPostsNotifier.addComment(updatedPost.id, newCommentId);
              loadPostsNotifier.updatePostLocally(updatedPost);

              // Only update user with new comment if it is not an anonymous Comment
              if (!commentsFormState.isAnonymous) {
                loadUsersNotifier.updateUser(updatedUser);
                ref
                    .read(signedInUserProvider.notifier)
                    .update((state) => updatedUser);
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
                            return _CommentItem(
                              comment: comment,
                              onEditPressed: () => _showEditDialog(comment),
                              onDeletePressed:
                                  () => _deleteCommentAction(comment),
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
                            icon: Icon(
                              Icons.send,
                              color:
                                  commentsFormState.comment.isValid
                                      ? Colors.blue
                                      : Colors.grey,
                            ),
                            onPressed:
                                commentsFormState.isValid ? _handleSend : null,
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

  Future<void> _deleteCommentAction(Comment comment) async {
    final commentsFormNotifier = ref.read(commentsFormProvider.notifier);
    final signedInUser = ref.read(signedInUserProvider);
    if (signedInUser == null || signedInUser.isEmpty) return;

    await ref
        .read(loadCommentsProvider.notifier)
        .deleteComment(comment.id)
        .then((_) {
          final loadPostsNotifier = ref.read(loadPostsProvider.notifier);
          final loadUsersNotifier = ref.read(loadUserProvider.notifier);

          // 2) Remove the comment ID from the post’s commentRefs list:
          final updatedPost = widget.post.copyWith(
            commentRefs:
                widget.post.commentRefs
                    .where((cId) => cId != comment.id)
                    .toList(),
          );

          // 3) Push the updated post into your posts‐notifier:
          loadPostsNotifier.removeComment(updatedPost.id, comment.id);
          loadPostsNotifier.updatePostLocally(updatedPost);

          // 4) Only update the user if this wasn’t an anonymous comment:
          if (comment.createdById != anonymousText) {
            final updatedUser = signedInUser.copyWith(
              comments:
                  signedInUser.comments
                      .where((cId) => cId != comment.id)
                      .toList(),
            );
            loadUsersNotifier.updateUser(updatedUser);
            ref
                .read(signedInUserProvider.notifier)
                .update((state) => updatedUser);
          }
          mediumVibration();
          showCustomSnackbar(
            context,
            'comments_screen_delete_comment_success_snackbar'.tr(),
            backgroundColor: colorSuccess,
          );
        })
        .catchError((error) {
          hardVibration();
          showCustomSnackbar(
            context,
            'comments_screen_error_deleting_text'.tr(),
            backgroundColor: colorNotOkButton,
          );
        })
        .whenComplete(() {
          commentsFormNotifier.resetFormStatus();
          FocusScope.of(context).unfocus();
        });
  }

  void _showEditDialog(Comment comment) {
    showAdaptiveTextInputDialog(
      context,
      titleKey: 'comments_screen_edit_comment_alert_title',
      initialText: comment.text,
      hintTextKey: 'comments_screen_write_new_comment_hint_text',
      okTextKey: 'save_text', // "Save" button
      cancelTextKey: 'cancel_text', // "Cancel" button
      isDestructive: false,
      onConfirm: (newText) async {
        // Only call update if text actually changed and is non-empty:
        if (newText.isNotEmpty && newText != comment.text) {
          final updated = comment.copyWith(text: newText);
          await ref.read(loadCommentsProvider.notifier).updateComment(updated);
        }
      },
    );
  }
}

class _CommentItem extends ConsumerWidget {
  final Comment comment;
  final VoidCallback? onEditPressed;
  final VoidCallback? onDeletePressed;
  const _CommentItem({
    required this.comment,
    required this.onEditPressed,
    required this.onDeletePressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1) Access the signed‐in user
    final signedIn = ref.watch(signedInUserProvider);
    final isOwnComment = signedIn?.id == comment.createdById;

    // 2) Anonymous‐vs‐“load user profile” logic (unchanged):
    if (comment.createdById == anonymousText) {
      return _fadeInComment(
        context: context,
        comment: comment,
        isOwnComment: false, // you can’t edit an anonymous comment
      );
    }

    final userAsync = ref.watch(userFutureByIdProvider(comment.createdById));
    return userAsync.when(
      data: (user) {
        // 3) Build the FadeIn with correct flags & callbacks:
        return _fadeInComment(
          context: context,
          comment: comment,
          profileUrl: user?.profileImageUrl,
          isOwnComment: isOwnComment,
          onUserInfoTapped: () {
            pushToProfileScreen(context, user: user!);
          },
          onEditPressed:
              isOwnComment
                  ? () {
                    if (onEditPressed == null) return;
                    onEditPressed!();
                  }
                  : null,
          onDeletePressed:
              isOwnComment
                  ? () async {
                    if (onDeletePressed == null) return;
                    onDeletePressed!();
                  }
                  : null,
        );
      },
      loading: () => const LoadingDefaultWidget(),
      error: (err, stack) => const Text('Error loading comment…'),
    );
  }

  // Helper to wrap CommentTile in FadeIn (same as before), but now with new params:
  Widget _fadeInComment({
    required BuildContext context,
    required Comment comment,
    String? profileUrl,
    VoidCallback? onUserInfoTapped,
    bool isOwnComment = false,
    VoidCallback? onEditPressed,
    VoidCallback? onDeletePressed,
  }) {
    return FadeIn(
      duration: const Duration(milliseconds: 300),
      child: CommentTile(
        comment: comment,
        userProfilePicUrl: profileUrl,
        onUserInfoTapped: onUserInfoTapped,
        isOwnComment: isOwnComment,
        onEditPressed: onEditPressed,
        onDeletePressed: onDeletePressed,
      ),
    );
  }
}
