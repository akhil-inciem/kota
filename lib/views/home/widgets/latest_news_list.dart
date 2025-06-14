import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kota/controller/home_controller.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:shimmer/shimmer.dart';

class AdvertisementList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final controller = Get.find<HomeController>();
      final advertisements = controller.advertisements;

      if (advertisements.isEmpty) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 3.w),
          child: SizedBox(
            height: 20.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 3, // Number of shimmer cards to show
              itemBuilder: (context, index) {
                return const ShimmerCard();
              },
            ),
          ),
        );
      }

      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 3.w),
        child: SizedBox(
          height: 20.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: advertisements.length,
            itemBuilder: (context, index) {
              final ad = advertisements[index];
              return AdvertisementCard(imageUrl: ad.advtImage ?? '');
            },
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
      padding: const EdgeInsets.all(8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 85.w,
          height: 16.5.h,
          color: Colors.grey[300],
          child:
              imageUrl.isNotEmpty
                  ? CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    placeholder:
                        (context, url) => Container(color: Colors.grey[300]),
                    errorWidget:
                        (context, url, error) =>
                            const Icon(Icons.error, color: Colors.red),
                  )
                  : const Center(child: Text("No Image")),
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
      padding: const EdgeInsets.all(8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Shimmer.fromColors(
          baseColor: Colors.grey.withOpacity(0.15),
          highlightColor: Colors.grey.withOpacity(0.25),
          child: Container(width: 90.w, height: 16.5.h, color: Colors.white),
        ),
      ),
    );
  }
}
