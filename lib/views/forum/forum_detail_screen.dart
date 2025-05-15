import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:kota/constants/colors.dart';
import 'package:kota/controller/forum_controller.dart';
import 'package:kota/data/dummy.dart';
import 'package:kota/model/forum_model.dart';
import 'package:kota/views/forum/widgets/forum_body.dart';
import 'package:kota/views/forum/widgets/reply_tile.dart';
import 'package:kota/views/home/widgets/top_bar.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ForumDetailScreen extends StatelessWidget {
  final ForumData item;

  ForumDetailScreen({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ForumController controller = Get.find<ForumController>();
    final List<String> comments = DummyData.comments;

    final imageUrl = item.images;
    final title = item.title;
    final description = item.content;
    final userName = '${item.firstName}${item.lastName}';

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TopBar(title: 'Forum',onTap:()=> Get.back(),),
            SizedBox(height: 2.h),
            // Fixed User Profile section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 7.w),
              child: Row(
                children: [
                  CircleAvatar(radius: 30,backgroundImage: NetworkImage('https://ui-avatars.com/api/?name=Joseph+Nicholas&size=300&background=random&color=fff'),),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName ?? '',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        'KOTA Member',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Icon(Icons.more_horiz),
                ],
              ),
            ),
            SizedBox(height: 1.5.h),
            // Scrollable part starts here
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6.w),
                      child: ForumPostBody(
                        title: title ?? '',
                        description: description ?? '',
                        imageUrl:
                            imageUrl.toString() ??
                            'assets/images/nurse-patient-wheelchair.jpg',
                        likes: item.likeCount ?? "0",
                        comments: item.commentCount ?? "0",
                        // isLiked: item['isLiked'] ?? false, // Add this flag in your data
  onLikeToggle: () {
    // controller.toggleLike(item['id']); // Use proper ID or index
  },
                      ),
                    ),

                    // Comments
                    ReplyTile(userName: "Samay Sundaram" ?? '', comment: comments[0]),
                     Padding(
                       padding: EdgeInsets.only(left: 10.w),
                       child: ReplyTile(userName: "Samatha Raj" ?? '', comment: comments[1]),
                     ),
                     ReplyTile(userName: "Guest User 123XYZ" ?? '', comment: comments[2]),
                    // Comment Input Field
                    _buildCommentInput()
                  ],
                ),
              ),
            ),
          ],
        ),

      ),
    );
  }
}
Widget _buildCommentInput() {
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
            backgroundImage: NetworkImage('https://i.pravatar.cc/300'),
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
                      decoration: InputDecoration(
                        hintText: 'Post your comment here',
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
                      // post logic
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
}
