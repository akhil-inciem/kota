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