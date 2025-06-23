import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

class ForumShimmer extends StatelessWidget {
  const ForumShimmer({super.key});

  // Reusable shimmer container widget
  Widget shimmerContainer({required double height, required double width, required BorderRadius borderRadius}) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.9),
        borderRadius: borderRadius,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
  itemCount: 6,
  padding: EdgeInsets.zero,
  itemBuilder: (context, index) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 6),
      child: Shimmer.fromColors(
        period: Duration(milliseconds:500),
        baseColor: Colors.grey.withOpacity(0.15),
        highlightColor: Colors.grey.withOpacity(0.25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TOP SECTION: Avatar + Name + Date
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Circle Avatar
                Container(
                  height: 6.h,
                  width: 6.h,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.9),
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 2.w),
                // Name & Date
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    shimmerContainer(
                      height: 2.2.h,
                      width: 30.w,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    SizedBox(height: 0.8.h),
                    shimmerContainer(
                      height: 1.8.h,
                      width: 18.w,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ],
                )
              ],
            ),

            SizedBox(height: 1.h),

            // TITLE SECTION (like a big text block)
            shimmerContainer(
              height: 10.h,
              width: double.infinity,
              borderRadius: BorderRadius.circular(8),
            ),

            SizedBox(height: 1.h),

            // BOTTOM SECTION: Like, Comment + Circle Avatar stack
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Like & Comment blocks
                Row(
                  children: [
                    shimmerContainer(
                      height: 2.5.h,
                      width: 12.w,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    SizedBox(width: 3.w),
                    shimmerContainer(
                      height: 2.5.h,
                      width: 14.w,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: 1.h),
            Divider(thickness: 1, color: Colors.red),
          ],
        ),
      ),
    );
  },
);
  }
}