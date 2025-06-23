import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

class ForumShimmerLoader extends StatelessWidget {
  const ForumShimmerLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        children: [
          SizedBox(height: 8.h),

          // User avatar & name
          Row(
            children: [
              CircleAvatar(
                radius: 4.h, // roughly 48px on typical screens
                backgroundColor: Colors.white,
              ),
              SizedBox(width: 3.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 1.5.h,
                    width: 25.w,
                    color: Colors.white,
                  ),
                  SizedBox(height: 0.8.h),
                  Container(
                    height: 1.3.h,
                    width: 20.w,
                    color: Colors.white,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 2.h),

          // Title placeholder
          Container(
            height: 2.h,
            width: 35.w,
            color: Colors.white,
          ),
          SizedBox(height: 1.h),

          // Description placeholders
          Container(
            height: 1.5.h,
            width: double.infinity,
            color: Colors.white,
          ),
          SizedBox(height: 0.7.h),
          Container(
            height: 1.5.h,
            width: double.infinity,
            color: Colors.white,
          ),
          SizedBox(height: 0.7.h),
          Container(
            height: 1.5.h,
            width: 50.w,
            color: Colors.white,
          ),

          SizedBox(height: 2.h),

          // Image Placeholder
          Container(
            height: 45.h,
            width: double.infinity,
            color: Colors.white,
          ),

          SizedBox(height: 2.h),

          // Comments placeholder
          ...List.generate(2, (index) {
            return Padding(
              padding: EdgeInsets.only(bottom: 2.h),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 2.5.h,
                    backgroundColor: Colors.white,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(height: 1.3.h, width: 25.w, color: Colors.white),
                        SizedBox(height: 1.h),
                        Container(height: 1.3.h, width: double.infinity, color: Colors.white),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
