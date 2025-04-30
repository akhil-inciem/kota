import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kota/controller/home_controller.dart';
import 'package:kota/data/dummy.dart';
import 'package:kota/extensions/badge_extensions.dart';
import 'package:kota/views/home/recommended_detail_screen.dart';
import 'package:kota/views/home/widgets/list_shimmer.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class RecommendedList extends StatelessWidget {
  final bool isFavourite; // <--- New parameter
  final ScrollController scrollController; 
  final HomeController homeController = Get.find<HomeController>();

   RecommendedList({Key? key, required this.isFavourite,required this.scrollController})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (homeController.isLoading.value) {
      return const ListShimmer(); // Show shimmer while loading
    }

      final items = homeController.newsItems;

      if (items.isEmpty) {
        return Center(
          child: Text(
            'No News available',
            style: TextStyle(
              fontSize: 18,
              color: Colors.black,
            ),
          ),
        );
      }

      return ListView.builder(
        padding: EdgeInsets.zero,
        controller: scrollController,
        itemCount: items.length,
        physics: AlwaysScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final item = items[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DetailScreen(item: item)),
                );
              },
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  // <-- Wrap both containers in a Row
                                  children: [
                                    if (isFavourite) ...[
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: getBadgeContainerColor(
                                            item.badges,
                                          ),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          item.badges ?? 'Badge', // Badge Text
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: getBadgeTextColor(item.badges),
                                          ),
                                        ),
                                      ),
        
                                      SizedBox(width: 2.w),
                                    ],
        
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFD3D8FF),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.calendar_today,
                                            color: Color(0xFF2640C8),
                                            size: 12,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            item.newsDate != null
                                                ? DateFormat(
                                                  'dd MMM yyyy',
                                                ).format(item.newsDate!)
                                                : '',
                                            style: const TextStyle(
                                              fontSize: 10,
                                              color: Color(0xFF2640C8),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 1.h),
                                Text(
                                  item.newsTitle ?? '',
                                  maxLines: 2,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 1.h),
                                Text(
                                  item.newsDescription ?? '',
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                         Container(
  width: 24.w,
  height: 15.h,
  decoration: BoxDecoration(
    color: Colors.grey.shade300,
    borderRadius: BorderRadius.circular(15),
  ),
  child: ClipRRect(
    borderRadius: BorderRadius.circular(15),
    child: item.newsImage == ''
        ? Image.asset(
            'assets/images/recommend_tile.jpg',
            fit: BoxFit.cover, // Ensure the image fits inside the box
          )
        : Image.network(
            item.newsImage!,
            fit: BoxFit.cover, // Ensure the image fits inside the box
          ),
  ),
)


                        ],
                      ),
                    ),
                  ),
                  Divider(color: Colors.grey.shade200, thickness: 1, height: 0),
                ],
              ),
            );
          },
        );
      }
    );
  }
}
