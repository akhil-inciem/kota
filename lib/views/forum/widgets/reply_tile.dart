import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kota/controller/auth_controller.dart';
import 'package:kota/model/forum_model.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../controller/forum_controller.dart';

class ReplyTile extends StatelessWidget {
  final Replies reply;

  ReplyTile({Key? key, required this.reply}) : super(key: key);
  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
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
                    radius: 20,
                    backgroundColor: Colors.grey.shade300,
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: reply.photo!,
                        width: 40, // 2 * radius
                        height: 40,
                        fit: BoxFit.cover,
                        placeholder:
                            (context, url) => const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                        errorWidget:
                            (context, url, error) =>
                                const Icon(Icons.error, color: Colors.red),
                      ),
                    ),
                  )
                  : const CircleAvatar(
                    radius: 20,
                    child: Icon(Icons.person, color: Colors.white),
                    backgroundColor: Colors.grey,
                  ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${reply.firstName} ${reply.lastName ?? ''}',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    authController.isGuest ? "KOTA Guest" : "KOTA Member",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Comment text
          Text(
            reply.content ?? "",
            style: const TextStyle(fontSize: 13, color: Colors.black54),
          ),
          const SizedBox(height: 8),
          // Actions Row
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  _forumController.likeReply(reply.id ?? '');
                },
                child: Icon(
                  reply.isLiked! ? Icons.favorite : Icons.favorite_border,
                  size: 20,
                  color: reply.isLiked! ? Colors.red : Colors.black,
                ),
              ),
              SizedBox(width: 1.w),
              Text(reply.likeCount ?? ''),
              SizedBox(width: 20),
              GestureDetector(
                onTap: () {
                  _forumController.startReply(
                    id: reply.commentId ?? '',
                    name: '${reply.firstName} ${reply.lastName ?? ''}',
                  );
                },
                child: Row(
                  children: [
                    Icon(Icons.reply_sharp, size: 20, color: Colors.grey),
                    SizedBox(width: 4),
                    Text('Reply', style: TextStyle(fontSize: 14)),
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

  CommentTile({Key? key, required this.comment}) : super(key: key);
  final authController = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    final ForumController _forumController = Get.find<ForumController>();
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
                    radius: 20,
                    backgroundColor: Colors.grey.shade300,
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: comment.photo!,
                        width: 40, // 2 * radius
                        height: 40,
                        fit: BoxFit.cover,
                        placeholder:
                            (context, url) => const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                        errorWidget:
                            (context, url, error) =>
                                const Icon(Icons.error, color: Colors.red),
                      ),
                    ),
                  )
                  : const CircleAvatar(
                    radius: 20,
                    child: Icon(Icons.person, color: Colors.white),
                    backgroundColor: Colors.grey,
                  ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${comment.firstName} ${comment.lastName ?? ''}',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    authController.isGuest ? "KOTA Guest" : "KOTA Member",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Comment text
          Text(
            comment.content ?? '',
            style: const TextStyle(fontSize: 13, color: Colors.black54),
          ),
          const SizedBox(height: 8),
          // Actions Row
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  _forumController.likeComment(comment.id ?? '');
                },
                child: Icon(
                  comment.isLiked! ? Icons.favorite : Icons.favorite_border,
                  size: 20,
                  color: comment.isLiked! ? Colors.red : Colors.black,
                ),
              ),
              SizedBox(width: 1.w),
              Text(comment.likeCount ?? ''),
              SizedBox(width: 20),

              GestureDetector(
                onTap: () {
                  _forumController.startReply(
                    id: comment.id ?? '',
                    name: '${comment.firstName} ${comment.lastName ?? ''}',
                  );
                },
                child: Row(
                  children: [
                    Icon(Icons.reply_sharp, size: 20, color: Colors.grey),
                    SizedBox(width: 4),
                    Text('Reply', style: TextStyle(fontSize: 14)),
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
