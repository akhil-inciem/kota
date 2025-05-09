import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:kota/constants/colors.dart';

class ExecutiveCard extends StatelessWidget {
  final Map<String, String> executive;

  const ExecutiveCard({super.key, required this.executive});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Executive Image
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            executive["image"]!,
            width: double.infinity,
            height: 20.h,
            fit: BoxFit.cover,
          ),
        ),

        // Info Section
        Container(
          height: 15.h,
          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
          decoration: BoxDecoration(
            color: AppColors.primaryBackground,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      executive["name"]!,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15.sp,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.share, size: 18.sp),
                    onPressed: () {
                      // TODO: Implement share logic
                    },
                  ),
                ],
              ),
              SizedBox(height: 0.5.h),
              Text(
                executive["phone"]!,
                style: TextStyle(fontSize: 14.sp, color: Colors.black87),
              ),
              SizedBox(height: 0.3.h),
              Text(
                executive["email"]!,
                style: TextStyle(fontSize: 13.sp, color: Colors.black54),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
