import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kota/controller/home_controller.dart';
import 'package:kota/data/dummy.dart';
import 'package:kota/extensions/badge_extensions.dart';
import 'package:kota/views/home/news_detail_screen.dart';
import 'package:kota/views/home/widgets/list_shimmer.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class NewsList extends StatefulWidget {
  final bool isFavourite; // <--- New parameter
  final ScrollController scrollController;

  NewsList({
    Key? key,
    required this.isFavourite,
    required this.scrollController,
  }) : super(key: key);

  @override
  State<NewsList> createState() => _NewsListState();
}

class _NewsListState extends State<NewsList> {
  final HomeController homeController = Get.find<HomeController>();

  String _cleanText(String text) {
    return text
        .replaceAll(RegExp(r'\\[rnt]'), '')
        .replaceAll(RegExp(r'[\r\n\t]+'), ' ')
        .replaceAll(RegExp(r'\s{2,}'), ' ')
        .trim();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (homeController.isLoading.value) {
        return const ListShimmer();
      }

      final items = homeController.filteredNewsItems;

      if (items.isEmpty) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.newspaper, size: 25.sp, color: Colors.grey),
              SizedBox(height: 1.h),
              Text(
                'No News available',
                style: TextStyle(fontSize: 15.sp, color: Colors.black),
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        padding: EdgeInsets.zero,
        controller: widget.scrollController,
        itemCount: items.length,
        physics: AlwaysScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final item = items[index];
          return GestureDetector(
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewsDetailScreen(newsId: item.newsId!),
      ),
    );
  },
  child: Column(
    children: [
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.w),
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.all(12.sp),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD3D8FF),
                        borderRadius: BorderRadius.circular(1.w),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            color: const Color(0xFF2640C8),
                            size: 13.sp,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            item.newsDate != null
                                ? DateFormat('dd MMM yyyy').format(item.newsDate!)
                                : '',
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: const Color(0xFF2640C8),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      item.newsTitle ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      _cleanText(item.newsDescription ?? ''),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 3.w),
              Container(
                width: 24.w,
                height: 15.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(3.w),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(3.w),
                  child: item.newsImage == ''
                      ? Image.asset(
                          'assets/images/recommend_tile.jpg',
                          fit: BoxFit.cover,
                        )
                      : CachedNetworkImage(
                          imageUrl: item.newsImage!,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Center(
                            child: SizedBox(
                              width: 10.w,
                              height: 5.h,
                              child: const CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
      Divider(color: Colors.grey.shade200, thickness: 0.3.h, height: 0),
    ],
  ),
);

        },
      );
    });
  }
}
