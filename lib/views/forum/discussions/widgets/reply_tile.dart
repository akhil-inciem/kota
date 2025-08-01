import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kota/controller/auth_controller.dart';
import 'package:kota/model/forum_model.dart';
import 'package:kota/views/forum/discussions/widgets/userOptions_bottomSheet.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../controller/forum_controller.dart';

class ReplyTile extends StatelessWidget {
  final Replies reply;
  // final String threadId;
  // final String commentId;

  ReplyTile({
    Key? key,
    required this.reply,
    // required this.threadId,
    // required this.commentId,
  }) : super(key: key);
  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    final userId = authController.userModel.value!.data.id;
    final ForumController _forumController = Get.find<ForumController>();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile & Name
          Row(
            children: [
              reply.photo != null
                  ? CircleAvatar(
                    radius: 2.h,
                    backgroundColor: Colors.grey.shade300,
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: reply.photo!,
                        width: 4.h, // 2 * radius
                        height: 4.h,
                        fit: BoxFit.cover,
                        placeholder:
                            (context, url) => SizedBox(
                              width: 2.h,
                              height: 2.h,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                        errorWidget:
                            (context, url, error) =>
                                Icon(Icons.person, color: Colors.grey),
                      ),
                    ),
                  )
                  : CircleAvatar(
                    radius: 2.h,
                    child: Icon(Icons.person, color: Colors.white),
                    backgroundColor: Colors.grey,
                  ),
              SizedBox(width: 1.h),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ('${reply.firstName ?? ''} ${reply.lastName ?? ''}')
                                .trim()
                                .toLowerCase() ==
                            'guest'
                        ? 'Deleted User'
                        : '${reply.firstName ?? ''} ${reply.lastName ?? ''}'
                            .trim(),
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),

                  Text(
                    formatDateTime(reply.createdAt),
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              Spacer(),
              (authController.isGuest
                      ? reply.guestUserId == userId
                      : reply.createdId == userId)
                  ? SizedBox.shrink()
                  : IconButton(
                    icon: Icon(Icons.more_horiz_outlined,size: 20.sp,),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        builder:
                            (_) => UserOptionsBottomSheet(
                              blockedUserName:
                                  "${reply.firstName ?? ""} ${reply.lastName ?? ""}",
                              blockedUserId:
                                  reply.userType == 'guest'
                                      ? reply.guestUserId
                                      : reply.createdId,
                              replyId: reply.id,
                              blockedUserType: reply.userType,
                            ),
                      );
                    },
                  ),
            ],
          ),
          SizedBox(height: 1.h),
          // Comment text
          buildRichTextWithMentions(reply.content),

          SizedBox(height: 1.h),
          // Actions Row
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  _forumController.likeReply(reply.id ?? '');
                },
                child: Icon(
                  reply.isLiked! ? Icons.favorite : Icons.favorite_border,
                  size: 17.sp,
                  color: reply.isLiked! ? Colors.red : Colors.black,
                ),
              ),
              SizedBox(width: 1.w),
              if ((int.tryParse(reply.likeCount ?? '0') ?? 0) > 0)
                Text(reply.likeCount!),

              SizedBox(width: 2.h),
              GestureDetector(
                onTap: () {
                  _forumController.startReply(
                    id: reply.commentId ?? '',
                    name: '${reply.firstName} ${reply.lastName ?? ''}',
                  );
                },
                child: Row(
                  children: [
                    Image.asset(
                      'assets/icons/reply.png',
                      height: 1.5.h,
                      width: 1.5.h,
                    ),
                    SizedBox(width: 1.5.w),
                    Text('Reply', style: TextStyle(fontSize: 14.sp)),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Divider(),
        ],
      ),
    );
  }
}

class CommentTile extends StatelessWidget {
  final Comments comment;
  // final String threadId;

