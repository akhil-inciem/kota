import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:kota/constants/colors.dart';
import 'package:kota/views/home/widgets/top_bar.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class MissionPage extends StatelessWidget {
  const MissionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.primaryBackground,
        body: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 6.w,vertical: 2.h),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 5.h),
                    _buildSection(
                      title: "Our Mission",
                      content:
                          "To empower communities with innovative healthcare solutions, ensuring accessibility, quality, and compassion in every service we deliver.",
                    ),
                    SizedBox(height: 5.h),
                    _buildSection(
                      title: "Our Vision",
                      content:
                          "To be a global leader in healthcare excellence, driven by technology, inclusivity, and an unwavering commitment to well-being.",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required String content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryText,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          content,
          style: TextStyle(
            fontSize: 15.sp,
            color: Colors.black87,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}