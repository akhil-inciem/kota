import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:intl/intl.dart';
import 'package:kota/controller/favorite_controller.dart';
import 'package:kota/extensions/badge_extensions.dart';
import 'package:kota/views/favourites/favorite_detail_screen.dart';
import 'package:kota/views/home/widgets/list_shimmer.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class FavoriteList extends StatefulWidget {
  FavoriteList({Key? key}) : super(key: key);

  @override
  State<FavoriteList> createState() => _FavoriteListState();
}

class _FavoriteListState extends State<FavoriteList> {
  final FavouriteController favController = Get.find<FavouriteController>();

  String _htmlToPlainText(String htmlString) {
    final document = html_parser.parse(htmlString);
    return document.body?.text.trim() ?? '';
  }

  @override
  void initState() {
    super.initState();
    favController.fetchFilteredItems();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (favController.isLoading.value) {
        return const ListShimmer();
      } else if (favController.filteredList.isEmpty) {
        return RefreshIndicator(
          onRefresh: () async => await favController.fetchFilteredItems(),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              SizedBox(height: 20.h),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/icons/favorites_unselected.png',
                      height: 8.h,
                      width: 8.h,
                    ),
                    SizedBox(height: 1.5.h),
                    Text(
                      "No Favourites Available",
                      style: TextStyle(fontSize: 18.sp, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }

      final items = favController.filteredList;

      return RefreshIndicator(
        onRefresh: () async => await favController.fetchFilteredItems(),
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
                    builder: (context) => FavoritesDetailScreen(item: item),
                  ),
                );
              },
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Container(
                      color: Colors.white,
                      padding: EdgeInsets.all(2.w),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    item['badge'] == "" ? SizedBox.shrink(): Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 2.w,
                                        vertical: 0.5.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: getBadgeContainerColor(
                                          item['badge'],
                                        ),
                                        borderRadius: BorderRadius.circular(2.w),
                                      ),
                                      child: Text(
                                        item['badge'] ?? 'Badge',
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: getBadgeTextColor(item['badge']),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 1.w),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 2.w,
                                        vertical: 0.5.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFD3D8FF),
                                        borderRadius: BorderRadius.circular(2.w),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.calendar_today,
                                            color: const Color(0xFF2640C8),
                                            size: 12.sp,
                                          ),
                                          SizedBox(width: 1.w),
                                          Text(
                                            item['date'] != null
                                                ? DateFormat('dd MMM yyyy')
                                                    .format(item['date'])
                                                : '',
                                            style: TextStyle(
                                              fontSize: 12.sp,
                                              color: const Color(0xFF2640C8),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 1.h),
                                Text(
                                  item['title'] ?? '',
                                  maxLines: 2,
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 1.h),
                                Text(
                                  _htmlToPlainText(item['description'] ?? ''),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Container(
                            width: 24.w,
                            height: 15.h,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(3.w),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(3.w),
                              child: item['image'] == ''
                                  ? Image.asset(
                                      'assets/images/recommend_tile.jpg',
                                      fit: BoxFit.cover,
                                    )
                                  : CachedNetworkImage(
                                      imageUrl: item['image'],
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                          const SizedBox(),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.grey.shade200,
                    thickness: 0.2.h,
                    height: 0,
                  ),
                ],
              ),
            );
          },
        ),
      );
    });
  }
}
