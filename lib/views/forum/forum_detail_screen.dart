import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:kota/constants/colors.dart';
import 'package:kota/controller/auth_controller.dart';
import 'package:kota/controller/forum_controller.dart';
import 'package:kota/controller/user_controller.dart';
import 'package:kota/data/dummy.dart';
import 'package:kota/model/forum_model.dart';
import 'package:kota/views/forum/widgets/forum_body.dart';
import 'package:kota/views/forum/widgets/reply_tile.dart';
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

          if (item.id == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final imageUrls = item.images ?? [];
          final title = item.title;
          final description = item.content;
          final userName = '${item.firstName ?? ''} ${item.lastName ?? ''}';

          return Column(
            children: [
              // Scrollable content
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(
                    bottom: 80,
                  ), // Add padding to avoid overlap with input
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TopBar(title: 'Forum', onTap: () => Get.back()),
                      SizedBox(height: 2.h),

                      // Profile section
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 7.w),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundImage: NetworkImage(
                                item.photo?.isNotEmpty == true
                                    ? item.photo!
                                    : 'https://ui-avatars.com/api/?name=$userName&background=random&color=fff',
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
                                Text( "KOTA Member",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            Spacer(),
                          ],
                        ),
                      ),

                      SizedBox(height: 1.5.h),

                      // Post content
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6.w),
                        child: ForumPostBody(
                          title: title ?? '',
                          description: description ?? '',
                          imageUrls: imageUrls,
                          isLiked: controller.isLiked,
                          likes: controller.likeCount,
                          comments: controller.commentCount,
                          onLikeToggle: () => controller.likeThread(),
                        ),
                      ),

                      // Comments and Replies
                      Obx(() {
                        final comments = controller.comments.reversed;
                        return Column(
                          children:
                              comments.map((comment) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CommentTile(comment: comment),
                                    if (comment.replies != null)
                                      ...comment.replies!.reversed.map(
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

              // Fixed comment input bar
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

      return Container(
        padding: EdgeInsets.symmetric(horizontal: 1.w),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: Offset(0, -2),
              blurRadius: 6,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey.shade300,
                backgroundImage:
                    user?.photo != null ? NetworkImage(user!.photo!) : null,
                child:
                    user == null
                        ? SizedBox(
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
                        : null,
              ),

              SizedBox(width: 3.w),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12),
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
                          autofocus: false,
                          decoration: InputDecoration(
                            hintText:
                                isReply
                                    ? 'Post your reply here'
                                    : 'Post your comment here',
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          controller.postCommentOrReply();
                        },
                        icon: Icon(Icons.send, color: AppColors.primaryText),
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
}
