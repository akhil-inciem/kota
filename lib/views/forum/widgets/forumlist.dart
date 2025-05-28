import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kota/constants/colors.dart';
import 'package:kota/controller/forum_controller.dart';
import 'package:kota/data/dummy.dart';
import 'package:kota/views/forum/forum_detail_screen.dart';
import 'package:kota/views/forum/widgets/forum_shimmer.dart';
import 'package:kota/views/home/news_detail_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ForumList extends StatefulWidget {
  ForumList({Key? key}) : super(key: key);

  @override
  State<ForumList> createState() => _ForumListState();
}

class _ForumListState extends State<ForumList> {
  final ForumController forumController = Get.find<ForumController>();

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
    } else {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (forumController.isLoading.value) {
        return const ForumShimmer(); // Show shimmer while loading
      }

      final items = forumController.threadsList;
      if (items.isEmpty) {
        return Center(
          child: Text(
            "No Forums Available",
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
        );
      }
      return ListView.builder(
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
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 1.h),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.grey[200],
                              child:
                                  item.photo == null
                                      ? Icon(
                                        Icons.person,
                                        size: 30,
                                        color: Colors.grey,
                                      )
                                      : ClipOval(
                                        child: Image.network(
                                          item.photo!,
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.cover,
                                          loadingBuilder: (
                                            context,
                                            child,
                                            loadingProgress,
                                          ) {
                                            if (loadingProgress == null)
                                              return child;
                                            return Center(
                                              child: SizedBox(
                                                width: 20,
                                                height: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                    ),
                                              ),
                                            );
                                          },
                                          errorBuilder: (
                                            context,
                                            error,
                                            stackTrace,
                                          ) {
                                            return Icon(
                                              Icons.error,
                                              size: 30,
                                              color: Colors.red,
                                            );
                                          },
                                        ),
                                      ),
                            ),

                            SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${item.firstName} ${item.lastName ?? ''}' ??
                                        '',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 0.5.h),
                                  Text(
                                    timeAgo(item.createdAt!),
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          item.title ?? '',
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
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
                                      size: 16,
                                      color:
                                          item.isLiked!
                                              ? Colors.red
                                              : Colors.black,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${item.likeCount ?? 0}',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  const SizedBox(width: 12),
                                  const Icon(
                                    Icons.comment,
                                    size: 16,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${item.commentCount ?? 0} Comments',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                              // Right side: Stacked avatars
                              // Stack(
                              //   clipBehavior: Clip.none,
                              //   children: [
                              //     CircleAvatar(
                              //       radius: 15,
                              //       backgroundImage: NetworkImage(
                              //         'https://i.pravatar.cc/300',
                              //       ),
                              //     ),
                              //     Positioned(
                              //       left: 14,
                              //       child: CircleAvatar(
                              //         radius: 15,
                              //         backgroundImage: NetworkImage(
                              //           'https://i.pravatar.cc/300',
                              //         ),
                              //       ),
                              //     ),
                              //     Positioned(
                              //       left: 26,
                              //       child: CircleAvatar(
                              //         radius: 15,
                              //         backgroundImage: NetworkImage(
                              //           'https://i.pravatar.cc/300',
                              //         ),
                              //       ),
                              //     ),
                              //     Positioned(
                              //       left: 38,
                              //       child: Container(
                              //         width: 30,
                              //         height: 30,
                              //         decoration: BoxDecoration(
                              //           color: Colors.black,
                              //           shape: BoxShape.circle,
                              //         ),
                              //         child: Center(
                              //           child: Text(
                              //             '10+',
                              //             style: TextStyle(
                              //               color: Colors.white,
                              //               fontSize: 8,
                              //               fontWeight: FontWeight.bold,
                              //             ),
                              //           ),
                              //         ),
                              //       ),
                              //     ),
                              //   ],
                              // ),
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
      );
    });
  }
}
