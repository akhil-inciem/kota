import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

class ListShimmer extends StatelessWidget {
  const ListShimmer({super.key});

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
      itemCount: 6, // Show 6 shimmer items
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Shimmer.fromColors(
            baseColor: Colors.grey.withOpacity(0.15),
        highlightColor: Colors.grey.withOpacity(0.25),
            child: Column(
              children: [
                Row(
                  children: [
                    // Left side - Date, Title, Description
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Shimmer for Date (left side)
                          shimmerContainer(
                            height: 2.5.h, 
                            width: 9.h, 
                            borderRadius: BorderRadius.circular(6),
                          ),
                          SizedBox(height: 1.h), 
                
                          // Shimmer for Title (left side)
                          shimmerContainer(
                            height: 5.h, 
                            width: double.infinity,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          SizedBox(height: 1.h), 
                
                          // Shimmer for Description (left side)
                          shimmerContainer(
                            height: 8.h, 
                            width: double.infinity,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ],
                      ),
                    ),
                
                    SizedBox(width: 4.w), 
                
                    // Right side - Image (trailing image)
                    shimmerContainer(
                      height: 17.h, 
                      width: 10.h, 
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ],
                ),
                SizedBox(height: 1.h,),
                Divider(
                  thickness: 1,
                  color: Colors.red,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
class FaqShimmer extends StatelessWidget {
  const FaqShimmer({super.key});

  Widget shimmerContainer({
    required double height,
    required double width,
    required BorderRadius borderRadius,
  }) {
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top shimmer containers before list
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
          child: Shimmer.fromColors(
            baseColor: Colors.grey.withOpacity(0.15),
            highlightColor: Colors.grey.withOpacity(0.25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 3.h),
                shimmerContainer(
                  height: 5.h,
                  width: 60.w,
                  borderRadius: BorderRadius.circular(8),
                ),
                SizedBox(height: 2.h),
                shimmerContainer(
                  height: 5.h,
                  width: 20.w,
                  borderRadius: BorderRadius.circular(8),
                ),
              ],
            ),
          ),
        ),

        // Shimmer list
        Expanded(
          child: ListView.builder(
            itemCount: 6,
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
                child: Shimmer.fromColors(
                  baseColor: Colors.grey.withOpacity(0.15),
                  highlightColor: Colors.grey.withOpacity(0.25),
                  child: Row(
                    children: [
                      // Left: Circle avatar shimmer
                      Container(
                        height: 30.sp,
                        width: 30.sp,
                        decoration: const BoxDecoration(
                          color: Colors.grey,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 12),

                      // Center: Text shimmer
                      Expanded(
                        child: shimmerContainer(
                          height: 10.h,
                          width: 40.w,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

