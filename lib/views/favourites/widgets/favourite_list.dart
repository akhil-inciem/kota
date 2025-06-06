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
  initState() {
    // TODO: implement initState
    super.initState();
    // favController.fetchFilteredItems();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (favController.isLoading.value) {
        return const ListShimmer(); // Show shimmer while loading
      } else if (favController.filteredList.isEmpty) {
        return RefreshIndicator(
          onRefresh: () async {
          await favController
              .fetchFilteredItems(); // Replace with your actual method
        },
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              SizedBox(height: 20.h), // add space to allow pull
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/icons/favorites_unselected.png',
                      height: 8.h,
                      width: 8.h,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "No Favourites Available",
                      style: TextStyle(fontSize: 18, color: Colors.black),
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
        onRefresh: () async {
          await favController
              .fetchFilteredItems(); // Replace with your actual method
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
                    builder: (context) => FavoritesDetailScreen(item: item),
                  ),
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
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: getBadgeContainerColor(
                                          item['badge'],
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        item['badge'] ?? 'Badge',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: getBadgeTextColor(
                                            item['badge'],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 2.w),
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
                                            item['date'] != null
                                                ? DateFormat(
                                                  'dd MMM yyyy',
                                                ).format(item['date'])
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
                                  item['title'] ?? '',
                                  maxLines: 2,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 1.h),
                                Text(
                                  _htmlToPlainText(item['description'] ?? ''),
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
                              child:
                                  item['image'] == ''
                                      ? Image.asset(
                                        'assets/images/recommend_tile.jpg',
                                        fit:
                                            BoxFit
                                                .cover, // Ensure the image fits inside the box
                                      )
                                      : CachedNetworkImage(
                                        imageUrl: item['image'],
                                        fit: BoxFit.cover,
                                        placeholder:
                                            (context, url) => Center(
                                              child: SizedBox.fromSize(),
                                            ),
                                        errorWidget:
                                            (context, url, error) =>
                                                const Icon(Icons.error),
                                      ),
                            ),
                          ),
                          // Container(
                          //   width: 24.w,
                          //   height: 16.h,
                          //   decoration: BoxDecoration(
                          //     borderRadius: BorderRadius.circular(15),
                          //     color: Colors.grey.shade300,
                          //   ),
                          //   child:  Image(
                          //     image: NetworkImage(
                          //       item['image'],
                          //     ),
                          //     fit: BoxFit.fill,
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                  Divider(color: Colors.grey.shade200, thickness: 1, height: 0),
                ],
              ),
            );
          },
        ),
      );
    });
  }
}
