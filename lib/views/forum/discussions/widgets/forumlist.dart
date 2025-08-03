import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kota/constants/colors.dart';
import 'package:kota/controller/auth_controller.dart';
import 'package:kota/controller/forum_controller.dart';
import 'package:kota/views/forum/discussions/forum_detail_screen.dart';
import 'package:kota/views/forum/discussions/widgets/forum_shimmer.dart';
import 'package:kota/views/forum/discussions/widgets/userOptions_bottomSheet.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ForumList extends StatefulWidget {
  ForumList({Key? key}) : super(key: key);

  @override
  State<ForumList> createState() => _ForumListState();
}

class _ForumListState extends State<ForumList> {
  final ForumController forumController = Get.find<ForumController>();
  final authController = Get.find<AuthController>();

  String timeAgo(String createdAt) {
    final createdTime = DateTime.parse(createdAt);
    final now = DateTime.now();
    final difference = now.difference(createdTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks week${weeks == 1 ? '' : 's'} ago';
    } else {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    }
  }

  @override
  Widget build(BuildContext context) {
    final userId = authController.userModel.value!.data.id;
    return Obx(() {
      if (forumController.isLoading.value) {
        return const ForumShimmer(); // Show shimmer while loading
      }

      final items = forumController.threadsList;
      if (items.isEmpty) {
        return RefreshIndicator(
          onRefresh: () async {
            await forumController
                .loadThreads(); // Replace with your actual method
          },
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              SizedBox(height: 24.h), // add space to allow pull
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/icons/forum_unselected.png',
                      height: 8.h,
                      width: 8.h,
                    ),
                     SizedBox(height: 1.h),
                    Text(
                      "No Discussions Available",
                      style: TextStyle(fontSize: 18.sp, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }
      return RefreshIndicator(
        onRefresh: () async {
          await forumController
              .loadThreads(); // Replace with your actual method
        },
        child: ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: items.length,
          physics: const AlwaysScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final item = items[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ForumDetailScreen(threadId: item.id!),
                  ),
                );
              },
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 3.w),
                    child: Container(
                      color: Colors.white,
                      padding: EdgeInsets.all(15.sp),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 0.5.h),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 3.h,
                                backgroundColor: Colors.grey[200],
                                child:
                                    item.photo?.isNotEmpty == true
                                        ? ClipOval(
                                          child: CachedNetworkImage(
                                            imageUrl: item.photo!,
                                            width: 6.h,
                                            height: 6.h,
                                            fit: BoxFit.cover,
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
                              SizedBox(width: 1.h),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      (() {
                                        final fullName =
                                            '${item.firstName} ${item.lastName ?? ''}'
                                                .trim();
                                        return fullName.toLowerCase() == 'guest'
                                            ? 'Deleted User'
                                            : fullName;
                                      })(),
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      timeAgo(item.createdAt!),
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        fontStyle: FontStyle.italic,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Spacer(),
                              (authController.isGuest
                                      ? item.guestUserId == userId
                                      : item.createdId == userId)
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
                                              threadId: item.id,
                                              blockedUserName:
                                                  "${item.firstName ?? ""} ${item.lastName ?? ""}",
                                              blockedUserId:
                                                  item.userType == 'guest'
                                                      ? item.guestUserId
                                                      : item.createdId,
                                              blockedUserType: item.userType,
                                            ),
                                      );
                                    },
                                  ),
                            ],
                          ),
                          SizedBox(height: 1.5.h),
                          Text(
                            item.title ?? '',
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF45515C),
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Padding(
                            padding: EdgeInsets.only(right: 10.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Left side: Likes and comments
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        forumController.likeThread(item.id);
                                      },
                                      child: Icon(
                                        item.isLiked!
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        size: 17.sp,
                                        color:
                                            item.isLiked!
                                                ? Colors.red
                                                : Colors.black,
                                      ),
                                    ),
                                    SizedBox(width: 1.5.w),
                                    Text(
                                      '${item.likeCount ?? 0}',
                                      style: TextStyle(fontSize: 14.sp),
                                    ),
                                    SizedBox(width: 6.w),
                                    Image.asset(
                                      'assets/icons/comments.png',
                                      height: 1.5.h,
                                      width: 1.5.h,
                                    ),
                                    SizedBox(width: 1.5.w),
                                    Text(
                                      '${item.commentCount ?? 0} Comments',
                                      style: TextStyle(fontSize: 14.sp),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(color: Colors.grey.shade200, thickness: 1, height: 0),
                  SizedBox(height: 1.h),
                ],
              ),
            );
          },
        ),
      );
    });
  }
}
