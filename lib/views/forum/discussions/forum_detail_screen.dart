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
import 'package:kota/views/forum/discussions/widgets/userOptions_bottomSheet.dart';
import 'package:kota/views/widgets/custom_snackbar.dart';
import 'package:kota/views/widgets/top_bar.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:safe_text/safe_text.dart';

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
    controller.cancelReply(); // resets isReplying to false
    controller.commentController.clear(); // clear any old comment
    controller.hasInsertedMention.value = false; // allow mention insertion
  }

  Future<bool> checkTextForBadWords(String text) async {
    bool containsBadWord = await SafeText.containsBadWord(
      text: text,
      useDefaultWords: true,
    );
    if (containsBadWord) {
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final userId = authController.userModel.value!.data.id;
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
          final rawName =
              '${item.firstName ?? ''} ${item.lastName ?? ''}'.trim();
          final userName =
              rawName.toLowerCase() == 'guest' ? 'Deleted User' : rawName;

          return Column(
            children: [
              /// 🔒 Fixed TopBar
              TopBar(title: 'Back', onTap: () => Get.back()),
              SizedBox(height: 2.h),

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
                              radius: 3.h,
                              backgroundColor: Colors.grey[300],
                              child:
                                  item.photo?.isNotEmpty == true
                                      ? ClipOval(
                                        child: CachedNetworkImage(
                                          imageUrl: item.photo!,
                                          fit: BoxFit.cover,
                                          width: 6.h,
                                          height: 6.h,
                                          placeholder:
                                              (context, url) => Center(
                                                child: SizedBox(
                                                  width: 3.h,
                                                  height: 3.h,
                                                  child:
                                                      CircularProgressIndicator(
                                                        color:
                                                            AppColors
                                                                .primaryColor,
                                                        strokeWidth: 2,
                                                      ),
                                                ),
                                              ),
                                          errorWidget:
                                              (context, url, error) => Icon(
                                                Icons.person,
                                                size: 22.sp,
                                                color: Colors.grey,
                                              ),
                                        ),
                                      )
                                      : Icon(
                                        Icons.person,
                                        size: 22.sp,
                                        color: Colors.grey,
                                      ),
                            ),
                            SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userName,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF0A2C49),
                                  ),
                                ),
                                Text(
                                  formatDateTime(item.createdAt),
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                            // Spacer(),
                            // (authController.isGuest
                            //           ? item.guestUserId == userId
                            //           : item.createdId == userId) ? SizedBox.shrink() : IconButton(
                            //   icon: Icon(Icons.more_horiz_outlined),
                            //   onPressed: () {
                            //     showModalBottomSheet(
                            //       context: context,
                            //       shape: RoundedRectangleBorder(
                            //         borderRadius: BorderRadius.vertical(
                            //           top: Radius.circular(20),
                            //         ),
                            //       ),
                            //       builder:
                            //           (_) => UserOptionsBottomSheet(
                            //             blockedUserName:
                            //                 "${item.firstName ?? ""} ${item.lastName ?? ""}",
                            //             blockedUserId: item.userType == 'guest'
                            //                           ? item.guestUserId
                            //                           : item.createdId,
                            //             threadId: item.id,
                            //             blockedUserType: "",
                            //           ),
                            //     );
                            //   },
                            // ),
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
                              comments.reversed.map((comment) {
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
    // Add listener once
    controller.commentController.removeListener(_onCommentTextChanged);
    controller.commentController.addListener(_onCommentTextChanged);

    return Obx(() {
      final user = userController.user.value;
      final isReply = controller.isReplying.value;
      final isSending = controller.isPosting.value;
      final canSend = controller.commentText.isNotEmpty && !isSending;

      final authorFirstName = controller.singleThread.value?.firstName ?? '';
      final authorLastName = controller.singleThread.value?.lastName ?? '';
      final authorName = '$authorFirstName $authorLastName'.trim();

      // Mention only once
      if (!isReply &&
          controller.commentController.text.isEmpty &&
          authorName.isNotEmpty &&
          !controller.hasInsertedMention.value) {
        controller.commentController.text = '@$authorName ';
        controller.commentController.selection = TextSelection.fromPosition(
          TextPosition(offset: controller.commentController.text.length),
        );
        controller.hasInsertedMention.value = true;
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
          child: Row(
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
                            width: 40,
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
                                  bool isClean = await checkTextForBadWords(
                                    controller.commentController.text,
                                  );
                                  if (isClean) {
                                    controller.isPosting.value = true;
                                    await controller.postCommentOrReply();
                                    controller.isPosting.value = false;
                                  } else {
                                    CustomSnackbars.failure(
                                      "The text contains inappropriate content.",
                                      "Failed",
                                    );
                                  }
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
        ),
      );
    });
  }

  void _onCommentTextChanged() {
    if (controller.isReplying.value &&
        controller.commentController.text.trim().isEmpty) {
      controller.cancelReply();
    }
  }
}
