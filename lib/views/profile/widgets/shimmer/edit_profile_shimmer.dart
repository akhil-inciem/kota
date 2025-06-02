import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

class EditProfileShimmer extends StatelessWidget {
  const EditProfileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(height: 6.h),
          Shimmer.fromColors(
            baseColor: Colors.grey.withOpacity(0.2),
            highlightColor: Colors.grey.withOpacity(0.3),
            child: Container(
              width: 16.h,
              height: 16.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.withOpacity(0.5),
              ),
            ),
          ),
          SizedBox(height: 4.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.w),
            child: Column(
              children: List.generate(4, (index) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 2.5.h),
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey.withOpacity(0.2),
                    highlightColor: Colors.grey.withOpacity(0.3),
                    child: Container(
                      height: 6.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey.withOpacity(0.5),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

