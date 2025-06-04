import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

class NewDiscussionShimmer extends StatelessWidget {
  const NewDiscussionShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Profile shimmer
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w),
              child: Row(
                children: [
                  ShimmerBox(width: 60, height: 60, shape: BoxShape.circle),
                  SizedBox(width: 4.w),
                  ShimmerBox(width: 40.w, height: 1.5.h),
                ],
              ),
            ),

            SizedBox(height: 5.h),

            // Title shimmer
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 7.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerBox(width: 20.w, height: 1.5.h),
                  SizedBox(height: 1.h),
                  ShimmerBox(width: double.infinity, height: 4.h),
                ],
              ),
            ),

            SizedBox(height: 4.h),

            // Description shimmer
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 7.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerBox(width: 30.w, height: 1.5.h),
                  SizedBox(height: 1.h),
                  ShimmerBox(width: double.infinity, height: 25.h),
                ],
              ),
            ),

            SizedBox(height: 8.h),

            // Image picker placeholder shimmer
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: ShimmerBox(width: 25.w, height: 12.h),
              ),
            ),

            SizedBox(height: 4.h),

            // Submit button shimmer
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w),
              child: ShimmerBox(width: double.infinity, height: 8.h),
            ),
          ],
        ),
      ),
    );
  }
}

class ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final BoxShape shape;

  const ShimmerBox({
    super.key,
    required this.width,
    required this.height,
    this.shape = BoxShape.rectangle,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.withOpacity(0.2),
      highlightColor: Colors.grey.withOpacity(0.3),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey,
          shape: shape,
          borderRadius:
              shape == BoxShape.rectangle ? BorderRadius.circular(10) : null,
        ),
      ),
    );
  }
}
