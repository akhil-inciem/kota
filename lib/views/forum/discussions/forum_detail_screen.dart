import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kota/constants/colors.dart';
import 'package:kota/controller/auth_controller.dart';
import 'package:kota/controller/forum_controller.dart';
import 'package:kota/controller/user_controller.dart';
import 'package:kota/views/forum/discussions/widgets/forum_body.dart';
import 'package:kota/views/forum/discussions/widgets/forum_detail_shimmer.dart';
import 'package:kota/views/forum/discussions/widgets/reply_tile.dart';
import 'package:kota/views/widgets/top_bar.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ForumDetailScreen extends StatefulWidget {
  final String threadId;

  ForumDetailScreen({Key? key, required this.threadId}) : super(key: key);

  @override
  State<ForumDetailScreen> createState() => _ForumDetailScreenState();
}

class _ForumDetailScreenState extends State<ForumDetailScreen> {
  final ForumController controller = Get.find<ForumController>();
  final userController = Get.put(UserController());
  final authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    controller.singleThread.value = null;
    userController.loadUserProfile();
    controller.loadSingleThread(widget.threadId);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Obx(() {
          final item = controller.singleThread.value;

          controller.selectedThreadId.value = widget.threadId;

          if (item == null && controller.isThreadLoading.value) {
            return const ForumShimmerLoader();
          }

          final imageUrls = item!.images ?? [];
          final title = item.title;
          final description = item.content;
          final userName = '${item.firstName ?? ''} ${item.lastName ?? ''}';

          return Column(
            children: [
              /// 🔒 Fixed TopBar
              TopBar(title: 'Back', onTap: () => Get.back()),
              SizedBox(height: 2.h),

              /// 🔽 Scrollable content
              Expanded(
                child: SingleChildScrollView(
                  // padding: EdgeInsets.only(bottom: 1.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 7.w),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.grey[300],
                              child: ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl:
                                      item.photo?.isNotEmpty == true
                                          ? item.photo!
                                          : 'https://ui-avatars.com/api/?name=$userName&background=random&color=fff',
                                  fit: BoxFit.cover,
                                  width: 60,
                                  height: 60,
                                  placeholder:
                                      (context, url) => const Center(
                                        child: SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            color: AppColors.primaryColor,
                                            strokeWidth: 2,
                                          ),
                                        ),
                                      ),
                                  errorWidget:
                                      (context, url, error) => const Icon(
                                        Icons.error,
                                        color: Colors.red,
                                      ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userName,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  formatDateTime(item.createdAt),
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                            Spacer(),
                          ],
                        ),
                      ),
                      SizedBox(height: 1.5.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6.w),
                        child: ForumPostBody(
                          title: title ?? '',
                          description: description ?? '',
                          imageUrls: imageUrls,
                          isLiked: controller.isLiked,
                          likes: controller.likeCount,
                          comments: controller.commentCount,
                          id: widget.threadId,
                          onLikeToggle: () => controller.likeThread(),
                        ),
                      ),
                      Obx(() {
                        final comments = controller.comments;
                        return Column(
                          children:
                              comments.map((comment) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CommentTile(comment: comment),
                                    if (comment.replies != null)
                                      ...comment.replies!.map(
                                        (reply) => Padding(
                                          padding: EdgeInsets.only(left: 10.w),
                                          child: ReplyTile(reply: reply),
                                        ),
                                      ),
                                  ],
                                );
                              }).toList(),
                        );
                      }),
                    ],
                  ),
                ),
              ),

              /// 💬 Bottom input
              _buildCommentInput(),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildCommentInput() {
    return Obx(() {
      final user = userController.user.value;
      final isReply = controller.isReplying.value;
      final isSending = controller.isPosting.value;
      final canSend = controller.commentText.isNotEmpty && !isSending;

      final authorFirstName = controller.singleThread.value?.firstName ?? '';
      final authorLastName = controller.singleThread.value?.lastName ?? '';
      final authorName = '$authorFirstName $authorLastName'.trim();

      if (!isReply &&
          controller.commentController.text.isEmpty &&
          authorName.isNotEmpty) {
        controller.commentController.text = '@$authorName ';
        controller.commentController.selection = TextSelection.fromPosition(
          TextPosition(offset: controller.commentController.text.length),
        );
      }

      return Container(
        padding: EdgeInsets.symmetric(horizontal: 1.w),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: const Offset(0, -2),
              blurRadius: 6,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isReply)
                Row(
                  children: [
                    Text(
                      'Replying to ${controller.replyingToName}',
                      style: TextStyle(
                        color: AppColors.primaryText,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.grey),
                      onPressed: () {
                        controller.cancelReply();
                      },
                    ),
                  ],
                ),
              Row(
                children: [
                  // Avatar
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey.shade300,
                    child:
                        user == null
                            ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.grey,
                                ),
                              ),
                            )
                            : user.photo == null
                            ? Icon(Icons.person, color: Colors.grey.shade700)
                            : ClipOval(
                              child: CachedNetworkImage(
                                imageUrl: user.photo!,
                                width: 40, // 2 * radius
                                height: 40,
                                fit: BoxFit.cover,
                                placeholder:
                                    (context, url) => const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ),
                                errorWidget:
                                    (context, url, error) => Icon(
                                      Icons.error,
                                      color: Colors.red.shade400,
                                    ),
                              ),
                            ),
                  ),

                  SizedBox(width: 3.w),
                  // Input Field
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: controller.commentController,
                              focusNode: controller.commentFocusNode,
                              decoration: InputDecoration(
                                hintText:
                                    isReply
                                        ? 'Post your reply here'
                                        : 'Post your comment here',
                                border: InputBorder.none,
                                hintStyle: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed:
                                canSend
                                    ? () async {
                                      controller.isPosting.value = true;
                                      await controller.postCommentOrReply();
                                      controller.isPosting.value = false;
                                    }
                                    : null,
                            icon:
                                isSending
                                    ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                    : Icon(
                                      Icons.send,
                                      color:
                                          canSend
                                              ? AppColors.primaryText
                                              : Colors.grey.shade400,
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
