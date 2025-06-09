import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:kota/constants/colors.dart';
import 'package:kota/controller/home_controller.dart';
import 'package:kota/model/news_model.dart';
import 'package:kota/views/home/widgets/details_shimmer.dart';
import 'package:kota/views/widgets/top_bar.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';

class NewsDetailScreen extends StatefulWidget {
  final String newsId;
  NewsDetailScreen({Key? key, required this.newsId}) : super(key: key);

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  final HomeController homeController = Get.find<HomeController>();
  final ValueNotifier<double> radiusNotifier = ValueNotifier<double>(30.0);
  final ValueNotifier<double> extentNotifier = ValueNotifier(0.6);

  bool _isSharing = false;

  void _handleShare({required String title, required String url}) async {
    if (_isSharing) return;

    _isSharing = true;

    final params = ShareParams(
      title: title,
      uri: Uri.parse(url),
    );
    SharePlus.instance.share(params);

    await Future.delayed(const Duration(milliseconds: 200));
    _isSharing = false;
  }

@override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      homeController.fetchSingleNewsItem(widget.newsId);
    });
  }

 @override
Widget build(BuildContext context) {
  return Obx(() {
    if (homeController.isLoadingNewsItem.value || homeController.selectedNewsItem.value == null) {
      return DetailLoadingPlaceholder();
    }

    final item = homeController.selectedNewsItem.value!;
    final imageUrl = item.newsImage;

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.primaryBackground,
        body: Stack(
          children: [
            // Background image
            Stack(
              children: [
                Container(
  height: 40.h,
  width: double.infinity,
  decoration: BoxDecoration(
    image: DecorationImage(
      image: imageUrl != null && imageUrl.isNotEmpty
          ? CachedNetworkImageProvider(imageUrl)
          : const AssetImage('assets/images/Group 315.png'),
      fit: BoxFit.cover,
    ),
  ),
),

                Container(
                  height: 40.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.8),
                        Colors.transparent,
                        Colors.transparent,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ],
            ),

            // Draggable Scrollable Sheet
            NotificationListener<DraggableScrollableNotification>(
              onNotification: (notification) {
                double extent = notification.extent;
                double percentage = (extent - 0.5) / (1.0 - 0.5);
                double radius = 30 * (1 - percentage.clamp(0.0, 1.0));
                radiusNotifier.value = radius;
                extentNotifier.value = extent;
                return true;
              },
              child: DraggableScrollableSheet(
                initialChildSize: 0.6,
                minChildSize: 0.6,
                maxChildSize: 1,
                builder: (context, scrollController) {
                  return ValueListenableBuilder<double>(
                    valueListenable: radiusNotifier,
                    builder: (context, radius, _) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(radius),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 6.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ValueListenableBuilder<double>(
                                valueListenable: extentNotifier,
                                builder: (context, extent, _) {
                                  double topPadding = lerpDouble(
                                    4.h,
                                    8.h,
                                    ((extent - 0.6) / (1.0 - 0.6))
                                        .clamp(0.0, 1.0),
                                  )!;
                                  return SizedBox(height: topPadding);
                                },
                              ),
                              _dateAndIcons(item),
                              SizedBox(height: 2.h),
                              _title(item),
                              SizedBox(height: 2.h),
                              _profileRow(),
                              SizedBox(height: 2.h),
                              const Divider(color: Colors.grey, thickness: 1, height: 0),
                              SizedBox(height: 1.h),
                              Expanded(
                                child: SingleChildScrollView(
                                  controller: scrollController,
                                  child: _description(item),
                                ),
                              ),
                              SizedBox(height: 5.h),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            // Back Button
            ValueListenableBuilder<double>(
              valueListenable: extentNotifier,
              builder: (context, extent, _) {
                Color iconColor = extent < 0.7
                    ? Colors.white
                    : AppColors.primaryButton;
                return Positioned(
                  top: 1.h,
                  left: 0,
                  right: 10,
                  child: TopBar(
                    title: "",
                    onTap: () => Get.back(),
                    iconColor: iconColor,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  });
}


  Widget _dateAndIcons(NewsDatum item) {
    final title = item.newsTitle ?? 'Check this out!';
    final url = "https://dev.kbaiota.org/news/${item.newsId}";
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                    ? DateFormat('dd MMM yyyy').format(item.newsDate!)
                    : '',
                style: const TextStyle(fontSize: 10, color: Color(0xFF2640C8)),
              ),
            ],
          ),
        ),
        Row(
          children: [
            GestureDetector(
              onTap: () => _handleShare(title: title, url: url),
                child: Image.asset(
                'assets/icons/share.png',
                height: 2.5.h,
                width: 2.5.h, // use 2.h for both to maintain aspect ratio
              ),
            ),
            SizedBox(width: 5.w), // spacing between the images
            Obx(() {
              final isBookmarked =
                  homeController.bookmarkedStatus[item.newsId] ?? false;

              return GestureDetector(
                onTap: () => homeController.toggleBookmark(item.newsId!),
                child: Image.asset(
                  isBookmarked
                      ? 'assets/icons/saved.png'
                      : 'assets/icons/favorites_unselected.png',
                  height: 2.5.h,
                  width: 2.5.h,
                ),
              );
            }),
            SizedBox(width: 3.w),
          ],
        ),
      ],
    );
  }

Widget _loadingPlaceholder() {
  final baseColor = Colors.grey.withOpacity(0.2);
  final highlightColor = Colors.grey.withOpacity(0.3);

  return SafeArea(
    child: Scaffold(
      backgroundColor: AppColors.primaryBackground,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top image shimmer
          Shimmer.fromColors(
            baseColor: baseColor,
            highlightColor: highlightColor,
            child: Container(
              height: 40.h,
              width: double.infinity,
              color: Colors.white,
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(15.sp),
              child: Shimmer.fromColors(
                baseColor: baseColor,
                highlightColor: highlightColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Container(height: 2.5.h, width: 30.w, color: Colors.white),
                    SizedBox(height: 2.h),

                    // Subtitle or short detail
                    Container(height: 2.5.h, width: double.infinity, color: Colors.white),
                    SizedBox(height: 2.h),

                    // Author or another metadata
                    Container(height: 3.h, width: 40.w, color: Colors.white),
                    SizedBox(height: 2.5.h),

                    // Description lines (multiple)
                    ...List.generate(13, (index) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Container(
                            height: 1.5.h,
                            width: double.infinity,
                            color: Colors.white,
                          ),
                        )),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    ),
  );
}


  Widget _title(NewsDatum item) {
    return Text(
      item.newsTitle ?? '',
      style: TextStyle(
        fontSize: 17.sp,
        fontWeight: FontWeight.w700,
        color: Colors.black87,
      ),
    );
  }

  Widget _profileRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const CircleAvatar(
          radius: 20,
          backgroundImage: NetworkImage('https://i.pravatar.cc/300'),
        ),
        const SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'John Alexander',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            Text(
              'President KOTA',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w300,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _description(NewsDatum item) {
    return Text(
      item.newsDescription ?? '',
      style: TextStyle(fontSize: 15.sp, color: Colors.black54),
    );
  }
}
