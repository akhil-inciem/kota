import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:intl/intl.dart';
import 'package:kota/controller/favorite_controller.dart';
import 'package:kota/data/dummy.dart';
import 'package:kota/extensions/badge_extensions.dart';
import 'package:kota/views/forum/widgets/forum_shimmer.dart';
import 'package:kota/views/home/recommended_detail_screen.dart';
import 'package:kota/views/home/widgets/list_shimmer.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class FavoriteList extends StatelessWidget {
  final FavouriteController favouriteController = Get.find<FavouriteController>();

 FavoriteList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (favouriteController.isLoading.value) {
      return const ListShimmer(); // Show shimmer while loading
    }
      final items = favouriteController.filteredList;
        return ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: items.length,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            final item = items[index];
              return GestureDetector(
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => DetailScreen(item: item)),
                  // );
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
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: getBadgeContainerColor(item['badge']),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          item['badge'] ?? 'Badge',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: getBadgeTextColor(item['badge']),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 2.w),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFD3D8FF),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(Icons.calendar_today, color: Color(0xFF2640C8), size: 12),
                                            const SizedBox(width: 4),
                                            Text(
          item['date'] != null 
          ? DateFormat('dd MMM yyyy').format(item['date']) 
          : '', 
          style: const TextStyle(fontSize: 10, color: Color(0xFF2640C8)),
        )
        
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 1.h),
                                  Text(
                                    item['title'] ?? '',
                                    maxLines: 2,
                                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 1.h),
                                  Text(
                                    item['description'] ?? '',
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              width: 24.w,
                              height: 16.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.grey.shade300,
                              ),
                              child: const Image(
                                image: AssetImage('assets/images/recommend_tile.jpg'),
                                fit: BoxFit.fill,
                              ),
                            ),
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