  CommentTile({
    Key? key,
    required this.comment,
    // required this.threadId
  }) : super(key: key);
  final authController = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    final ForumController _forumController = Get.find<ForumController>();
    final userId = authController.userModel.value!.data.id;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile & Name
          Row(
            children: [
              comment.photo != null
                  ? CircleAvatar(
                    radius: 2.h,
                    backgroundColor: Colors.grey.shade300,
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: comment.photo!,
                        width: 4.h, // 2 * radius
                        height: 4.h,
                        fit: BoxFit.cover,
                        placeholder:
                            (context, url) => SizedBox(
                              width: 2.h,
                              height: 2.h,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                        errorWidget:
                            (context, url, error) =>
                                const Icon(Icons.error, color: Colors.red),
                      ),
                    ),
                  )
                  : CircleAvatar(
                    radius: 2.h,
                    child: Icon(Icons.person, color: Colors.white),
                    backgroundColor: Colors.grey,
                ),
              SizedBox(width: 1.h),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ('${comment.firstName ?? ''} ${comment.lastName ?? ''}')
                                .trim()
                                .toLowerCase
                                () ==
                            'guest'
                        ? 'Deleted User'
                        : '${comment.firstName ?? ''} ${comment.lastName ?? ''}'
                            .trim(),
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),

                  Text(
                    formatDateTime(comment.createdAt),
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              Spacer(),
              (authController.isGuest
                      ? comment.guestUserId == userId
                      : comment.createdId == userId)
                  ? SizedBox.shrink()
                  : IconButton(
                    icon: Icon(Icons.more_horiz_outlined,size: 20.sp,),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        builder:
                            (_) => UserOptionsBottomSheet(
                              blockedUserName:
                                  "${comment.firstName ?? ""} ${comment.lastName ?? ""}",
                              blockedUserId:
                                  comment.userType == 'guest'
                                      ? comment.guestUserId
                                      : comment.createdId,
                              commentId: comment.id,
                              blockedUserType: comment.userType,
                            ),
                      );
                    },
                  ),
            ],
          ),
          SizedBox(height: 1.h),
          // Comment text
          buildRichTextWithMentions(comment.content),
          SizedBox(height: 1.h),
          // Actions Row
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  _forumController.likeComment(comment.id ?? '');
                },
                child: Icon(
                  comment.isLiked! ? Icons.favorite : Icons.favorite_border,
                  size: 17.sp,
                  color: comment.isLiked! ? Colors.red : Colors.black,
                ),
              ),
              SizedBox(width: 1.w),
              if ((int.tryParse(comment.likeCount ?? '0') ?? 0) > 0)
                Text(comment.likeCount!, style: TextStyle(fontSize: 15.sp)),
              SizedBox(width: 2.h),

              GestureDetector(
                onTap: () {
                  _forumController.startReply(
                    id: comment.id ?? '',
                    name: '${comment.firstName} ${comment.lastName ?? ''}',
                  );
                },
                child: Row(
                  children: [
                    Image.asset(
                      'assets/icons/reply.png',
                      height: 1.5.h,
                      width: 1.5.h,
                    ),
                    SizedBox(width: 1.5.w),
                    Text('Reply', style: TextStyle(fontSize: 14.sp)),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Divider(),
        ],
      ),
    );
  }
}

RichText buildRichTextWithMentions(String? content) {
  if (content == null || content.isEmpty) {
    return RichText(
      text: TextSpan(
        text: '',
        style: TextStyle(fontSize: 16.sp, color: Colors.black54),
      ),
    );
  }

  final marker = '^';
  final spans = <TextSpan>[];

  int markerIndex = content.indexOf(marker);
  if (markerIndex != -1) {
    // Mention exists with marker
    final mentionText = content.substring(0, markerIndex).trim();
    spans.add(
      TextSpan(
        text: '$mentionText ',
        style: TextStyle(
          fontSize: 15.sp,
          color: Color(0xFF0A58C9),
          fontWeight: FontWeight.w600,
        ),
      ),
    );

    final remaining = content.substring(markerIndex + 1).trimLeft();
    if (remaining.isNotEmpty) {
      spans.add(
        TextSpan(
          text: remaining,
          style: TextStyle(fontSize: 15.sp, color: Colors.grey.shade800),
        ),
      );
    }
  } else {
    // No marker found, treat whole text as normal
    spans.add(
      TextSpan(
        text: content,
        style: TextStyle(fontSize: 16.sp, color: Colors.grey.shade800),
      ),
    );
  }

  return RichText(text: TextSpan(children: spans));
}

String formatDateTime(String? dateTimeStr) {
  if (dateTimeStr == null) return '';
  final dateTime = DateTime.tryParse(dateTimeStr);
  if (dateTime == null) return '';
  final date = DateFormat("d MMM yyyy").format(dateTime); // e.g., 27 Apr 2.h25
  final time = DateFormat("hh:mm a").format(dateTime); // e.g., 04:09 PM
  return '$date  |  $time';
}
