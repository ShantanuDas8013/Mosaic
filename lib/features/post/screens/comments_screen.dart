import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mosaic/core/common/error_text.dart';
import 'package:mosaic/core/common/loader.dart';
import 'package:mosaic/core/common/post_card.dart';
import 'package:mosaic/features/auth/controller/auth_controller.dart';
import 'package:mosaic/features/post/controller/post_controller.dart';
import 'package:mosaic/features/post/widgets/comment_card.dart';
import 'package:mosaic/models/post_model.dart';

class CommentsScreen extends ConsumerStatefulWidget {
  final String postId;
  const CommentsScreen({required this.postId, super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends ConsumerState<CommentsScreen> {
  final commentController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    commentController.dispose();
  }

  void addComment(Post post) {
    ref
        .read(postControllerProvider.notifier)
        .addComment(
          context: context,
          text: commentController.text.trim(),
          post: post,
        );
    setState(() {
      commentController.text = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
        centerTitle: false,
        elevation: 0,
      ),
      resizeToAvoidBottomInset: true,
      body: ref
          .watch(getPostByIdProvider(widget.postId))
          .when(
            data: (data) {
              return Column(
                children: [
                  Expanded(
                    flex: 2,
                    child: SingleChildScrollView(child: PostCard(post: data)),
                  ),
                  Expanded(
                    flex: 3,
                    child: Stack(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 60),
                          child: ref
                              .watch(getPostCommentsProvider(widget.postId))
                              .when(
                                data: (comments) {
                                  if (comments.isEmpty) {
                                    return Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.chat_bubble_outline,
                                            size: 50,
                                            color:
                                                isDarkMode
                                                    ? Colors.grey.shade600
                                                    : Colors.grey.shade400,
                                          ),
                                          const SizedBox(height: 16),
                                          Text(
                                            'No comments yet',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color:
                                                  isDarkMode
                                                      ? Colors.grey.shade400
                                                      : Colors.grey.shade700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }

                                  return ListView.builder(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                    ),
                                    itemCount: comments.length,
                                    itemBuilder: (
                                      BuildContext context,
                                      int index,
                                    ) {
                                      final comment = comments[index];
                                      return CommentCard(comment: comment);
                                    },
                                  );
                                },
                                error:
                                    (error, stackTrace) =>
                                        ErrorText(error: error.toString()),
                                loading: () => const Loader(),
                              ),
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child:
                              isGuest
                                  ? Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          isDarkMode
                                              ? const Color(0xFF1E1E1E)
                                              : Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withAlpha(25),
                                          blurRadius: 4,
                                          offset: const Offset(0, -1),
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Sign in to add a comment',
                                        style: TextStyle(
                                          color:
                                              isDarkMode
                                                  ? Colors.grey.shade400
                                                  : Colors.grey.shade600,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  )
                                  : Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          isDarkMode
                                              ? const Color(0xFF1E1E1E)
                                              : Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withAlpha(25),
                                          blurRadius: 4,
                                          offset: const Offset(0, -1),
                                        ),
                                      ],
                                    ),
                                    child: TextField(
                                      onSubmitted: (val) => addComment(data),
                                      controller: commentController,
                                      decoration: InputDecoration(
                                        hintText: 'Write a comment...',
                                        hintStyle: TextStyle(
                                          color:
                                              isDarkMode
                                                  ? Colors.grey.shade400
                                                  : Colors.grey.shade600,
                                        ),
                                        filled: true,
                                        fillColor:
                                            isDarkMode
                                                ? Colors.grey.shade800
                                                : Colors.grey.shade100,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            24,
                                          ),
                                          borderSide: BorderSide.none,
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 10,
                                            ),
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            Icons.send,
                                            color: primaryColor,
                                          ),
                                          onPressed: () => addComment(data),
                                        ),
                                      ),
                                      minLines: 1,
                                      maxLines: 3,
                                    ),
                                  ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
            error: (error, stackTrace) => ErrorText(error: error.toString()),
            loading: () => const Loader(),
          ),
    );
  }
}
