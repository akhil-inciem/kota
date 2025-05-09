import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kota/constants/colors.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class MissionPage extends StatelessWidget {
  const MissionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.primaryBackground,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  InkWell(
                    onTap: () => Get.back(),
                    child: Image.asset(
                      'assets/icons/backbutton.png',
                      color: Colors.black,
                      width: 6.w,
                      height: 2.5.h,
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    "Vision & Mission",
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 3.h),

              // Scrollable content
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildInfoCard(
                        title: "Our Mission",
                        content:
                            "To empower communities with innovative healthcare solutions, ensuring accessibility, quality, and compassion in every service we deliver.",
                      ),
                      SizedBox(height: 3.h),
                      _buildInfoCard(
                        title: "Our Vision",
                        content:
                            "To be a global leader in healthcare excellence, driven by technology, inclusivity, and an unwavering commitment to well-being.",
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({required String title, required String content}) {
  return Container(
    width: double.infinity,
    padding: EdgeInsets.all(4.w),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.15),
          blurRadius: 6,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // For "Our Mission" with colored arrows on both sides
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // First arrow (blue)
            Icon(Icons.arrow_forward_ios, size: 16.sp, color: Colors.blue),
            // Second arrow (light grey)
            Icon(Icons.arrow_forward_ios, size: 16.sp, color: Colors.grey.withOpacity(0.5)),
            // Third arrow (blue)
            Icon(Icons.arrow_forward_ios, size: 16.sp, color: Colors.blue),
            SizedBox(width: 1.w),
            Text(
              title,
              style: TextStyle(
                fontSize: 17.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryText,
              ),
            ),
            SizedBox(width: 1.w),
            // First arrow (blue)
            Icon(Icons.arrow_back_ios_new, size: 16.sp, color: Colors.blue),
            // Second arrow (light grey)
            Icon(Icons.arrow_back_ios_new, size: 16.sp, color: Colors.grey.withOpacity(0.5)),
            // Third arrow (blue)
            Icon(Icons.arrow_back_ios_new, size: 16.sp, color: Colors.blue),
          ],
        ),

        SizedBox(height: 1.h),
        Text(
          content,
          style: TextStyle(
            fontSize: 15.sp,
            color: Colors.black87,
            height: 1.6,
          ),
        ),
      ],
    ),
  );
}
}