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
class ForumList extends StatelessWidget {

  final ForumController favouriteController = Get.find<ForumController>();

 ForumList({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (favouriteController.isLoading.value) {
      return const ForumShimmer(); // Show shimmer while loading
    }

      final items = favouriteController.forumItems;
        return ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: DummyData.forumItems.length,
          physics: const AlwaysScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final item = items[index];
            return GestureDetector(
          onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ForumDetailScreen(item: item),
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
                      backgroundImage: NetworkImage('https://i.pravatar.cc/300'),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['name'] ?? '',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            '${item['time'] ?? '0'} hours ago',
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.more_horiz, size: 24.sp, color: Colors.grey),
                  ],
                ),
                SizedBox(height: 1.h),
                Text(
                  item['title'] ?? '',
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
                          Icon(Icons.favorite_border, size: 16, color: AppColors.primaryText),
                          SizedBox(width: 4),
                          Text(
                            '${item['likes'] ?? 0}',
                            style: const TextStyle(fontSize: 12),
                          ),
                          SizedBox(width: 12),
                          Icon(Icons.comment, size: 16, color: Colors.grey),
                          SizedBox(width: 4),
                          Text(
                            '${item['comments'] ?? 0} Comments',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      // Right side: Stacked avatars
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      CircleAvatar(
                        radius: 15,
                        backgroundImage: NetworkImage('https://i.pravatar.cc/300'),
                      ),
                      Positioned(
                        left: 14,
                        child: CircleAvatar(
                          radius: 15,
                          backgroundImage: NetworkImage('https://i.pravatar.cc/300'),
                        ),
                      ),
                      Positioned(
                        left: 26,
                        child: CircleAvatar(
                          radius: 15,
                          backgroundImage: NetworkImage('https://i.pravatar.cc/300'),
                        ),
                      ),
                      Positioned(
                        left: 38,
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                  '10+',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                            ),
                          ),
                        ),
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
        Divider(
          color: Colors.grey.shade200,
          thickness: 1,
          height: 0,
        ),
        SizedBox(height: 1.h),
          ],
        )
        
        );
        },
        );
      }
    );
  }
}

