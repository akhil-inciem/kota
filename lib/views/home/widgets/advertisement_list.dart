import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kota/controller/home_controller.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:shimmer/shimmer.dart';

class AdvertisementList extends StatefulWidget {
  @override
  _AdvertisementListState createState() => _AdvertisementListState();
}

class _AdvertisementListState extends State<AdvertisementList> {
  final PageController _pageController = PageController();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    startAutoSlide();
  }

  void startAutoSlide() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      final controller = Get.find<HomeController>();
      final totalAds = controller.advertisements.length;
      if (totalAds > 1 && _pageController.hasClients) {
        final nextPage = (controller.currentAdIndex.value + 1) % totalAds;
        controller.currentAdIndex.value = nextPage;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 1500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Obx(() {
      final advertisements = controller.advertisements;

      if (advertisements.isEmpty) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 3.w),
          child: SizedBox(
            height: 22.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              itemBuilder: (context, index) => const ShimmerCard(),
            ),
          ),
        );
      }

      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 3.w),
        child: SizedBox(
          height: 22.h, // total height including PageView and dots
          child: Column(
            children: [
              SizedBox(
                height: 20.5.h,
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context).copyWith(
                    scrollbars: false,
                    overscroll: false,
                    physics:
                        const ClampingScrollPhysics(), // disables iOS bouncing
                  ),
                  child: PageView.builder(
                    key: PageStorageKey('advertisement_page_view'),
                    controller: _pageController,
                    itemCount: advertisements.length,
                    onPageChanged: (index) {
                      controller.currentAdIndex.value = index;
                    },
                    itemBuilder: (context, index) {
                      final ad = advertisements[index];
                      return AdvertisementCard(imageUrl: ad.advtImage ?? '');
                    },
                  ),
                ),
              ),
              if (advertisements.length > 1)
                Obx(() {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(advertisements.length, (index) {
                      final isActive = index == controller.currentAdIndex.value;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        margin: EdgeInsets.symmetric(horizontal: 1.w),
                        width: isActive ? 3.w : 2.w,
                        height: 1.h,
                        decoration: BoxDecoration(
                          color: isActive ? Colors.black : Colors.grey,
                          borderRadius: BorderRadius.circular(1.w),
                        ),
                      );
                    }),
                  );
                }),
            ],
          ),
        ),
      );
    });
  }
}

class AdvertisementCard extends StatelessWidget {
  final String imageUrl;

  const AdvertisementCard({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(2.w),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(3.w),
        child: Container(
          width: 90.w,
          height: 20.h,
          color: Colors.grey[300],
          child:
              imageUrl.isNotEmpty
                  ? CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.fill,
                    width: double.infinity,
                    height: double.infinity,
                    placeholder:
                        (context, url) => Container(color: Colors.grey[300]),
                    errorWidget:
                        (context, url, error) =>
                            const Icon(Icons.error, color: Colors.red),
                  )
                  : Center(
                    child: Text("No Image", style: TextStyle(fontSize: 12.sp)),
                  ),
        ),
      ),
    );
  }
}

class ShimmerCard extends StatelessWidget {
  const ShimmerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(2.w),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(3.w),
        child: Shimmer.fromColors(
          baseColor: Colors.grey.withOpacity(0.15),
          highlightColor: Colors.grey.withOpacity(0.25),
          child: Container(width: 90.w, height: 16.h, color: Colors.white),
        ),
      ),
    );
  }
}
