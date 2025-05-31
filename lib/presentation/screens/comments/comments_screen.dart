// ignore_for_file: use_build_context_synchronously

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
  final TextEditingController _textController = TextEditingController();
  bool _isPosting = false;

  @override
  void initState() {
    super.initState();
    _initComments();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _initComments() {
    Future(() {
      ref.read(loadCommentsProvider.notifier).loadComments(widget.post.id);
    });
  }

  Future<void> _handleSend() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    // Prevent double-tap:
    setState(() {
      _isPosting = true;
    });

    try {
      await widget.onPostComment(widget.post.id, text);
      _textController.clear();
      // Optionally: close the keyboard
      FocusScope.of(context).unfocus();
    } catch (e) {
      // Handle error (show a SnackBar, etc.)
      showCustomSnackbar(context, 'comments_screen_error_posting_text'.tr());
      logger.e('Error posting comment: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isPosting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.paddingOf(context).bottom;

    final commentsState = ref.watch(loadCommentsProvider);

    // Sort comments by dateCreated ascending (oldest first) so newer ones appear at bottom:
    final sortedComments = List<Comment>.from(commentsState.comments)
      ..sort((a, b) => a.dateCreated.compareTo(b.dateCreated));

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
                            return _CommentTile(comment: comment);
                          },
                        ),
              ),

              const Divider(height: 1),

              // ──────── New Comment Input ───────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 4,
                ),
                child: Row(
                  children: [
                    // 1) Text field
                    Expanded(
                      child: CommentTextField(
                        textController: _textController,
                        textInputAction: TextInputAction.send,
                        placeholderText:
                            'comments_screen_write_comment_placeholder_text'
                                .tr(),
                        onSubmit: (value) {},
                        onChannge: (newValue) {},
                      ),
                    ),

                    const SizedBox(width: 8),

                    // 2) Send button
                    _isPosting
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

              // Add a small safe‐area padding on iOS so nothing is hidden behind the keyboard notch.
              SizedBox(height: bottomPadding + 20),
            ],
          ),
        ),
      ),
    );
  }
}

/// --------------------------------------------------------------------------------
/// A single tile showing one comment.
/// Displays author name, date, and comment body.
///
/// If you want to show reactions or “reply” buttons, you can expand this widget.
class _CommentTile extends StatelessWidget {
  final Comment comment;
  final String? userProfilePicUrl;
  const _CommentTile({required this.comment, this.userProfilePicUrl});

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat.yMMMd().add_jm().format(
      comment.dateCreated,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1) (Optional) You might put a user avatar or placeholder circle here.
          //const CircleAvatar(radius: 16, child: Icon(Icons.person, size: 16)),
          CirclePicture(
            minRadius: 18,
            maxRadius: 18,
            urlPicture: userProfilePicUrl?? ''
          ),
          const SizedBox(width: 8),

          // 2) Author name + timestamp + comment body
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Author + date
                Row(
                  children: [
                    Text(
                      comment.createdByUsername,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      formattedDate,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                // Comment body (text)
                Text(comment.text, style: const TextStyle(fontSize: 14)),

                // ─ You could add “Reply” or reaction icons here if desired ─
                // For now, we leave it simple.
              ],
            ),
          ),
        ],
      ),
    );
  }
}
