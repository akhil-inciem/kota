import 'package:flutter/material.dart';
import 'package:kota/constants/colors.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

class DetailLoadingPlaceholder extends StatelessWidget {
  const DetailLoadingPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
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
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(8),
                  ),
                ),
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
                      _shimmerBox(height: 2.5.h, width: 30.w),
                      SizedBox(height: 2.h),

                      // Subtitle
                      _shimmerBox(height: 2.5.h, width: double.infinity),
                      SizedBox(height: 2.h),

                      // Author/meta
                      Row(
                        children: [
                          CircleAvatar(),
                          SizedBox(width: 4.w,),
                          _shimmerBox(height: 3.h, width: 40.w),
                        ],
                      ),
                      SizedBox(height: 2.5.h),

                      // Description lines
                      ...List.generate(13, (index) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _shimmerBox(height: 1.5.h, width: double.infinity),
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

  // Reusable shimmer box widget with borderRadius
  Widget _shimmerBox({required double height, required double width}) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
